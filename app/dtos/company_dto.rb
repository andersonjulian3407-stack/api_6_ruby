# ONION: Capa de Aplicación - Objeto de transferencia de datos de compañía
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
