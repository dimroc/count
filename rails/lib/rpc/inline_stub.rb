require 'pycall/import'

module RPC
  class InlineStub
    include PyCall::Import

    def count_crowd(request)
      pyfrom :'crowdcount.rpc.server', import: :predict_crowd
      predict_crowd(request.image)
    end

    def count_line(request)
      pyfrom :'crowdcount.rpc.server', import: :predict_line
      predict_line(request.image)
    end
  end
end
