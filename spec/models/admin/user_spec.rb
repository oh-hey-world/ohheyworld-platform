# == Schema Information
#
# Table name: users
#
#  id                      :integer          not null, primary key
#  email                   :string(255)      default(""), not null
#  encrypted_password      :string(255)      default(""), not null
#  reset_password_token    :string(255)
#  reset_password_sent_at  :datetime
#  remember_created_at     :datetime
#  sign_in_count           :integer          default(0)
#  current_sign_in_at      :datetime
#  last_sign_in_at         :datetime
#  current_sign_in_ip      :string(255)
#  last_sign_in_ip         :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  first_name              :string(255)
#  last_name               :string(255)
#  gender                  :string(255)
#  timezone                :integer
#  locale                  :string(255)
#  picture_url             :string(255)
#  link                    :string(255)
#  blurb                   :text
#  birthday                :datetime
#  roles_mask              :integer
#  blog_url                :string(255)
#  home_town_location_id   :integer
#  nickname                :string(255)      not null
#  slug                    :string(255)      not null
#  agrees_to_terms         :boolean
#  completed_first_checkin :boolean
#  import_job_id           :integer
#  import_job_finished_at  :datetime
#  send_overrides          :text
#  authentication_token    :string(255)
#  phone                   :string(255)
#  confirmation_token      :string(255)
#  confirmed_at            :datetime
#  confirmation_sent_at    :datetime
#  unconfirmed_email       :string(255)
#  phone_country_code_id   :integer
#

# require 'spec_helper'

# describe Admin::User do
#   pending "add some examples to (or delete) #{__FILE__}"
# end
