class PagesController < ApplicationController
  def generate_qr
    send_data RQRCode::QRCode.new(params[:url].to_s).as_png(
      border_modules: 0,
      fill: "pink",
      size: 230
      ),
      type: 'image/x-png', disposition: 'inline'
  end
end
