# == Schema Information
#
# Table name: user_searches
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  location_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_input  :string(255)
#  tag_id      :integer
#

class UserSearch < ActiveRecord::Base
  belongs_to :user
  belongs_to :location
  belongs_to :tag
  accepts_nested_attributes_for :location
  
  def save_or_set_location
    unless location_id
      if prior_location = Location.find_by_user_input(user_input) then
        self.location = prior_location
      else
        possible_location = Location.create(user_input: user_input)
        self.location = possible_location if possible_location
      end
    end
  end
end
