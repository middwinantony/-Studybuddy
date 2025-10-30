class TopicsController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
    @topics = Topic.all
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
    params.require(:topic).permit(:name, :description)
  end
end
