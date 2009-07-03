require File.dirname(__FILE__) + '/spec_helper'

describe "service" do
  describe "GET on /api/v1/users/:id" do    
    before(:all) do
      User.create(:name => "paul", :email => "paul@pauldix.net", :password => "strongpass", :bio => "rubyist")
    end

    it "should return a user by name" do
      get '/api/v1/users/paul'
      last_response.should be_ok
      JSON.parse(last_response.body)["name"].should == "paul"
    end
    
    it "should return a user with an email" do
      get '/api/v1/users/paul'
      last_response.should be_ok
      JSON.parse(last_response.body)["email"].should == "paul@pauldix.net"
    end
    
    it "should not return a user's password" do
      get '/api/v1/users/paul'
      last_response.should be_ok
      JSON.parse(last_response.body).should_not have_key("password")
    end
    
    it "should return a user with a bio" do
      get '/api/v1/users/paul'
      last_response.should be_ok
      JSON.parse(last_response.body)["bio"].should == "rubyist"      
    end
    
    it "should return a 404 for a user that doesn't exist" do
      get '/api/v1/users/foo'
      last_response.status.should == 404
    end
  end
  
  describe "POST on /api/v1/users" do
    it "should create a user" do
      post '/api/v1/users', '{"name": "trotter", "email": "no spam", "password": "whatever", "bio": "southern bell"}'
      last_response.should be_ok
      get '/api/v1/users/trotter'
      user = JSON.parse(last_response.body)
      user["name"].should  == "trotter"
      user["email"].should == "no spam"
      user["bio"].should   == "southern bell"
    end
  end
  
  describe "PUT on /api/v1/users/:id" do
    it "should update a user" do
      User.create(:name => "bryan", :email => "no spam", :password => "whatever", :bio => "rspec master")
      put '/api/v1/users/bryan', '{"bio": "testing freak"}'
      last_response.should be_ok
      get '/api/v1/users/bryan'
      user = JSON.parse(last_response.body)
      user["bio"].should == "testing freak"
    end
  end
  
  describe "DELETE on /api/v1/users/:id" do
    it "should delete a user" do
      User.create(:name => "francis", :email => "no spam", :password => "whatever", :bio => "williamsburg hipster")
      delete '/api/v1/users/francis'
      last_response.should be_ok
      get '/api/v1/users/francis'
      last_response.status.should == 404
    end
  end
  
  describe "POST on /api/v1/users/:id/sessions" do
    before(:all) do
      User.create(:name => "josh", :password => "nyc.rb rules")
    end
    it "should return the user object on valid credentials" do
      post '/api/v1/users/josh/sessions', '{"password": "nyc.rb rules"}'
      last_response.should be_ok
      user = JSON.parse(last_response.body)
      user["name"].should == "josh"
    end

    it "should fail on invalid credentials" do
      post '/api/v1/users/josh/sessions', '"wrong"'
      last_response.status.should == 400
    end    
  end
end
