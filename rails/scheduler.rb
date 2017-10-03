require_relative './config/application'
require 'rake'
CountingCompany::Application.load_tasks

s = Rufus::Scheduler.new
s.every '5m' do
  Rake::Task['prediction:shakecam'].reenable
  Rake::Task['prediction:shakecam'].invoke
end

s.join
