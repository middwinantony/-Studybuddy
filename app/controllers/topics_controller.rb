class TopicsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @topics = Topic.all
  end

  def show
    @topic = Topic.find(params[:id])
  end

  def show_answer
    @topic = Topic.find(params[:id])
    @question_text = params[:question]
    @user_answer = params[:user_answer]
    @result = params[:result]
    @correct_answer = params[:correct_answer]
  end

  def start_quiz
    @topic = Topic.find(params[:id])
    chat = RubyLLM.chat
    prompt = "Generate a single, simple #{ @topic.name } question suitable for a beginner. Only provide the question, no answers or explanations."
    response = chat.ask(prompt)
    @question_text = response.content || response.text || response["choices"][0]["message"]["content"]
    render "quiz"
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
