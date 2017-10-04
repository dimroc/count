module FixtureHelpers
  def fixture_url(fixture)
    Rails.root.join("spec/fixtures", fixture)
  end

  def load_json_fixture(fixture)
    JSON.parse File.read(fixture_url(fixture))
  end
end

RSpec.configure do |config|
  config.include FixtureHelpers
end
