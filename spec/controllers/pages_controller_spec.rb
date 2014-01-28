require 'spec_helper'

describe PagesController do

  describe "GET 'about'" do
    it "returns http success" do
      get 'about'
      response.should be_success
    end
  end

  describe "GET 'team'" do
    it "returns http success" do
      get 'team'
      response.should be_success
    end
  end

  describe "GET 'privacy'" do
    it "returns http success" do
      get 'privacy'
      response.should be_success
    end
  end

  describe "GET 'tos'" do
    it "returns http success" do
      get 'tos'
      response.should be_success
    end
  end

  describe "GET 'faq'" do
    it "returns http success" do
      get 'faq'
      response.should be_success
    end
  end

  describe "GET 'feedback'" do
    it "returns http success" do
      get 'feedback'
      response.should be_success
    end
  end

  describe "GET 'jobs'" do
    it "returns http success" do
      get 'jobs'
      response.should be_success
    end
  end

end
