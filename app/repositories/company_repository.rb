# Infrastructure Layer — Repositorio concreto de Compañías
# Implementa CompanyRepositoryInterface usando Active Record como ORM
# REGLA CLAVE: los métodos create/update NO llaman .save — eso lo hace el Unit of Work
class CompanyRepository
  include CompanyRepositoryInterface

  # Retorna todas las compañías
  def all_companies
    Company.all
  end

  # Busca una compañía por ID — lanza ActiveRecord::RecordNotFound si no existe
  def find_company(id)
    Company.find(id)
  end

  # Construye el objeto pero NO lo persiste (responsabilidad del UoW)
  def create_company(data)
    Company.new(data)
  end

  # Asigna atributos pero NO llama save (responsabilidad del UoW)
  def update_company(id, data)
    company = find_company(id)
    company.assign_attributes(data)
    company
  end

  # Destruye el registro inmediatamente (operación atómica simple)
  def delete_company(id)
    find_company(id).destroy
  end

  # Retorna los empleados asociados a la compañía
  def employees_of(id)
    find_company(id).employees
  end
end
