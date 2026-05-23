# Application Layer — DTO de Empleado
# Data Transfer Object: transporta solo los campos que la API acepta,
# incluyendo company_id como referencia de la relación.
class EmployeeDto
  attr_accessor :nombre, :apellido, :correo, :cargo, :salario, :company_id

  def initialize(params)
    @nombre     = params[:nombre]
    @apellido   = params[:apellido]
    @correo     = params[:correo]
    @cargo      = params[:cargo]
    @salario    = params[:salario]
    @company_id = params[:company_id]
  end

  def to_h
    {
      nombre:     @nombre,
      apellido:   @apellido,
      correo:     @correo,
      cargo:      @cargo,
      salario:    @salario,
      company_id: @company_id
    }
  end
end
