require 'uri'

class ApplicationDecorator < Draper::Decorator
  def path_for(url)
    URI::parse(url).path
  end
end
