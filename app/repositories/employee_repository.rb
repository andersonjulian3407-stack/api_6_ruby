# ONION: Capa de Infraestructura - Repositorio concreto que implementa EmployeeRepositoryInterface usando el ORM
# REGLA CLAVE: los métodos create/update NO llaman .save — eso lo hace el Unit of Work
class EmployeeRepository
  include EmployeeRepositoryInterface

  # Retorna todos los empleados con eager loading de su compañía
  def all_employees
    Employee.includes(:company).all
  end

  # Busca un empleado por ID — lanza ActiveRecord::RecordNotFound si no existe
  def find_employee(id)
    Employee.find(id)
  end

  # Construye el objeto pero NO lo persiste (responsabilidad del UoW)
  def create_employee(data)
    Employee.new(data)
  end

  # Asigna atributos pero NO llama save (responsabilidad del UoW)
  def update_employee(id, data)
    employee = find_employee(id)
    employee.assign_attributes(data)
    employee
  end

  # Destruye el registro inmediatamente
  def delete_employee(id)
    find_employee(id).destroy
  end
end
