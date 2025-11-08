class TopicsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    @topics = Topic.all
  end

  def show
    @topic = Topic.find(params[:id])
  end

  def start_quiz
    @topic = Topic.find(params[:id])

    # Create a new Chat for this quiz
    @chat = Chat.create!(
      title: "Quiz on #{@topic.name}",
      model_id: "gpt-4.1-nano",
      user: current_user,
      topic: @topic
    )

    # Generate the first AI question automatically
    initial_prompt = <<~PROMPT
      You are a quiz generator. Generate a beginner-friendly quiz question for the topic: #{@topic.name}.
      Format the question as plain text.
    PROMPT

    # Use RubyLLM to generate the question and save as assistant message
    if @chat.present?
      response = @chat.with_instructions("You are Studybuddy AI. Provide beginner-friendly questions.").ask(initial_prompt)
      Message.create!(chat: @chat, role: "assistant", content: response.content)
    end

    redirect_to chat_path(@chat)
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new(topic_params)
    if @topic.save
      redirect_to topic_path(@topic)
    else
      render :new
    end
  end

  def edit
    @topic = Topic.find(params[:id])
  end

  def update
    @topic = Topic.find(params[:id])
    if @topic.update(topic_params)
      redirect_to topics_path
    else
      render :edit
    end
  end

  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy
    redirect_to topics_path, status: :see_other
  end

  private

  def topic_params
    params.require(:topic).permit(:name, :description, :image)
  end
end
