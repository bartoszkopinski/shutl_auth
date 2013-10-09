require 'spec_helper'


describe "Integration" do
  subject { Shutl::Auth::AccessTokenRequest.new opts }
  let(:client_id) { "QUOTE_SERVICE_CLIENT_ID" }
  let(:url) { "http://localhost:3000" }

  let(:opts) do
    {
      client_id: client_id,
      client_secret: "QUOTE_SERVICE_CLIENT_SECRET",
      url: url
    }
  end

  context 'successful request to authentication service' do
    let(:token) { 's_CagcDP8PdsGb1B0iyLvNtanSxqZeQDQtGiIYtctKzyLzxAymhe-zGJwUrjxKQpO9EUdizDT3tqLt-iFeHapg' }

    specify do
      VCR.use_cassette 'get_token' do
        subject.access_token.should == token
      end
    end

    describe "with invalid auth service url" do
      specify do
        expect { Shutl::Auth::AccessTokenRequest.new(client_id: '', client_secret: '', url: '').access_token}.to raise_error Shutl::Auth::InvalidUrl
      end

      specify do
        expect {Shutl::Auth::AccessTokenRequest.new(client_id: '', client_secret: '', url: 'http://').access_token}.to raise_error Shutl::Auth::InvalidUrl
      end
    end

    specify "with 500 from auth server" do
      stub_request(:post, /.*#{url}.*/).to_return(
        { body: '',
           status: 500,
           headers: {"CONTENT_TYPE" => 'application/json'}}
        )

      Airbrake.should_receive(:notify)

      expect{ subject.access_token}.to raise_error Shutl::Auth::InternalServerError
    end

    describe "with invalid credentials" do
      let(:client_id) { 'egg' }

      specify do
        VCR.use_cassette 'invalid_credentials' do
          expect { subject.access_token}.to raise_error Shutl::Auth::InvalidCredentials
        end

        VCR.use_cassette 'invalid_credentials' do
          expect { subject.access_token}.to raise_error Shutl::Auth::InvalidCredentials
        end
      end
    end
  end
end
