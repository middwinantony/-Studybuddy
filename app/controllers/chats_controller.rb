class ChatsController < ApplicationController
  def show
    @chat = Chat.find(params[:id])
  end

  def new

  end
end
