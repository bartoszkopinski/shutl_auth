require 'spec_helper'
require 'ostruct'

describe Shutl::Auth::AuthenticatedRequest do

  class ToTestAuthenticatedRequest
    include Shutl::Auth::AuthenticatedRequest
  end

  subject { ToTestAuthenticatedRequest.new }

  let(:authenticator) { OpenStruct.new(access_token: '123', request_access_token: '456')}

  before do
    Shutl::Auth::Authenticator.stub(:new).and_return(authenticator)
  end

  describe 'access_token' do
    it 'delegates the call to the authenticator' do
      subject.access_token.should == '123'
    end
  end

  describe 'authenticated_request' do
    it 'delegates the call to the authenticator' do
      block = -> { 'abcd' }
      authenticator.stub(:authenticated_request).with(&block).and_return('abcd')

      subject.authenticated_request { block }.should == 'abcd'
    end
  end

  describe 'request_access_token' do
    it 'delegates the call to the authenticator' do
      subject.request_access_token.should == '456'
    end
  end

  describe 'default configuration' do
    before do
      Shutl::Auth.config do |s|
        s.url           = 'http://localhost:3000'
        s.client_id     = 'CLIENT_ID'
        s.client_secret = 'CLIENT_SECRET'
      end
    end

    it 'uses the default Shutl::Auth value to authenticate' do
      Shutl::Auth::Authenticator.should_receive(:new).
        with(client_id: 'CLIENT_ID', client_secret: 'CLIENT_SECRET', url: 'http://localhost:3000').
        and_return(authenticator)

      subject.request_access_token
    end
  end
end