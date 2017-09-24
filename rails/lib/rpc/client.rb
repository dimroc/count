require_relative './ml_services_pb'

module RPC
  class Client
    def count_crowd(image)
      request = CountCrowdRequest.new(version: "1")
      puts stub.count_crowd(request)
    end

    private

    def stub
      @stub ||= Stub.new('localhost:50051', :this_channel_is_insecure)
    end
  end
end
