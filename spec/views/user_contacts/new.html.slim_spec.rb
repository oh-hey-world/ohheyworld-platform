require 'spec_helper'

describe "user_contacts/new" do
  before(:each) do
    assign(:user_contact, stub_model(UserContact,
      :user_id => 1,
      :contact_id => 1,
      :subject => "MyString",
      :message => "MyText",
      :email => "MyString",
      :phone => "MyString"
    ).as_new_record)
  end

  it "renders new user_contact form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => user_contacts_path, :method => "post" do
      assert_select "input#user_contact_user_id", :name => "user_contact[user_id]"
      assert_select "input#user_contact_contact_id", :name => "user_contact[contact_id]"
      assert_select "input#user_contact_subject", :name => "user_contact[subject]"
      assert_select "textarea#user_contact_message", :name => "user_contact[message]"
      assert_select "input#user_contact_email", :name => "user_contact[email]"
      assert_select "input#user_contact_phone", :name => "user_contact[phone]"
    end
  end
end
