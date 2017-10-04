module AdminHelper
  def active_admin_nav(key)
    "active" if controller_name == key.to_s
  end
end
