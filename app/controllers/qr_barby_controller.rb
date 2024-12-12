class QrBarbyController < ApplicationController
  require 'barby'
  require 'barby/barcode/qr_code'
  require 'barby/outputter/png_outputter'

  def qr
    # Получаем данные для QR-кода
    url = params[:url]

    # Создаем QR-код
    barcode = Barby::QrCode.new(url, level: :q)

    # Генерация PNG
    png_data = Barby::PngOutputter.new(barcode).to_png(
      xdim: 4, # Размер одного модуля (ячейки)
      margin: 1   # Убираем отступы
    )

    # Отправляем PNG как ответ
    send_data png_data, type: 'image/png', disposition: 'inline'
  end
end
