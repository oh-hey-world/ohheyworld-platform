object @user
attributes :first_name, :last_name, :total_days_traveled
child(@user.current_location) {
  child(:user_location_assets) { attribute :asset_url }
  child(:location) {
    attribute :city_state_country
    child(:country) { attribute :name, :flag_url }
  }
}
child(@user.countries) { attribute :name, :flag_url }
