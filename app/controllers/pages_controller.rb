class PagesController < ApplicationController
  def generate_qr
    qr_code = RQRCode::QRCode.new(params[:url].to_s)

    # Генерация QR-кода в виде изображения PNG
    png = qr_code.as_png(
      resize_gte_to: false,
      resize_exactly_to: false,
      border_modules: 0,
      fill: 'white',
      color_mode: ChunkyPNG::COLOR_GRAYSCALE,
      module_px_size: 6,
      file: nil
    )

    # Преобразование изображения в размер 230x230 пикселей
    resized_png = resize_image(png, 230)

    # Обрезка изображения до активной области QR-кода
    cropped_png = crop_image(resized_png)

    # Отправка обрезанного изображения в ответ на запрос
    send_data cropped_png.to_blob, type: 'image/x-png', disposition: 'inline'
  end

  private

  def resize_image(png, target_size)
    width = png.width
    height = png.height

    if width > height
      ratio = target_size.to_f / width
      new_width = target_size
      new_height = (height * ratio).to_i
    else
      ratio = target_size.to_f / height
      new_width = (width * ratio).to_i
      new_height = target_size
    end

    png.resample_bilinear!(new_width, new_height)
  end

  def crop_image(png)
    x_min, y_min, x_max, y_max = bounding_box(png)
    cropped_png = png.crop(x_min, y_min, x_max - x_min + 1, y_max - y_min + 1)
    cropped_png
  end

  def bounding_box(png)
    x_min = png.width
    y_min = png.height
    x_max = y_max = 0

    png.height.times do |y|
      png.width.times do |x|
        if png[x, y] != ChunkyPNG::Color::WHITE
          x_min = [x, x_min].min
          y_min = [y, y_min].min
          x_max = [x, x_max].max
          y_max = [y, y_max].max
        end
      end
    end

    [x_min, y_min, x_max, y_max]
  end
end
