require File.expand_path('spec/spec_helper')

describe 'Config' do
  Shutl::Auth.config do |s|
    s.url           = 'http://localhost:3001'
    s.client_id     = 'asdf'
    s.client_secret = 'asdf'
  end

  it "has config for client_id and client_secret" do
    Shutl::Auth.client_id     = 'abc'
    Shutl::Auth.client_secret = '123'
    Shutl::Auth.url         = 'http://localhost:3000'

    Shutl::Auth.client_id.    should == 'abc'
    Shutl::Auth.client_secret.should == '123'
    Shutl::Auth.url.should  == 'http://localhost:3000'
  end

  it "has a nice config block" do
    Shutl::Auth.config do |s|
      s.url = 'asdf'
    end

    Shutl::Auth.url.should == 'asdf'
  end
end
