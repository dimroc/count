require "google/cloud/storage"

namespace :db do
  desc "Dumps the database to tmp/APP_NAME.dump"
  task :dump => :environment do
    cmd = "pg_dump --verbose --clean --no-owner --no-acl --format=plain #{pg_dump_params} | gzip > #{dump_path}"
    puts cmd
    system cmd
  end

  desc "Dumps the database to tmp/counting_company.dump and uploads to GCS"
  task :dump_gcs => [:environment, :dump] do
    puts "Uploading #{File.basename(dump_path)} to GCS..."
    bucket.create_file dump_path.to_s, File.basename(dump_path)
  end

  desc "Restores the database dump at tmp/APP_NAME.dump."
  task :restore => :environment do
    cmd = "gunzip -c #{dump_path} | psql #{db}"
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    puts cmd
    exec cmd
  end

  desc "Restores the database dump from GCS"
  task :restore_gcs => [:environment] do
    puts "Downloading #{File.basename(dump_path)} from GCS..."
    bucket.file(File.basename(dump_path)).download(dump_path.to_s)
    Rake::Task["db:restore"].invoke
  end

  private

  def bucket
    @bucket ||= begin
                  project = Rails.application.secrets.google_cloud_project
                  storage = Google::Cloud::Storage.new(project: project)
                  storage.bucket "#{project}_ops"
                end
  end

  def dump_path
    Dir.mkdir(Rails.root.join("tmp")) unless Dir.exist? Rails.root.join("tmp")
    Rails.root.join("tmp", "#{Rails.application.class.parent_name.underscore}.dump")
  end

  def host
    ActiveRecord::Base.connection_config[:host] || "localhost"
  end

  def db
    ActiveRecord::Base.connection_config[:database]
  end

  def pg_dump_params
    return ENV['DATABASE_URL'] if ENV['DATABASE_URL']
    return "--host #{host} #{db}"
  end
end
