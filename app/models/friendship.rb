class Friendship < ApplicationRecord
  after_update(:add_reverse_friendship_pair)
  belongs_to :invitation_sender, class_name: 'User'
  belongs_to :invitation_receiver, class_name: 'User'

  def add_reverse_friendship_pair
    friendship = Friendship.find(id)
    return unless friendship

    Friendship.create(invitation_sender_id: friendship.invitation_sender_id,
                      invitation_receiver_id: friendship.invitation_receiver_id, status: true)
  end
end
