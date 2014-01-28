# == Schema Information
#
# Table name: user_location_notes
#
#  id               :integer          not null, primary key
#  title            :string(50)       default("")
#  note             :text             default("")
#  user_id          :integer
#  user_location_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class UserLocationNote < ::ActiveRecord::Base
  belongs_to :user
  belongs_to :user_location

  attr_accessible :title, :note, :user_id, :user_location_id
end
