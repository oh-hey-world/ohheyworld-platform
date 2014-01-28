class PasswordsController < Devise::PasswordsController
  before_filter :set_menu_hidden

end