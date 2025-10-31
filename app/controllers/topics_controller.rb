class TopicsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    @topics = Topic.all
  end

  def show
    @topic = Topic.find(params[:id])
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
    @topic.update(topic_params)
    redirect_to topic_path(@topic)
  end

  def destroy
    @topic = Topic.find(params[:id])
    @topic.destroy
    redirect_to topic_path, status: :see_other
  end
  # def edit
  #   @topic = Topic.find(params[:id])
  # end

  # def update
  #   @topic = Topic.find(params[:id])
  #   if @topic.update(topic_params)
  #     redirect_to topic_path(@topic)
  #   else
  #     render :edit
  #   end
  # end

  private

  def topic_params
    params.require(:topic).permit(:name, :description, :image_id)
  end
end
