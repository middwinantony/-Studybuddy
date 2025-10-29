class TopicsController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
  end

  def index
    @topics = Topic.all
  end

  def show
    @topic = Topic.find(params[:id])
  end
end
