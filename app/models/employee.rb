# ONION: Capa de Dominio (Núcleo) - Entidad de negocio que valida reglas internas de empleado
class Employee < ApplicationRecord
  belongs_to :company

  validates :nombre,   presence: true
  validates :apellido, presence: true
  validates :correo,   presence: true,
                       uniqueness: true,
                       format: { with: URI::MailTo::EMAIL_REGEXP, message: "no tiene formato válido" }
  validates :cargo,    presence: true
  validates :salario,  presence: true,
                       numericality: { greater_than: 0, message: "debe ser mayor a 0" }
end
