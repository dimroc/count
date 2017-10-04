module AdminControllable
  extend ActiveSupport::Concern

  included do
    layout 'admin'
    before_action :authenticate_user!, :authorize_admin
    after_action :verify_authorized

    private

    def authorize_admin
      authorize :admin, :granted?
    end

    def after_sign_in_path_for(user)
      stored_location_for(:user) || super
    end
  end
end
