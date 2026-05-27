# ONION: Capa de Aplicación - Objeto de transferencia de datos de empleado
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
