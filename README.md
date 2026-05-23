# Companies API — Ruby on Rails

API REST para gestión de compañías y empleados, implementando **Onion Architecture** con los patrones **Repository** y **Unit of Work**.

## Stack Tecnológico

| Componente | Tecnología |
|---|---|
| Lenguaje | Ruby 4.0 |
| Framework | Rails 8.1 (modo API) |
| ORM | Active Record |
| Base de datos | PostgreSQL |
| Variables de entorno | dotenv-rails |

---

## Arquitectura

La aplicación sigue la arquitectura **Onion (Cebolla)** con cuatro capas:

```
┌─────────────────────────────────┐
│   API Layer (Controllers)       │  ← Recibe HTTP, retorna JSON
├─────────────────────────────────┤
│   Application Layer             │  ← Services + DTOs
├─────────────────────────────────┤
│   Infrastructure Layer          │  ← Repositories + Unit of Work
├─────────────────────────────────┤
│   Domain Layer                  │  ← Models + Interfaces
└─────────────────────────────────┘
```

### Flujo obligatorio (imagen de la actividad)

```
Controller / Route
      ↓
Service Layer
      ↓
Unit of Work  ← agrupa operaciones en transacción atómica
      ↓
Repositories  ← preparan objetos sin .save
      ↓
ORM (Active Record)
      ↓
Database (PostgreSQL)
```

---

## Configuración

### 1. Variables de entorno

Editar `.env` en la raíz del proyecto:

```env
DB_USER=postgres
DB_PASSWORD=tu_password
DB_HOST=localhost
DB_PORT=5432
```

### 2. Base de datos y migraciones

```bash
rails db:create
rails db:migrate
rails db:seed
```

### 3. Levantar el servidor

```bash
rails server
# Servidor en http://localhost:3000
```

---

## Endpoints

### Compañías

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/api/companias` | Listar todas |
| GET | `/api/companias/:id` | Ver una |
| POST | `/api/companias` | Crear |
| PATCH/PUT | `/api/companias/:id` | Actualizar |
| DELETE | `/api/companias/:id` | Eliminar |
| GET | `/api/companias/:id/empleados` | Empleados de la compañía |
| **POST** | **`/api/companias/con_empleados`** | **Crear con empleados (Unit of Work)** |

### Empleados

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/api/empleados` | Listar todos |
| GET | `/api/empleados/:id` | Ver uno |
| POST | `/api/empleados` | Crear |
| PATCH/PUT | `/api/empleados/:id` | Actualizar |
| DELETE | `/api/empleados/:id` | Eliminar |

---

## Demostración del Unit of Work

El endpoint `POST /api/companias/con_empleados` demuestra la atomicidad:

```json
POST http://localhost:3000/api/companias/con_empleados
Content-Type: application/json

{
  "company": {
    "nombre": "Nueva Empresa",
    "direccion": "Calle 123",
    "telefono": "3001234567"
  },
  "empleados": [
    { "nombre": "Ana", "apellido": "Gómez", "correo": "ana@empresa.com", "cargo": "Dev", "salario": 3500000 },
    { "nombre": "Carlos", "apellido": "Rojas", "correo": "CORREO_INVALIDO", "cargo": "Test", "salario": 2800000 }
  ]
}
```

**Resultado esperado:** El segundo empleado tiene correo inválido → `ROLLBACK TOTAL`.  
Ni la compañía ni el primer empleado quedan guardados en la BD.

Ver logs en tiempo real:
```bash
Get-Content -Path log\development.log -Wait   # Windows PowerShell
```

---

## Estructura del Proyecto

```
companies_api/
├── app/
│   ├── controllers/api/
│   │   ├── companies_controller.rb  ← API Layer
│   │   └── employees_controller.rb  ← API Layer
│   ├── models/
│   │   ├── company.rb               ← Domain Layer
│   │   └── employee.rb              ← Domain Layer
│   ├── interfaces/                  ← Domain Layer (contratos)
│   │   ├── company_repository_interface.rb
│   │   └── employee_repository_interface.rb
│   ├── repositories/                ← Infrastructure Layer
│   │   ├── company_repository.rb
│   │   └── employee_repository.rb
│   ├── unit_of_work/                ← Infrastructure Layer
│   │   └── unit_of_work.rb
│   ├── services/                    ← Application Layer
│   │   ├── company_service.rb
│   │   └── employee_service.rb
│   └── dtos/                        ← Application Layer
│       ├── company_dto.rb
│       └── employee_dto.rb
├── config/
│   ├── routes.rb
│   ├── database.yml
│   └── application.rb
└── db/
    ├── migrate/
    │   ├── ..._create_companies.rb
    │   └── ..._create_employees.rb
    └── seeds.rb
```
