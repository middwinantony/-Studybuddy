class MessagesController < ApplicationController
  def create
    @chat = Chat.find(params[:chat_id])
    @message = Message.new(message_params)
    @message.role = "user"
    @message.chat = @chat
    if @message.save
      redirect_to chat_path(@chat)
    else
      @chat = Chat.find(params[:chat_id])
      render "chats/show", status: :unprocessable_entity, locals: { chat: @chat, message: @message }

    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
