# == Schema Information
#
# Table name: preferences
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  value      :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  type_name  :string(255)
#

class Preference < ActiveRecord::Base
  belongs_to :user

  validates_uniqueness_of :name, :scope => :user_id

  attr_accessible :name, :value, :user_id, :type_name
end
