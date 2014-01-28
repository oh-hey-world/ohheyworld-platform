class Api::LanguagesController < Api::BaseController
  def index
    @languages = Language.all
  end
end
