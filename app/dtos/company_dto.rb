# Application Layer — DTO de Compañía
# Data Transfer Object: transporta solo los campos que la API acepta,
# evitando mass assignment directo y separando la capa de presentación del dominio.
class CompanyDto
  attr_accessor :nombre, :direccion, :telefono

  def initialize(params)
    @nombre    = params[:nombre]
    @direccion = params[:direccion]
    @telefono  = params[:telefono]
  end

  def to_h
    { nombre: @nombre, direccion: @direccion, telefono: @telefono }
  end
end
