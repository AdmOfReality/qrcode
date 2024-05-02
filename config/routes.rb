Rails.application.routes.draw do
  controller :pages do
    get :generate_qr
  end
end
