require 'spec_helper'

describe "admin/registration_codes/index" do
  before(:each) do
    assign(:admin_registration_codes, [
      stub_model(Admin::RegistrationCode),
      stub_model(Admin::RegistrationCode)
    ])
  end

  it "renders a list of admin/registration_codes" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
