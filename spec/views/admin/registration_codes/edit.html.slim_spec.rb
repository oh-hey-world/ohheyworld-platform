require 'spec_helper'

describe "admin/registration_codes/edit" do
  before(:each) do
    @admin_registration_code = assign(:admin_registration_code, stub_model(Admin::RegistrationCode))
  end

  it "renders the edit admin_registration_code form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_registration_codes_path(@admin_registration_code), :method => "post" do
    end
  end
end
