Rails.application.routes.draw do
  controller :pages do
    get :generate_qr
  end

  controller :qr_barby do
    get :qr
  end
end
