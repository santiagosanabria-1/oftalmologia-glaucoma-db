# Base de datos de historias clínicas de Oftalmología y Glaucoma

Proyecto académico: base de datos relacional normalizada hasta 4FN para gestionar historias clínicas del área de oftalmología y glaucoma (pacientes, consultas, diagnósticos, antecedentes, exámenes, PIO, OCT, campos visuales, tratamientos, procedimientos, controles de glaucoma y auditoría). Incluye el banco de 250 ejercicios resueltos y verificados.

- **Motor:** MySQL 8.4 en Docker (forma recomendada) o MariaDB 10.4+ con XAMPP. Todo el SQL se verificó en ambos motores.
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
  img/                       Imágenes del modelo conceptual, lógico y DER (PNG + fuente .dot)
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
.devcontainer/               Workspace de VS Code (Dev Container)
docker-compose.yml           MySQL 8.4 + phpMyAdmin + workspace
.env.example                 Plantilla de variables (copiar como .env)
TallerExamenBd_completo.md   Enunciado del taller con las 250 soluciones
```

## Cómo ejecutarlo con Docker (recomendado)

Requisito: Docker Desktop encendido.

1. Crear el archivo de variables a partir de la plantilla y cambiar las contraseñas:

```bash
copy .env.example .env
```

2. Levantar los contenedores:

```bash
docker compose up -d
```

Al crearse el volumen por primera vez, MySQL ejecuta solo los scripts de `sql/` en orden (`01_schema` → `07_events`), así que la base `oftalmologia_glaucoma` queda lista con datos, vistas, funciones, procedimientos, triggers y el evento (en MySQL 8.4 el `event_scheduler` ya viene encendido).

| Servicio | Contenedor | Acceso |
|---|---|---|
| MySQL 8.4 | `glaucoma_mysql_db` | `localhost:3307` (usuario `root` o el de `MYSQL_USER`) |
| phpMyAdmin | `glaucoma_phpmyadmin` | http://localhost:8081 |
| Workspace VS Code | `glaucoma-dev-workspace` | *Dev Containers: Reopen in Container* |

3. Ejecutar los ejercicios (por ejemplo, la Parte I) desde la terminal:

```bash
docker exec glaucoma_mysql_db sh -c 'mysql -u root -p"$MYSQL_ROOT_PASSWORD" < /ejercicios/parte1_consultas.sql'
```

(La carpeta `ejercicios/` está montada en `/ejercicios` dentro del contenedor; el comando funciona igual en PowerShell y en bash.)

o abrirlos en phpMyAdmin → pestaña **SQL** / **Importar**.

Para volver a la base limpia (borra los datos del volumen y vuelve a correr `sql/`):

```bash
docker compose down -v
```

Los puertos 3307 y 8081 son los mismos del contenedor `C:\mysql\mysqlcontainer`; si ese stack está encendido, apagarlo antes o cambiar `MYSQL_PORT` y `PHPMYADMIN_PORT` en `.env`.

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
4. En XAMPP el evento necesita el programador de eventos encendido: `SET GLOBAL event_scheduler = ON;` (ver comentario en `07_events.sql`).

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

Todos los scripts se ejecutaron en orden desde una base vacía, sin errores, en **MySQL 8.4.11** (Docker) y en **MariaDB 10.4.34**: 250/250 ejercicios corren en ambos. Las validaciones de procedimientos y triggers se probaron con casos válidos e inválidos (los inválidos quedan comentados en los archivos con el error esperado).
