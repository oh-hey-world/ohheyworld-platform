# == Schema Information
#
# Table name: user_cities
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  city_id              :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  user_city_tips_count :integer
#  summary              :text
#

class UserCity < ActiveRecord::Base
  belongs_to :user
  belongs_to :city
  has_many :user_city_tips, dependent: :destroy
  validates_uniqueness_of :city_id, :scope => [:user_id]
  validates :city_id, presence: true

  acts_as_taggable
  acts_as_taggable_on :expertise

  default_scope includes(:user_city_tips)

  attr_accessible :city_id, :user_id, :tag_list, :expertise_list, :summary

  class << self
    def unique_cities(user_id)
      UserCity.select('DISTINCT user_cities.*').joins(:user_city_tips).where(user_id: user_id)
    end
  end

end
