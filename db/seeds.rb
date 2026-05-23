# db/seeds.rb — Datos iniciales de la API
# Ejecutar con: rails db:seed

puts "=" * 50
puts "Limpiando datos existentes..."
Employee.destroy_all
Company.destroy_all

puts "Insertando compañías..."

c1 = Company.create!(
  nombre:    "Tech Solutions S.A.S",
  direccion: "Calle 45 # 10-20",
  telefono:  "3001234567"
)

c2 = Company.create!(
  nombre:    "DataCorp Ltda",
  direccion: "Carrera 7 # 32-10",
  telefono:  "3119876543"
)

c3 = Company.create!(
  nombre:    "InnovaSoft",
  direccion: "Av. El Dorado 92-30",
  telefono:  "6017654321"
)

puts "  ✓ #{Company.count} compañías insertadas"

puts "Insertando empleados..."

[
  { nombre: "Ana",     apellido: "Gómez",    correo: "ana.gomez@tech.com",        cargo: "Desarrolladora", salario: 3_500_000, company: c1 },
  { nombre: "Carlos",  apellido: "Rojas",    correo: "c.rojas@tech.com",          cargo: "Tester",         salario: 2_800_000, company: c1 },
  { nombre: "María",   apellido: "López",    correo: "m.lopez@tech.com",          cargo: "DevOps",         salario: 4_200_000, company: c1 },
  { nombre: "Pedro",   apellido: "Vargas",   correo: "p.vargas@datacorp.com",     cargo: "Analista",       salario: 3_100_000, company: c2 },
  { nombre: "Laura",   apellido: "Torres",   correo: "l.torres@datacorp.com",     cargo: "DBA",            salario: 3_800_000, company: c2 },
  { nombre: "Jorge",   apellido: "Castro",   correo: "j.castro@datacorp.com",     cargo: "Backend",        salario: 3_300_000, company: c2 },
  { nombre: "Sofía",   apellido: "Martínez", correo: "s.martinez@innovasoft.com", cargo: "UX Designer",    salario: 3_000_000, company: c3 },
  { nombre: "Andrés",  apellido: "Ríos",     correo: "a.rios@innovasoft.com",     cargo: "Frontend",       salario: 3_200_000, company: c3 },
  { nombre: "Valeria", apellido: "Pinto",    correo: "v.pinto@innovasoft.com",    cargo: "PM",             salario: 4_500_000, company: c3 },
  { nombre: "Diego",   apellido: "Herrera",  correo: "d.herrera@innovasoft.com",  cargo: "Arquitecto",     salario: 5_000_000, company: c3 }
].each { |attrs| Employee.create!(attrs) }

puts "  ✓ #{Employee.count} empleados insertados"
puts "=" * 50
puts "Seed completado: #{Company.count} compañías, #{Employee.count} empleados"
puts "=" * 50
