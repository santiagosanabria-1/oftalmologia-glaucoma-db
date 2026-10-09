# Base de datos de historias clínicas de Oftalmología y Glaucoma

Proyecto académico: base de datos relacional normalizada hasta 4FN para gestionar historias clínicas del área de oftalmología y glaucoma (pacientes, consultas, diagnósticos, antecedentes, exámenes, PIO, OCT, campos visuales, tratamientos, procedimientos, controles de glaucoma y auditoría). Incluye el banco de 250 ejercicios resueltos y verificados.

- **Motor:** MariaDB 10.4+ (XAMPP). Todo el SQL evita sintaxis exclusiva de MySQL 8.
- **Base de datos:** `oftalmologia_glaucoma` (utf8mb4) — 30 tablas.

## Estructura del repositorio

```
docs/
  01-formulacion.md          Problema, pregunta, objetivos y alcance
  02-entidades.md            Entidades y relaciones
  03-diccionario-datos.md    Diccionario de las 30 tablas
  04-modelo-conceptual.md    Modelo conceptual y cardinalidades
  05-der.md                  DER en Mermaid (GitHub lo dibuja)
  06-modelo-logico.md        Modelo lógico con PK/FK
  07-normalizacion.md        0FN → 1FN → 2FN → 3FN → BCNF → 4FN
sql/
  01_schema.sql              DDL: tablas, PK, FK, UNIQUE, CHECK, DEFAULT
  02_seed.sql                Datos de prueba
  03_views.sql               4 vistas (vw_)
  04_functions.sql           3 funciones (fn_)
  05_procedures.sql          3 procedimientos (sp_)
  06_triggers.sql            3 triggers (trg_), incluida auditoría en audit_logs
  07_events.sql              1 evento (ev_)
ejercicios/
  parte1_consultas.sql       50 consultas
  parte2_subconsultas.sql    50 subconsultas
  parte3_procedimientos.sql  50 procedimientos
  parte4_triggers.sql        50 triggers (con pruebas comentadas)
  parte5_funciones.sql       50 funciones
evidencias/                  Capturas de ejecución
TallerExamenBd_completo.md   Enunciado del taller con las 250 soluciones
```

## Cómo ejecutarlo en XAMPP

1. Abrir el panel de XAMPP y encender **MySQL** (MariaDB).
2. Desde una terminal en la carpeta del repo, ejecutar los scripts **en este orden**:

```bash
C:\xampp\mysql\bin\mysql.exe -u root --default-character-set=utf8mb4 < sql\01_schema.sql
C:\xampp\mysql\bin\mysql.exe -u root --default-character-set=utf8mb4 < sql\02_seed.sql
C:\xampp\mysql\bin\mysql.exe -u root --default-character-set=utf8mb4 < sql\03_views.sql
C:\xampp\mysql\bin\mysql.exe -u root --default-character-set=utf8mb4 < sql\04_functions.sql
C:\xampp\mysql\bin\mysql.exe -u root --default-character-set=utf8mb4 < sql\05_procedures.sql
C:\xampp\mysql\bin\mysql.exe -u root --default-character-set=utf8mb4 < sql\06_triggers.sql
C:\xampp\mysql\bin\mysql.exe -u root --default-character-set=utf8mb4 < sql\07_events.sql
```

3. Luego los ejercicios, en orden (`parte1` … `parte5`). La Parte III inserta y modifica datos de prueba; para repetirla, volver a ejecutar `01_schema.sql` y `02_seed.sql`.
4. El evento necesita el programador de eventos encendido: `SET GLOBAL event_scheduler = ON;` (ver comentario en `07_events.sql`).

También se puede usar phpMyAdmin → pestaña **Importar**, respetando el mismo orden.

## Nota sobre el esquema

Los exámenes, la PIO, los tratamientos y los procedimientos no tienen `patient_id`: cuelgan de `medical_visits`, y el paciente se obtiene con `medical_visits → clinical_histories → patients` (ver `docs/07-normalizacion.md`). La vista `vw_patient_iop_history` simplifica ese recorrido para la PIO.

## Índice de entregables

| # | Entregable | Archivo |
|---|---|---|
| 1 | Formulación del problema | [docs/01-formulacion.md](docs/01-formulacion.md) |
| 2 | Identificación de entidades | [docs/02-entidades.md](docs/02-entidades.md) |
| 3 | Diccionario de datos | [docs/03-diccionario-datos.md](docs/03-diccionario-datos.md) |
| 4 | Modelo conceptual | [docs/04-modelo-conceptual.md](docs/04-modelo-conceptual.md) |
| 5 | DER | [docs/05-der.md](docs/05-der.md) |
| 6 | Modelo lógico | [docs/06-modelo-logico.md](docs/06-modelo-logico.md) |
| 7 | Normalización (1FN–4FN) | [docs/07-normalizacion.md](docs/07-normalizacion.md) |
| 8–9 | Modelo físico / DDL | [sql/01_schema.sql](sql/01_schema.sql) |
| 10 | Datos de prueba | [sql/02_seed.sql](sql/02_seed.sql) |
| — | Vistas, funciones, procedimientos, triggers, evento | [sql/](sql/) |
| 11 | Banco de 250 ejercicios | [ejercicios/](ejercicios/) y [TallerExamenBd_completo.md](TallerExamenBd_completo.md) |
| 12 | Evidencias de ejecución | [evidencias/](evidencias/) |

## Verificación

Todos los scripts se ejecutaron en orden desde una base vacía en MariaDB 10.4.34 sin errores: 250/250 ejercicios corren. Las validaciones de procedimientos y triggers se probaron con casos válidos e inválidos (los inválidos quedan comentados en los archivos con el error esperado).
