require 'spec_helper'

describe TwilioController do

  describe "GET 'process_sms'" do
    it "returns http success" do
      get 'process_sms'
      response.should be_success
    end
  end

end
