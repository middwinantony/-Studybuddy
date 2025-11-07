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
    if @message.save
      @response = RubyLLM.chat.with_instructions(instructions).ask(@message.content)
      Message.create(role: "assistant", content: @response.content, chat: @chat)
      redirect_to chat_path(@chat)
    else
      render "chats/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def instructions
    [SYSTEM_PROMPT, challenge_context, @chat.topic.system_prompt].compact.join("\n\n")
  end
end
