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
end
