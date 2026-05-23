# API Layer — Controller de Empleados
# Recibe requests HTTP → delega a EmployeeService → retorna JSON
module Api
  class EmployeesController < ApplicationController
    before_action :set_service

    # GET /api/empleados
    def index
      render json: @service.get_all, status: :ok
    end

    # GET /api/empleados/:id
    def show
      render json: @service.get_by_id(params[:id]), status: :ok
    end

    # POST /api/empleados
    def create
      dto = EmployeeDto.new(employee_params)
      render json: @service.create(dto), status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    end

    # PUT/PATCH /api/empleados/:id
    def update
      dto = EmployeeDto.new(employee_params)
      render json: @service.update(params[:id], dto), status: :ok
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    end

    # DELETE /api/empleados/:id
    def destroy
      @service.delete(params[:id])
      head :no_content
    end

    private

    def set_service
      @service = EmployeeService.new
    end

    def employee_params
      params.require(:employee)
            .permit(:nombre, :apellido, :correo, :cargo, :salario, :company_id)
            .to_h.symbolize_keys
    end
  end
end
