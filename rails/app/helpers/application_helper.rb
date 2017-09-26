module ApplicationHelper
  def env_tag
    Rails.env.first(4)
  end

  def body_class
    controller_name = params[:controller].gsub('/', ' ')
    "#{controller_name} #{params[:action]}"
  end
end
