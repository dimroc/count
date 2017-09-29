require 'pycall/import'

module RPC
  class InlineStub
    include PyCall::Import

    def count_crowd(request)
      pyfrom :'crowdcount.rpc.server', import: :predict
      predict(request.image)
    end
  end
end
