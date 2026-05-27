# ONION: Capa Externa (UI/Presentación) - Recibe peticiones HTTP y responde con JSON
module Api
  class CompaniesController < ApplicationController
    before_action :set_service

    # GET /api/companias
    def index
      companies = @service.get_all
      render json: companies, status: :ok
    end

    # GET /api/companias/:id
    def show
      company = @service.get_by_id(params[:id])
      render json: company, status: :ok
    end

    # POST /api/companias
    def create
      dto = CompanyDto.new(company_params)
      company = @service.create(dto)
      render json: company, status: :created
    end

    # PUT/PATCH /api/companias/:id
    def update
      dto = CompanyDto.new(company_params)
      company = @service.update(params[:id], dto)
      render json: company, status: :ok
    end

    # DELETE /api/companias/:id
    def destroy
      @service.delete(params[:id])
      head :no_content
    end

    # GET /api/companias/:id/empleados
    def empleados
      employees = @service.employees_of(params[:id])
      render json: employees, status: :ok
    end

    # POST /api/companias/con_empleados
    # ENDPOINT TRANSACCIONAL — Demuestra Unit of Work:
    # Crea compañía + empleados en una sola transacción atómica.
    # Si un empleado tiene correo inválido → ROLLBACK TOTAL.
    def con_empleados
      company_data = params.require(:company)
                           .permit(:nombre, :direccion, :telefono)
                           .to_h.symbolize_keys

      employees_data = params.require(:empleados).map do |e|
        e.permit(:nombre, :apellido, :correo, :cargo, :salario)
         .to_h.symbolize_keys
      end

      result = @service.create_with_employees(company_data, employees_data)
      render json: result, status: :created
    end

    private

    def set_service
      @service = CompanyService.new
    end

    def company_params
      params.require(:company).permit(:nombre, :direccion, :telefono).to_h.symbolize_keys
    end
  end
end
