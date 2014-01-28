class SlugAllToUser < ActiveRecord::Migration
  def up
    User.find_each do |user|
      user.save
    end
  end

  def down
  end
end
