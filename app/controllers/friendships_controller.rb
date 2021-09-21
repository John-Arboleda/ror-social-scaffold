class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    invitation_receiver = User.find(params[:invitation_receiver_id])
    current_user.friendship_request(invitation_receiver) if invitation_receiver
    redirect_to user_path(params[:invitation_receiver_id])
  end

  def update
    current_user.accept_request(Friendship.find(params[:id]).invitation_sender)
    redirect_to users_path
  end

  def destroy
    current_user.reject_request(Friendship.find(params[:id]).invitation_sender)
    redirect_to users_path
  end
end
