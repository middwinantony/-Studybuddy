class ChatsController < ApplicationController
  # before_action :authenticate_user!
  before_action :set_topic, only: [:index, :create]
  before_action :set_chat, only: [:show, :destroy]

  def index
    @chats = current_user.chats.where(topic: @topic)
    @chat = Chat.new
  end

  def create
    @topic = Topic.find(params[:topic_id])
    @chat = Chat.new(
      name: chat_params[:name],
      title: chat_params[:name].presence || "Untitled",
      model_id: "gpt-4.1-nano",
      user: current_user,
      topic: @topic
    )
    # @chat = Chat.new(title: "Untitled", model_id: "gpt-4.1-nano", user: current_user, topic: @topic)
    # @chat.topic = @topic
    # @chat.user = current_user

    if @chat.save
      first_question_prompt = "Generate the first quiz question for the topic #{@topic.name}."
      response = @chat.with_instructions(chat_instructions).ask(first_question_prompt)
      clean_content = response.content.gsub(/^#{Regexp.escape(instructions)}/, '').strip

      Message.create!(content: clean_content, message_type: "question", role: "assistant", chat: @chat)
      redirect_to chat_path(@chat)
    else
      render :index
    end
  end

  def show
    @chat = Chat.includes(:messages).find(params[:id])
    @message = Message.new

    if Rails.env.development?
      @input_tokens  = @chat.messages.pluck(:input_tokens).compact.sum
      @output_tokens = @chat.messages.pluck(:output_tokens).compact.sum
      @context_window = RubyLLM.models.find(@chat.model_id).context_window
    end
  end

  def destroy
    if @chat.user == current_user
      @chat.destroy
      redirect_to topic_chats_path(@chat.topic), notice: "Quiz session deleted successfully."
    else
      redirect_to topic_chats_path(@chat.topic), alert: "You are not authorized to delete this session."
    end
  end

  private

  def set_chat
    @chat = Chat.find(params[:id])
  end

  def chat_params
    params.require(:chat).permit(:name)
  end

  def set_topic
    @topic = Topic.find(params[:topic_id])
  end

  def chat_instructions
    "You are a quiz master who generates questions one by one related to the selected topic."
  end
end
