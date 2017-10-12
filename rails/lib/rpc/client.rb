require_relative './ml_services_pb'

module RPC
  class Client
    class << self
      attr_accessor :__test_mode

      def inline!
        self.__test_mode = true
      end

      def stub_factory
        if __test_mode
          RPC::InlineStub
        else
          Stub
        end
      end
    end

    attr_reader :stub
    delegate :stub_factory, to: :class

    def initialize(version)
      port = 50050 + version
      @stub = stub_factory.new("localhost:#{port}", :this_channel_is_insecure)
    end

    def count_crowd(image_str)
      stub.count_crowd(CountRequest.new(image: image_str.force_encoding("ascii-8bit")))
    end

    def count_line(image_str)
      stub.count_line(CountRequest.new(image: image_str.force_encoding("ascii-8bit")))
    end
  end
end
