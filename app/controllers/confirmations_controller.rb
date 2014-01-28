class ConfirmationsController < Devise::ConfirmationsController
  before_filter :set_menu_hidden
end