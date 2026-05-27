# ONION: Capa de Infraestructura - Gestiona la atomicidad y consistencia de transacciones en la base de datos
#
# PREGUNTAS OBLIGATORIAS RESUELTAS:
# 1. ¿Qué es Unit of Work?
#    Patrón que agrupa múltiples operaciones de BD en una sola unidad atómica.
#    O todas se confirman (commit) o ninguna se guarda (rollback).
#
# 2. ¿Qué problema resuelve?
#    Evita estados parciales en la BD: si se guarda la compañía pero falla
#    un empleado, el UoW garantiza que tampoco quede la compañía.
#
# 3. Relación con Repository:
#    Los repositorios PREPARAN los objetos (new, assign_attributes).
#    El UoW decide CUÁNDO confirmarlos (save! dentro de transaction).
#
# 4. ¿El ORM lo implementa?
#    Sí — ActiveRecord::Base.transaction es la UoW nativa de Rails/Active Record.
#
# 5. Objeto que representa la unidad:
#    El bloque ActiveRecord::Base.transaction { } sobre la conexión PostgreSQL.
#
# 6. ¿Dónde vive en Onion?
#    En Infrastructure Layer, expuesto como servicio a la Application Layer.
#
# 7. ¿Los repos llaman Save?
#    No directamente. Solo el método UnitOfWork#save llama save! dentro del
#    bloque de transacción, donde el rollback es automático si falla.
#
# 8. ¿Cómo se revierte?
#    Lanzando cualquier excepción dentro del bloque (raise) o
#    raise ActiveRecord::Rollback para revertir silenciosamente.
#
# 9. ¿Cómo se garantiza atomicidad?
#    Todo el bloque corre en una sola transacción de PostgreSQL (BEGIN...COMMIT/ROLLBACK).
#
# 10. Ventajas en API empresarial:
#     Consistencia de datos, trazabilidad con logging, separación de responsabilidades,
#     y capacidad de agrupar operaciones complejas multi-entidad.

class UnitOfWork
  attr_reader :companies, :employees

  def initialize
    @companies = CompanyRepository.new
    @employees = EmployeeRepository.new
  end

  # Ejecuta un bloque dentro de una transacción PostgreSQL única.
  # Si cualquier excepción se lanza dentro del bloque → ROLLBACK automático.
  # Si el bloque termina sin error → COMMIT automático.
  def transaction(&block)
    ActiveRecord::Base.transaction do
      block.call(self)
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("[UoW] Validación fallida — ROLLBACK: #{e.message}")
    raise
  rescue ActiveRecord::Rollback => e
    Rails.logger.error("[UoW] Rollback explícito ejecutado")
    raise
  rescue StandardError => e
    Rails.logger.error("[UoW] Error inesperado — ROLLBACK: #{e.message}")
    raise
  end

  # Persiste el registro dentro de la transacción activa.
  # Usa save! para lanzar excepción si las validaciones fallan → rollback automático.
  def save(record)
    record.save!
  end
end
