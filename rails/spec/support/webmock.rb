module WebMockHelpers
  def self.disable
    WebMock.disable_net_connect!(
      allow_localhost: true,
      allow: 'localhost:9200')
  end

  module Stubs
    def gcs_succeeds_to_download_jpg
      stub_request(:get, %r!https://storage.googleapis.com/.*jpg!).
        to_return(:status => 200, :body => File.open(fixture_url('shakeshack-1501021280.jpg')),
                  :headers => {'Content-Type' => 'image/jpeg'})
    end

    def shakecam_downloads_empty_image
      stub_request(:get, %r!https://cdn.shakeshack.com/camera.jpg.*!).
        to_return(:status => 200, :body => File.open(fixture_url('shakeshack-empty.jpg')),
                  :headers => {'Content-Type' => 'image/jpeg'})
    end

    def mall_download_succeeds
      stub_request(:get, %r!https://dimroc-public.s3.amazonaws.com/mall/seq_\d+.jpg!).
        to_return(:status => 200, :body => File.open(fixture_url('mall_001971.jpg')),
                  :headers => {'Content-Type' => 'image/jpeg'})
    end
  end
end

RSpec.configure do |config|
  config.before(:suite) do
    WebMockHelpers.disable
  end

  config.before(:each) do
    WebMock.reset!
  end

  config.include WebMockHelpers::Stubs
end
