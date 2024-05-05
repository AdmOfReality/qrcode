class PagesController < ApplicationController
  def generate_qr
    send_data RQRCode::QRCode.new(params[:url].to_s).as_png(size: 230, border_modules: 0), type: 'image/png', disposition: 'inline'
  end
end
