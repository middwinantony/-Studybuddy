class ChatsController < ApplicationController
  def index
    @topic = Topic.find(params[:topic_id])
    @chats = current_user.chats.where(challenge: @challenge)
    @chat = Chat.new
  end

  def show
    @chat = Chat.find(params[:id])
    @message = Message.new
  end

  def new
  end

  def create
    @topic = Topic.find(params[:topic_id])
    @chat = Chat.new(title: "Untitled", model_id: "gpt-4.1-nano")
    @chat.topic = @topic
    @chat.user = current_user
    if @chat.save
      redirect_to chat_path(@chat)
    else
      render :index
    end
  end
end
