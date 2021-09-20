class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :invitations_received, foreign_key: :invitation_receiver_id, class_name: 'Friendship', dependent: :destroy
  has_many :users_who_invited_me, through: :invitations_received, source: :invitation_sender, dependent: :destroy

  has_many :invitations_sent, foreign_key: :invitation_sender_id, class_name: 'Friendship', dependent: :destroy
  has_many :users_invited_by_me, through: :invitations_sent, source: :invitation_receiver, dependent: :destroy

  def friendship_request(user)
    return false if users_invited_by_me.include?(user) || users_who_invited_me.include?(user)

    users_invited_by_me << user
  end

  def accept_request(user)
    friend_request = invitations_received.where(invitation_sender_id: user.id).first
    friend_request.update(status: true)
  end

  def reject_request(user)
    friend_request = invitations_received.where(invitation_sender_id: user.id).first
    friend_request.destroy
  end

  def friends
    friend_sender = User.where(id: invitations_sent.where(status: true).pluck(:invitation_receiver_id))
    friend_receiver = User.where(id: invitations_received.where(status: true).pluck(:invitation_sender_id))
    friend_sender + friend_receiver
  end

  def friend?(user)
    friends.include?(user)
  end

  def pending_requests_received?(user)
    pending_requests_received.include?(user)
  end

  def pending_requests_sent?(user)
    pending_requests_sent.include?(user)
  end

  def pending_requests_sent
    invitations_sent.map { |friendship| friendship.invitation_receiver unless friendship.status }
  end

  def pending_requests_received
    invitations_received.map { |friendship| friendship.invitation_sender unless friendship.status }
  end
end
