class RegistrationsController < Devise::RegistrationsController
  before_filter :set_menu_hidden
end