require 'pycall/import'

module RPC
  class InlineStub
    include PyCall::Import

    def count_crowd(request)
      pyfrom :'crowdcount.rpc.server', import: [:initialize_predictor, :predict_crowd]
      initialize_predictor
      predict_crowd(request.image)
    end

    def count_line(request)
      pyfrom :'crowdcount.rpc.server', import: [:initialize_predictor, :predict_line]
      initialize_predictor
      predict_line(request.image)
    end
  end
end
