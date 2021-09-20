require 'rails_helper'

RSpec.describe Friendship, type: :model do
  describe 'is associated to user(sender) and user(receiver)' do
    it { should belong_to(:invitation_sender) }
    it { should belong_to(:invitation_receiver) }
  end
end
