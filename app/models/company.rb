# Domain Layer — Modelo Company
# Representa la entidad Compañía con sus validaciones de negocio
class Company < ApplicationRecord
  has_many :employees, dependent: :destroy

  validates :nombre,    presence: true
  validates :direccion, presence: true
  validates :telefono,  presence: true
end
