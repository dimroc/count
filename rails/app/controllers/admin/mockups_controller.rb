class Admin::MockupsController < ApplicationController
  include AdminControllable

  def index
    @pages = pages
  end

  def show
    page = params[:id]
    validate page
    render page
  end

  private

  def pages
    pages = Dir.glob(Rails.root.join("app", "views", "admin", "mockups", "*.html.*")).map do |path|
      match = path.match(/.*\/([a-zA-Z_\-]+).html.slim/)
      match[1] if match
    end.compact

    pages.delete("index")
    pages
  end

  def validate(page)
    raise ActiveRecord::RecordNotFound if !pages.include? page
  end
end
