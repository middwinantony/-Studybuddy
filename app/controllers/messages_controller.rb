class MessagesController < ApplicationController
  def create
    @chat = Chat.find(params[:chat_id])
    @message = @chat.messages.new(message_params.merge(role: "user", message_type: "answer"))

    # @message = Message.new(message_params)
    # @message.role = "user"
    # @message.chat = @chat

  #   if @message.valid?
  #   # Ask AI and persist assistant response automatically
  #     @chat.with_instructions(instructions).ask(@message.content)

  #     # Generate next question if under limit
  #     if @chat.questions_remaining?
  #       next_prompt = <<~PROMPT
  #         Generate the next beginner-friendly quiz question for the topic: #{@chat.topic.name}.
  #         Make sure it's different from previous questions.
  #       PROMPT

  #       next_question = @chat.with_instructions("You are Studybuddy AI. Provide beginner-friendly questions.").ask(next_prompt)
  #       Message.create!(chat: @chat, role: "assistant", content: next_question.content)
  #     end

  #     redirect_to chat_path(@chat)
  #   else
  #     render "chats/show", status: :unprocessable_entity
  #   end
  # end

  # private

  # def message_params
  #   params.require(:message).permit(:content)
  # end

  # def instructions
  #   topic_name = @chat.topic.name rescue "General Knowledge"
  #   <<~PROMPT
  #     You are Studybuddy AI, an interactive quiz bot.
  #     The topic of this quiz is "#{topic_name}".
  #     - Always generate one question at a time related strictly to this topic.
  #     - Wait for the user's answer.
  #     - After each user answer, evaluate it as "Correct" or "Incorrect" and show the correct answer.
  #     - Then, automatically generate the next question on the same topic.
  #     - Do NOT change topics or ask about unrelated subjects.
  #   PROMPT
  # end
  if @message.save
      # 1️⃣ Get feedback on user's answer
      feedback_prompt = <<~PROMPT
        The user answered: "#{@message.content}".
        Evaluate if it's correct for the previous question.
        Respond ONLY with:
        - "Correct! [brief explanation]" if right
        - "Incorrect. The correct answer is [answer]. [brief explanation]" if wrong
      PROMPT

      # Remember the last assistant message ID before generating feedback
      last_msg_id_before_feedback = @chat.messages.where(role: "assistant").maximum(:id) || 0

      @chat.ask(feedback_prompt)
      @chat.reload

      # Mark new assistant messages (after last_msg_id) as feedback
      @chat.messages.where(role: "assistant", message_type: [nil, ""])
                    .where("id > ?", last_msg_id_before_feedback)
                    .update_all(message_type: "feedback")

      # 2️⃣ Generate next question if under MAX_QUESTIONS
      if @chat.questions_remaining?
        # Remember the last assistant message ID before generating question
        last_msg_id_before_question = @chat.messages.where(role: "assistant").maximum(:id) || 0

        next_question_prompt = "Generate the next quiz question for the topic #{@chat.topic.name}. Make it different from previous questions."
        @chat.with_instructions("You are a quiz master who generates questions one by one related to the selected topic.").ask(next_question_prompt)
        @chat.reload

        # Mark new assistant messages (after last_msg_id) as questions
        @chat.messages.where(role: "assistant", message_type: [nil, ""])
                      .where("id > ?", last_msg_id_before_question)
                      .update_all(message_type: "question")
      end

      redirect_to chat_path(@chat)
    else
      render "chats/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
