require 'spec_helper'
require 'fog'

describe "an app configured for S3" do
  
  before(:each) do
    Fog.mock!
    @app = Dragonfly[:s3_test].configure_with(:s3, :bucket_name => 'joey', :access_key_id => 'xxx', :secret_access_key => 'asdf')
  end
  
  describe "remote_urls" do
    
    before(:each) do
      @app.datastore.stub!(:store).and_return('some/path/on/s3')
      @uid = @app.store("Eggs")
    end
    
    it "should default to the US url" do
      @app.remote_url_for(@uid).should == "http://s3.amazonaws.com/some/path/on/s3"
    end
    
    it "should use a different region if configured" do
      @app.datastore.region = 'eu-west-1'
      @app.remote_url_for(@uid).should == "http://s3-eu-west-1.amazonaws.com/some/path/on/s3"
    end
    
  end
  
end