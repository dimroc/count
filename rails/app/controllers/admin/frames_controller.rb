class Admin::FramesController < ApplicationController
  include AdminControllable

  def update
    @frame = Frame.find(params[:id])
    @frame.update_attributes(flagged: !@frame.flagged)
    reply = render_to_string(
      partial: 'admin/shared/frame_row',
      locals: { frame: FrameDecorator.decorate(@frame) })
    render json: { html: reply }
  end
end
