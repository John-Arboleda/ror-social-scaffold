class CreateFriendships < ActiveRecord::Migration[5.2]
  def change
    create_table :friendships do |t|
      t.references :invitation_sender, null: false, foreign_key: { to_table: :users }
      t.references :invitation_receiver, null: false, foreign_key: { to_table: :users }
      t.boolean :status, default: false

      t.timestamps
    end
  end
end
