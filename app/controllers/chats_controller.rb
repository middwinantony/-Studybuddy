class ChatsController < ApplicationController
  def index
    @topic = Topic.find(params[:topic_id])
    @chats = current_user.chats.where(challenge: @challenge)
    @chat = Chat.new
  end

  def show
    @chat = Chat.includes(:messages).find(params[:id])
    if Rails.env.development?
      @input_tokens = @chat.messages.pluck(:input_tokens).compact.sum
      @output_tokens = @chat.messages.pluck(:output_tokens).compact.sum
      @context_window = RubyLLM.models.find(@chat.model_id).context_window
    end
    @message = Message.new
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

  def check_answer
  end
end
