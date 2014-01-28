# == Schema Information
#
# Table name: languages
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  local_name :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Language < ActiveRecord::Base
  has_many :user_languages
  has_many :users, :through => :user_languages
end
