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
    def initialize(stub=Stub.new('localhost:50051', :this_channel_is_insecure))
      @stub = stub
    end

    def count_crowd(image_str)
      request = CountCrowdRequest.new(version: "1", image: image_str)
      stub.count_crowd(request)
    end
  end
end
