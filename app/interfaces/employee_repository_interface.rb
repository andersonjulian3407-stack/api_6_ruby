# Domain Layer — Contrato del repositorio de empleados
module EmployeeRepositoryInterface
  def all_employees
    raise NotImplementedError, "#{self.class}#all_employees no implementado"
  end

  def find_employee(id)
    raise NotImplementedError, "#{self.class}#find_employee no implementado"
  end

  def create_employee(data)
    raise NotImplementedError, "#{self.class}#create_employee no implementado"
  end

  def update_employee(id, data)
    raise NotImplementedError, "#{self.class}#update_employee no implementado"
  end

  def delete_employee(id)
    raise NotImplementedError, "#{self.class}#delete_employee no implementado"
  end
end
