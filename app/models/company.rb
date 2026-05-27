# ONION: Capa de Dominio (Núcleo) - Entidad de negocio que valida reglas internas de compañía
class Company < ApplicationRecord
  has_many :employees, dependent: :destroy

  validates :nombre,    presence: true
  validates :direccion, presence: true
  validates :telefono,  presence: true
end
