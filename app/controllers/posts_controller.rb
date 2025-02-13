class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @post = Post.new
    timeline_posts
  end

  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      redirect_to posts_path, notice: 'Post successfully created.'
    else
      timeline_posts
      render :index, alert: 'Something went wrong, Post was not created.'
    end
  end

  private

  def timeline_posts
    target_posts = []
    # current_user.sender_friends_id.each do |friend_id|
    #   target_posts << Post.where(user_id: friend_id).all
    # end
    # current_user.receiver_friends_id.each do |friend_id|
    #   target_posts << Post.where(user_id: friend_id).all
    # end
    current_user.friends.each do |friend|
      target_posts << friend.posts
    end
    target_posts << current_user.posts
    @timeline_posts ||= target_posts.flatten.sort_by(&:updated_at).reverse
  end

  def post_params
    params.require(:post).permit(:content)
  end
end
