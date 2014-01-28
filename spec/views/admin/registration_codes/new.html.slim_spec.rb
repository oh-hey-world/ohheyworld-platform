require 'spec_helper'

describe "admin/registration_codes/new" do
  before(:each) do
    assign(:admin_registration_code, stub_model(Admin::RegistrationCode).as_new_record)
  end

  it "renders new admin_registration_code form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_registration_codes_path, :method => "post" do
    end
  end
end
