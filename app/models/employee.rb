# Domain Layer — Modelo Employee
# Representa la entidad Empleado con validaciones de negocio
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
