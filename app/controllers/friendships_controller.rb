class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def index
    @friendships = current_user.receivers.where(status: 0).all
  end

  def create
    @friendship = current_user.senders.new(receiver_id: params[:receiver_id])

    if @friendship.save
      redirect_to users_path, notice: 'Invitation sent!'
    else
      redirect_to users_path, alert: @friendship.errors.full_messages.join('. ').to_s
    end
  end

  def accept
    @friendship = Friendship.find_by(id: params[:id])
    @friendship.update(status: 1)
    redirect_to friendships_path
  end

  def destroy
    @friendship = Friendship.find_by(id: params[:id])
    if @friendship
      @friendship.destroy
      redirect_to users_path, notice: 'You are no longer friends.'
    else
      redirect_to users_path, alert: 'Currently, you are not friends. Send them a friendship invitation!'
    end
  end
end
