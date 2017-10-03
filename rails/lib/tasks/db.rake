namespace :db do
  desc "Dumps the database to db/APP_NAME.dump"
  task :dump => :environment do
    cmd = "pg_dump --verbose --clean --no-owner --no-acl --format=plain #{pg_dump_params} > #{dump_path}"
    puts cmd
    system cmd
  end

  desc "Restores the database dump at db/APP_NAME.dump."
  task :restore => :environment do
    cmd = "pg_restore --verbose --host #{host} --clean --no-owner --no-acl --dbname #{db} #{dump_path}"
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    puts cmd
    exec cmd
  end

  task :dump_gcs => [:environment, :dump] do
    config = Rails.application.config.active_storage.service_configurations[Rails.application.config.active_storage.service.to_s]
    config = OpenStruct.new config
    storage = Google::Cloud::Storage.new
    bucket = storage.bucket config.bucket
    puts "Uploading #{File.basename(dump_path)} to GCS..."
    bucket.create_file dump_path.to_s, File.basename(dump_path)
  end

  private

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
