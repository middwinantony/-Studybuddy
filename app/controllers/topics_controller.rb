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
    first_question_prompt = "Generate the first quiz question for the topic #{@topic.name}."

    # Use RubyLLM to generate the question (it saves messages automatically)
    if @chat.present?
      @chat.with_instructions("You are a quiz master who generates questions one by one related to the selected topic.").ask(first_question_prompt)

      # Force reload the entire chat to get fresh messages
      @chat.reload
      # Mark ALL untyped assistant messages as questions (handles duplicates)
      @chat.messages.where(role: "assistant", message_type: [nil, ""]).update_all(message_type: "question")
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
