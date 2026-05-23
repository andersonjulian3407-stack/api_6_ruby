# Domain Layer — Contrato del repositorio de compañías
# Los repositorios concretos DEBEN implementar todos estos métodos
module CompanyRepositoryInterface
  def all_companies
    raise NotImplementedError, "#{self.class}#all_companies no implementado"
  end

  def find_company(id)
    raise NotImplementedError, "#{self.class}#find_company no implementado"
  end

  def create_company(data)
    raise NotImplementedError, "#{self.class}#create_company no implementado"
  end

  def update_company(id, data)
    raise NotImplementedError, "#{self.class}#update_company no implementado"
  end

  def delete_company(id)
    raise NotImplementedError, "#{self.class}#delete_company no implementado"
  end

  def employees_of(id)
    raise NotImplementedError, "#{self.class}#employees_of no implementado"
  end
end
