class Friendship < ApplicationRecord
  after_update(:add_reverse_friendship_pair)
  belongs_to :invitation_sender, class_name: 'User'
  belongs_to :invitation_receiver, class_name: 'User'

  def add_reverse_friendship_pair
    friendship = Friendship.find(id)
    Friendship.create(invitation_sender_id: friendship.invitee_id, invitation_receiver_id: friendship.inviter_id, status: true) if friendship
  end
end
