# ONION: Capa de Aplicación - Contiene la lógica de negocio y orquesta los casos de uso
class EmployeeService
  def initialize(uow: UnitOfWork.new)
    @uow = uow
  end

  # Retorna todos los empleados (con eager loading de su compañía)
  def get_all
    Rails.logger.info("[EmployeeService] Consultando todos los empleados")
    @uow.employees.all_employees
  end

  # Busca empleado por ID — lanza RecordNotFound si no existe
  def get_by_id(id)
    Rails.logger.info("[EmployeeService] Buscando empleado ID: #{id}")
    @uow.employees.find_employee(id)
  end

  # Crea un empleado dentro de una transacción
  def create(dto)
    Rails.logger.info("[EmployeeService] Creando empleado: #{dto.nombre} #{dto.apellido}")
    @uow.transaction do |uow|
      emp = uow.employees.create_employee(dto.to_h)
      uow.save(emp)
      Rails.logger.info("[EmployeeService] Empleado creado con ID: #{emp.id}")
      emp
    end
  end

  # Actualiza un empleado dentro de una transacción
  def update(id, dto)
    Rails.logger.info("[EmployeeService] Actualizando empleado ID: #{id}")
    @uow.transaction do |uow|
      emp = uow.employees.update_employee(id, dto.to_h)
      uow.save(emp)
      Rails.logger.info("[EmployeeService] Empleado ID: #{id} actualizado")
      emp
    end
  end

  # Elimina un empleado
  def delete(id)
    Rails.logger.info("[EmployeeService] Eliminando empleado ID: #{id}")
    @uow.transaction do |uow|
      uow.employees.delete_employee(id)
      Rails.logger.info("[EmployeeService] Empleado ID: #{id} eliminado")
    end
  end
end
