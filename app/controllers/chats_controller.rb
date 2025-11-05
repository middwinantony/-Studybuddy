class ChatsController < ApplicationController

  def index
    @topic = Topic.find(params[:id])
    @chats = current_user.chats.where(challenge: @challenge)
    @chat = Chat.new
  end

  def show
    @chat = Chat.find(params[:id])
  end

  def new
  end
end
