Rails.application.routes.draw do
  namespace :api do
    # Rutas de compañías
    # IMPORTANTE: con_empleados va en `collection` para evitar que Rails
    # lo interprete como un :id con valor "con_empleados"
    resources :companies, path: "companias" do
      collection do
        post :con_empleados  # POST /api/companias/con_empleados — endpoint transaccional
      end
      member do
        get :empleados       # GET /api/companias/:id/empleados
      end
    end

    # Rutas de empleados — acepta PATCH y PUT para actualizar
    resources :employees, path: "empleados"
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
