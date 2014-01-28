# == Schema Information
#
# Table name: user_providers
#
#  id                       :integer          not null, primary key
#  user_id                  :integer
#  provider                 :string(255)
#  uid                      :string(255)
#  first_name               :string(255)
#  last_name                :string(255)
#  gender                   :string(255)
#  timezone                 :integer
#  locale                   :string(255)
#  link                     :string(255)
#  hometown                 :string(255)
#  picture_url              :string(255)
#  provider_token           :string(255)
#  provider_token_timeout   :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  secret                   :string(255)
#  full_name                :string(255)
#  nickname                 :string(255)
#  description              :text
#  website                  :string(255)
#  geo_enabled              :boolean
#  failed_post_deauthorized :boolean
#  failed_token             :boolean
#  failed_app_deauthorized  :boolean
#

require 'spec_helper'

describe UserProvider do
  pending "add some examples to (or delete) #{__FILE__}"
end
