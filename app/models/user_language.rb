# == Schema Information
#
# Table name: user_languages
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  language_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class UserLanguage < ActiveRecord::Base
  belongs_to :language
  belongs_to :user

  class << self
    def mass_update(language_ids, user)
      user_languages = []
      language_ids.each do |language_id|
        user_languages << UserLanguage.new(language_id: language_id, user_id: user.id)
      end
      UserLanguage.destroy_all(user_id: user.id)
      UserLanguage.import user_languages
      UserLanguage.where(user_id: user.id)
    end
  end
end
