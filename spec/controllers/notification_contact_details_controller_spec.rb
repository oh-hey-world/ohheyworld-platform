require 'spec_helper'

describe NotificationContactDetailsController do

  describe "GET 'more_contacts'" do
    it "returns http success" do
      get 'more_contacts'
      response.should be_success
    end
  end

end
