class PagesController < ApplicationController
  def generate_qr
    url = params[:url]
    qrcode = RQRCode::QRCode.new(url, level: :l)

    # NOTE: showing with default options specified explicitly
    png = qrcode.as_png(
      border_modules: 0,
      module_px_size: 15,
      resize_exactly_to: 230
    )

    send_data png.to_blob, type: 'image/x-png', disposition: 'inline'
  end
end
