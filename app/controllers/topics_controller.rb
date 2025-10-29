class TopicsController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
    @topics = Topic.all
  end
end
