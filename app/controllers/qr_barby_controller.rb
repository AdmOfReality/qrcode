class QrBarbyController < ApplicationController
  require 'barby'
  require 'barby/barcode/qr_code'
  require 'barby/outputter/png_outputter'

  def qr
    # Получаем данные для QR-кода
    url = params[:url]

    # Создаем QR-код
    barcode = Barby::QrCode.new(url, level: :q)

    png_data = Barby::PngOutputter.new(barcode).to_png(
      xdim: 1,  # Размер одного модуля
      margin: 0 # Отступы
    )

    # Отправляем PNG как ответ
    send_data png_data, type: 'image/x-png', disposition: 'inline'
  end
end
