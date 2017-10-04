require_relative './ml_services_pb'

module RPC
  class Client
    class << self
      attr_accessor :__test_mode

      def inline!
        self.__test_mode = :inline
      end

      def inline?
        self.__test_mode == :inline
      end

      def default
        if inline?
          new(RPC::InlineStub.new)
        else
          new
        end
      end
    end

    attr_reader :stub
    def initialize(stub=Stub.new(Rails.application.secrets.ml_url, :this_channel_is_insecure))
      @stub = stub
    end

    def count_crowd(image_str)
      stub.count_crowd(CountRequest.new(image: image_str.force_encoding("ascii-8bit")))
    end

    def count_line(image_str)
      stub.count_line(CountRequest.new(image: image_str.force_encoding("ascii-8bit")))
    end
  end
end
