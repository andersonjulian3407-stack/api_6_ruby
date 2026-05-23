# API Layer — ApplicationController base
# Manejo global de errores para toda la API
class ApplicationController < ActionController::API
  # 404 — Recurso no encontrado
  rescue_from ActiveRecord::RecordNotFound do |e|
    Rails.logger.warn("[API] 404 RecordNotFound: #{e.message}")
    render json: { error: "Recurso no encontrado: #{e.message}" }, status: :not_found
  end

  # 400 — Parámetro requerido faltante
  rescue_from ActionController::ParameterMissing do |e|
    Rails.logger.warn("[API] 400 ParameterMissing: #{e.message}")
    render json: { error: "Parámetro requerido faltante: #{e.message}" }, status: :bad_request
  end

  # 422 — Validación fallida
  rescue_from ActiveRecord::RecordInvalid do |e|
    Rails.logger.warn("[API] 422 RecordInvalid: #{e.message}")
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end
end
