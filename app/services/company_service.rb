# Application Layer — Servicio de Compañías
# Orquesta las operaciones de negocio usando UnitOfWork y Repositories.
# Flujo: Controller → CompanyService → UnitOfWork → CompanyRepository → ActiveRecord → PostgreSQL
class CompanyService
  def initialize(uow: UnitOfWork.new)
    @uow = uow
  end

  # Retorna todas las compañías
  def get_all
    Rails.logger.info("[CompanyService] Consultando todas las compañías")
    @uow.companies.all_companies
  end

  # Busca compañía por ID — lanza RecordNotFound si no existe
  def get_by_id(id)
    Rails.logger.info("[CompanyService] Buscando compañía ID: #{id}")
    @uow.companies.find_company(id)
  end

  # Crea una compañía dentro de una transacción
  def create(dto)
    Rails.logger.info("[CompanyService] Iniciando creación de compañía: #{dto.nombre}")
    @uow.transaction do |uow|
      company = uow.companies.create_company(dto.to_h)
      uow.save(company)
      Rails.logger.info("[CompanyService] Compañía creada con ID: #{company.id}")
      company
    end
  end

  # Actualiza una compañía dentro de una transacción
  def update(id, dto)
    Rails.logger.info("[CompanyService] Actualizando compañía ID: #{id}")
    @uow.transaction do |uow|
      company = uow.companies.update_company(id, dto.to_h)
      uow.save(company)
      Rails.logger.info("[CompanyService] Compañía ID: #{id} actualizada")
      company
    end
  end

  # Elimina una compañía (y sus empleados por dependent: :destroy)
  def delete(id)
    Rails.logger.info("[CompanyService] Eliminando compañía ID: #{id}")
    @uow.transaction do |uow|
      uow.companies.delete_company(id)
      Rails.logger.info("[CompanyService] Compañía ID: #{id} eliminada")
    end
  end

  # Retorna los empleados de una compañía específica
  def employees_of(id)
    Rails.logger.info("[CompanyService] Consultando empleados de compañía ID: #{id}")
    @uow.companies.employees_of(id)
  end

  # ENDPOINT TRANSACCIONAL — Demuestra Unit of Work en acción:
  # Crea compañía + N empleados en UNA sola transacción.
  # Si cualquier empleado falla (ej: correo inválido) → ROLLBACK TOTAL.
  # Ni la compañía ni los empleados anteriores quedan guardados.
  def create_with_employees(company_data, employees_data)
    Rails.logger.info("[UoW] *** INICIO TRANSACCIÓN: crear compañía con #{employees_data.size} empleado(s) ***")

    result = @uow.transaction do |uow|
      # Paso 1: crear y persistir la compañía
      company = uow.companies.create_company(company_data)
      uow.save(company)
      Rails.logger.info("[UoW] Compañía '#{company.nombre}' guardada (ID: #{company.id})")

      # Paso 2: crear y persistir cada empleado — si uno falla, rollback total
      employees_data.each_with_index do |emp_data, index|
        employee = uow.employees.create_employee(emp_data.merge(company_id: company.id))
        uow.save(employee)
        Rails.logger.info("[UoW] Empleado #{index + 1}/#{employees_data.size} '#{employee.nombre}' guardado")
      end

      Rails.logger.info("[UoW] *** COMMIT: transacción confirmada exitosamente ***")
      company.reload.as_json(include: :employees)
    end

    result
  rescue => e
    Rails.logger.error("[UoW] *** ROLLBACK: transacción revertida — #{e.message} ***")
    raise
  end
end
