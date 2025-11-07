class MessagesController < ApplicationController
  SYSTEM_PROMPT = <<~PROMPT
    You are a friendly quiz master AI.
     You ask the user one question at a time on a given topic.
     When the user responds, evaluate their answer:
     - If correct, praise them and give the next question.
     - If wrong, explain briefly why and then give the next question.
     Keep your messages short and conversational.
  PROMPT

  def create
    @chat = Chat.find(params[:chat_id])
    @message = Message.new(message_params)
    @message.role = "user"
    @message.chat = @chat
    if @message.valid?
      # @chat.with_instructions(instructions).ask(@message.content)
      # @chat.generate_title_from_first_message
      respond_to do |format|
        format.turbo_stream # renders `app/views/messages/create.turbo_stream.erb`
        format.html { redirect_to chat_path(@chat) }
      end
      # build_conversation_history
      # @response = RubyLLM.chat.with_instructions(instructions).ask(@message.content)
      # Message.create(role: "assistant", content: @response.content, chat: @chat)

    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("new_message", partial: "messages/form",
                                                                   locals: { chat: @chat, message: @message })
        end
        format.html { render "chats/show", status: :unprocessable_entity }
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def instructions
    [SYSTEM_PROMPT, challenge_context, @chat.topic.system_prompt].compact.join("\n\n")
  end

  def send_answer(model: "gpt-4.1-nano", with: {})
  end

  def build_conversation_history
    @ruby_llm_chat = RubyLLM.chat
    @chat.messages.each do |message|
      @ruby_llm_chat.add_message(message)
    end
  end
end
