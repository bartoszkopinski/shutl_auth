require 'spec_helper'


describe "Integration" do
  subject { Shutl::Auth }

  def set_auth
    Shutl::Auth.config do |c|
      c.url           =  "http://localhost:3000"
      c.client_id     =  "QUOTE_SERVICE_CLIENT_ID"
      c.client_secret =  "QUOTE_SERVICE_CLIENT_SECRET"
    end
  end

  before do
    set_auth
  end

  context 'successful request to authentication service' do
    let(:token) { 's_CagcDP8PdsGb1B0iyLvNtanSxqZeQDQtGiIYtctKzyLzxAymhe-zGJwUrjxKQpO9EUdizDT3tqLt-iFeHapg' }

    specify do
      VCR.use_cassette 'get_token' do
        Shutl::Auth.access_token!.should == token
      end
    end

    specify "with invalid auth service url" do
      Shutl::Auth.url = ''

      expect {Shutl::Auth.access_token!}.to raise_error Shutl::Auth::InvalidUrl

      Shutl::Auth.url = 'http://'
      expect {Shutl::Auth.access_token!}.to raise_error Shutl::Auth::InvalidUrl

      Shutl::Auth.url = 'http://localhost:3000'

      VCR.use_cassette 'get_token' do
        Shutl::Auth.access_token!.should == token
      end
    end

    specify "with invalid credentials" do
      set_auth
      Shutl::Auth.client_id = 'egg'

      VCR.use_cassette 'invalid_credentials' do
        expect { Shutl::Auth.access_token!}.to raise_error Shutl::Auth::InvalidCredentials
      end

    end
  end
end
