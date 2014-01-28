object false

child @search_users => :users do
  attribute :first_name, :last_name, :id, :picture_url, :link, :nickname, :slug
end

child @search_provider_friends => :provider_friends do
  attribute :user_name, :id, :provider_name, :picture_url, :link, :username
end