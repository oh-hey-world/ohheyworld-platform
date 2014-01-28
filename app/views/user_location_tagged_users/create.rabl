object false

node(:tagged_id) { |m| @user_location_tagged_user.id }

child @user => :user do
  attribute :user_name, :picture_url, :slug
end

child @provider_friend => :provider_friend do
  attribute :user_name, :picture_url
end