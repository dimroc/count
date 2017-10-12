if defined? Bullet
  Bullet.enable = Rails.env.test? || Rails.env.development?
  Bullet.bullet_logger = true
  Bullet.console = true
  Bullet.counter_cache_enable = true
  Bullet.rails_logger = true
  Bullet.raise = Rails.env.test?
  Bullet.unused_eager_loading_enable = false
end
