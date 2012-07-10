require 'spec_helper'

#WebMock.enable_net_connect!

# see also https://github.com/robdimarco/omniauth_crowd/blob/master/spec/omniauth/strategies/crowd_spec.rb
describe OmniAuth::Strategies::Toodledo, :type=>:strategy do

  include OmniAuth::Test::StrategyTestCase

  def strategy
    @app_id = '1224'
    @app_token = 'api4fe0773edef68'
    [OmniAuth::Strategies::Toodledo, {
      :app_id => @app_id,
      :app_token => @app_token
    }]
  end

  subject do
    OmniAuth::Strategies::Toodledo.new({})
  end

  describe '#client_options' do
    it 'has correct Toodledo site' do
      subject.options.client_options.site.should eq ('http://api.toodledo.com')
    end

    it 'has correct Toodledo lookup url' do
      (subject.options.client_options.site +
        subject.options.client_options.lookup_path).should eq (
          'http://api.toodledo.com/2/account/lookup.php'
        )
    end

    it 'has correct Toodledo authorize url' do
      (subject.options.client_options.site +
        subject.options.client_options.authorize_path).should eq (
          'http://api.toodledo.com/2/account/token.php'
        )

    end

    it 'has correct Toodledo account info url' do
      (subject.options.client_options.site +
        subject.options.client_options.account_info_path).should eq (
          'http://api.toodledo.com/2/account/get.php'
        )

    end
  end

  describe 'GET /auth/toodledo' do
    before do
      get '/auth/toodledo'
    end

    it 'should show the login form' do
      last_response.should be_ok
    end
  end

=begin
  describe 'POST /auth/toodledo/callback without any credentials' do
    before do
      post '/auth/toodledo/callback'
    end
    it 'should fail' do
      last_response.should be_redirect
      last_response.headers['Location'].should =~ /no_credentials/
    end
  end
=end

  describe 'POST /auth/toodledo/callback' do
    before do
      url = 'http://api.toodledo.com/2/account/lookup.php?appid=1224;email=tood5@log4d.com;pass=123456;sig=ea5f3ecf7537b1f22fe884acd5e0c6d1'
      stub_request(:get, url) .to_return(
        :body => '{"userid": "td4ff814c167430"}'
      )
      url = 'http://api.toodledo.com/2/account/token.php?userid=td4ff814c167430;appid=1224;pass=123456;sig=249d70aa59f88892e5936999237bc2bb'
      stub_request(:get, url) .to_return(:body => '{"token": "1a0000005e6f7"}')
      url = 'http://api.toodledo.com/2/account/get.php?key=2f74098076e87ea129b44c0431684040'
      stub_request(:get, url) .to_return(:body => '{"userid":"td4ff814c167430","alias":"tood5","pro":"0","dateformat":"3","timezone":"26","hidemonths":"6","hotlistpriority":"3","hotlistduedate":"14","hotliststar":"0","hotliststatus":"1","showtabnums":"1","lastedit_folder":"1294132455","lastedit_context":"0","lastedit_goal":"1341560402","lastedit_location":"0","lastedit_task":"1341882372","lastdelete_task":"1341659141","lastedit_notebook":"0","lastdelete_notebook":"0"}')
      post '/auth/toodledo/callback', :email => 'tood5@log4d.com', :password => '123456'
    end

    it 'should be ok' do
      last_response.body.should == 'true'
    end

    it 'should have an auth hash' do
      auth = last_request.env['omniauth.auth']
      auth.should be_kind_of(Hash)
    end

    it 'should have good data' do
      last_request.env['omniauth.auth']['provider'].should == 'toodledo'
      last_request.env['omniauth.auth']['uid'].should == 'td4ff814c167430'
      last_request.env['omniauth.auth']['info'].should be_kind_of(Hash)
      last_request.env['omniauth.auth']['info']['email'] \
        .should == 'tood5@log4d.com'
      last_request.env['omniauth.auth']['info']['name'] \
        .should == 'tood5'
      last_request.env['omniauth.auth']['info']['nickname'] \
        .should == 'tood5'
      last_request.env['omniauth.auth']['credentials']['token'] \
        .should == '2f74098076e87ea129b44c0431684040'
    end
  end
end
