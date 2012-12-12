require File.expand_path('spec/spec_helper')

describe Shutl::Auth::AccessTokenRequest do
  before do
    Shutl.config do |s|
      s.client_id     = 'asdf'
      s.client_secret = 'asdf'
    end
  end


  subject { Shutl::Auth::AccessTokenRequest.new }

  let(:oauth_client) { mock 'oauth client' }

  before do
    Rack::OAuth2::Client.stub(:new).and_return oauth_client
  end

  context 'successful request to authentication service' do
    before do
      oauth_client.stub(:access_token!).and_return 'token response'
    end

    specify do
      subject.access_token!.should == 'token response'
    end
  end

  describe 'retries on network error' do
    before do
      oauth_client.should_receive(:access_token!).
        exactly(3).times.and_raise Timeout::Error
    end

    specify do
      subject.access_token!
    end
  end
end

