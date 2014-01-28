require 'spec_helper'

describe "admin/registration_codes/show" do
  before(:each) do
    @admin_registration_code = assign(:admin_registration_code, stub_model(Admin::RegistrationCode))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
