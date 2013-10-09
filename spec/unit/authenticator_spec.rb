require 'spec_helper'

describe Shutl::Auth::Authenticator do
  subject { described_class.new }

  let(:token)       { 'abcd' }
  let(:spare_token) { '1234' }

  before do
    Shutl::Auth.cache.write(:access_token, nil)
    Shutl::Auth.stub(:access_token!).and_return(token, spare_token)
  end

  describe 'access_token' do
    it 'requests the token' do
      subject.access_token.should == token
    end

    it 'caches the token' do
      subject.access_token

      subject.access_token.should == token
    end
  end

  describe 'authenticated_request' do
    it 'execute the block' do
      block = -> { 'test' }

      result = subject.authenticated_request &block

      result.should == 'test'
    end

    it 'retries if the block raise an UnauthorizedAccess' do
      call = 0
      block = -> do
        t = subject.access_token
        if call == 0
          call += 1
          raise Shutl::UnauthorizedAccess
        end
        t
      end

      result = subject.authenticated_request &block

      result.should == spare_token
    end

    it 'caches the token' do
      block = -> { subject.access_token }

      2.times { subject.authenticated_request &block }

      Shutl::Auth.cache.read(:access_token).should == token
    end
  end

  describe 'token cache' do
    subject { described_class.new(cache_key: :an_other_cache) }

    it 'caches the token with the provided value' do
      block = -> { subject.access_token }

      2.times { subject.authenticated_request &block }

      Shutl::Auth.cache.read(:an_other_cache).should == token
    end
  end
end