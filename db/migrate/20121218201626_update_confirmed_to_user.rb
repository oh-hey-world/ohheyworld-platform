class UpdateConfirmedToUser < ActiveRecord::Migration
  def up
    User.find_each do |user|
      user.confirm!
    end
  end

  def down
  end
end
