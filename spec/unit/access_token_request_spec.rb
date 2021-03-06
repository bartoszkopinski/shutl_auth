require 'spec_helper'

describe Shutl::Auth::AccessTokenRequest do
  subject { Shutl::Auth::AccessTokenRequest.new opts }

  let(:opts) do
    {
      client_id: "QUOTE_SERVICE_CLIENT_ID",
      client_secret: "QUOTE_SERVICE_CLIENT_SECRET",
      url: "http://localhost:3000"
    }
  end

  let(:oauth_client) { mock 'oauth client' }

  before do
    Rack::OAuth2::Client.stub(:new).and_return oauth_client
  end

  context 'successful request to authentication service' do
    before do
      oauth_client.stub(:access_token!).and_return 'token response'
    end

    specify do
      subject.access_token_response.should == 'token response'
    end
  end

  describe 'retries on network error' do
    let(:oauth_client) do
      FailNTimesThenSucceed.new number_of_failures, 'token'
    end

    context 'succeed on third attempt' do
      let(:number_of_failures) { 2 }

      specify do
        subject.access_token_response.should == 'token'
      end
    end

    context 'fail more than two times' do
      let(:number_of_failures) { 3 }

      specify do
        subject.access_token_response.should be_nil
      end
    end

    class FailNTimesThenSucceed
      def initialize number_of_failures, access_token
        @number_of_failures = number_of_failures
        @access_token       = access_token
        @counter            = 0
      end

      def access_token!
        @counter += 1
        raise Errno::ECONNREFUSED if @counter <= @number_of_failures
        @access_token
      end
    end
  end
end
