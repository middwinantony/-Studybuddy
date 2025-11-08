class MessagesController < ApplicationController
  def create
    @chat = Chat.find(params[:chat_id])
    @message = @chat.messages.new(message_params.merge(role: "user"))

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
      # 1️⃣ Get feedback to user’s answer
      feedback_prompt = <<~PROMPT
        The user answered: "#{@message.content}".
        Evaluate if it’s correct for the previous question.
        Respond with:
        - “Correct!” if right, or “Incorrect. The correct answer is …”
        - Then immediately give the next question (if under 5 total).
      PROMPT

      response = @chat.ask(feedback_prompt)
      Message.create!(chat: @chat, role: "assistant",  message_type: "question", content: response.content)

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
