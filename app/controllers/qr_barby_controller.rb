require 'barby'
require 'barby/barcode/qr_code'
require 'barby/outputter/png_outputter'

class QrBarbyController < ApplicationController
  def qr
    url = params[:url]

    # Проверка на наличие параметра 'url'
    if url.blank?
      render plain: "Параметр 'url' обязателен", status: :bad_request
      return
    end

    # Генерация QR-кода
    barcode = Barby::QrCode.new(url, level: :l)

    # Генерация PNG
    png_output = Barby::PngOutputter.new(barcode)
    png_output.xdim = 1 # Подбираем модульный размер
    png_output.margin = 0 # Убираем рамки

    # Получение бинарного PNG
    png_blob = png_output.to_png

    # Масштабирование до фиксированного размера 120x120
    scaled_png = scale_png(png_blob, 120, 120)

    # Отправка PNG в качестве ответа
    send_data scaled_png, type: 'image/x-png', disposition: 'inline'
  end

  private

  # Метод масштабирования PNG до фиксированных размеров
  def scale_png(png_blob, width, height)
    require 'chunky_png'
    image = ChunkyPNG::Image.from_blob(png_blob)
    scaled_image = image.resample_nearest_neighbor(width, height)
    scaled_image.to_blob
  end
end
