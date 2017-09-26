module AdminControllable
  extend ActiveSupport::Concern

  included do
    layout 'admin'
    before_action :authorize_admin
    after_action :verify_authorized

    private

    def authorize_admin
      authorize :admin, :granted?
    end
  end
end
