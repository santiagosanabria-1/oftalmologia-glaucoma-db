# 1. Formulación del problema

## Título

**Diseño e implementación de una base de datos relacional normalizada para la gestión de historias clínicas de pacientes del área de oftalmología y glaucoma.**

## Problema

El área de oftalmología y glaucoma maneja información clínica con muchas relaciones y una alta dependencia del histórico del paciente. Cada paciente asiste a varias consultas a lo largo del tiempo y en cada atención se generan datos de distinto tipo: diagnósticos, examen oftalmológico, presión intraocular (PIO), tratamientos y estudios especializados (OCT, campo visual, paquimetría y gonioscopía).

En el glaucoma la necesidad de conservar el histórico es aún mayor, porque la PIO, el estado del nervio óptico, la paquimetría, el OCT y el campo visual deben compararse entre controles. Además, casi todas las variables se registran por separado para cada ojo (**OD** = ojo derecho, **OI** = ojo izquierdo).

Si esta información se guarda de forma desestructurada (por ejemplo, una sola tabla con columnas `diagnostico1`, `diagnostico2`, `presion_od_1`, `presion_oi_1`, `oct1`, `oct2`…), aparecen:

- grupos repetitivos y valores multivaluados en una misma celda;
- redundancia y datos repetidos;
- inconsistencias entre registros;
- anomalías de inserción, actualización y eliminación;
- pérdida de trazabilidad y dificultad para consultar la evolución histórica;
- dificultad para obtener indicadores y reportes;
- dependencia excesiva de campos de texto libre.

### Situación problema

```
1 paciente
   ├── 1 historia clínica
   ├── N consultas
   │     ├── N diagnósticos
   │     ├── examen oftalmológico (OD / OI)
   │     ├── N mediciones de PIO
   │     └── N tratamientos y procedimientos
   ├── N antecedentes (personales, familiares, alergias)
   └── N estudios especializados: OCT, campo visual, paquimetría, gonioscopía
```

### Problema central

Se requiere una base de datos relacional que represente correctamente las relaciones entre pacientes, historias clínicas, consultas, diagnósticos, antecedentes, medicamentos, tratamientos, estudios oftalmológicos y controles de glaucoma, normalizada hasta la **Cuarta Forma Normal (4FN)** y capaz de responder consultas de distinto nivel de complejidad.

## Pregunta problema

**¿Cómo diseñar e implementar una base de datos relacional en MySQL, normalizada hasta la Cuarta Forma Normal, que permita almacenar, relacionar, consultar y procesar eficientemente la información de las historias clínicas de pacientes del área de oftalmología y glaucoma?**

## Objetivo general

Diseñar e implementar una base de datos relacional en MySQL (ejecutada en MariaDB 10.4+ vía XAMPP) para la gestión de historias clínicas del área de oftalmología y glaucoma, aplicando modelado de datos, normalización hasta 4FN, integridad referencial y consultas SQL de distintos niveles de complejidad.

## Objetivos específicos

1. Identificar las entidades, atributos y relaciones necesarias para representar la información clínica.
2. Construir el modelo conceptual.
3. Diseñar el modelo lógico relacional.
4. Elaborar el Diagrama Entidad-Relación (DER).
5. Aplicar la normalización hasta 4FN.
6. Implementar el modelo físico en MySQL/MariaDB.
7. Definir claves primarias y foráneas.
8. Implementar restricciones de integridad: `PRIMARY KEY`, `FOREIGN KEY`, `NOT NULL`, `UNIQUE`, `CHECK` y `DEFAULT`.
9. Insertar datos de prueba coherentes con el dominio.
10. Construir consultas básicas, intermedias y avanzadas.
11. Implementar subconsultas.
12. Aplicar funciones agregadas, `GROUP BY` y `HAVING`.
13. Implementar vistas para consultas recurrentes.
14. Desarrollar procedimientos almacenados.
15. Implementar funciones almacenadas.
16. Crear triggers para automatizar validaciones y auditoría.
17. Usar eventos programados donde el caso lo requiera.

## Alcance

El proyecto se limita al **diseño, implementación y explotación de la base de datos**. El producto es una base de datos funcional con sus scripts y documentación.

**Incluye** la gestión de: pacientes, historias clínicas, profesionales, especialidades, consultas, antecedentes (personales, familiares y alergias), diagnósticos, exámenes oftalmológicos, presión intraocular, paquimetrías, gonioscopías, OCT, campos visuales, tratamientos, medicamentos, procedimientos, controles de glaucoma, documentos clínicos, alertas clínicas y auditoría.

**No incluye:** frontend, aplicación web o móvil, API REST, backend ni interfaces gráficas.

### Entregables

| # | Entregable | Ubicación |
|---|---|---|
| 1 | Formulación del problema | `docs/01-formulacion.md` |
| 2 | Identificación de entidades | `docs/02-entidades.md` |
| 3 | Diccionario de datos | `docs/03-diccionario-datos.md` |
| 4 | Modelo conceptual | `docs/04-modelo-conceptual.md` |
| 5 | DER | `docs/05-der.md` |
| 6 | Modelo lógico | `docs/06-modelo-logico.md` |
| 7 | Normalización (1FN → 4FN) | `docs/07-normalizacion.md` |
| 8–9 | Modelo físico y script DDL | `sql/01_schema.sql` |
| 10 | Datos de prueba | `sql/02_seed.sql` |
| — | Vistas, funciones, procedimientos, triggers y evento | `sql/03_views.sql` … `sql/07_events.sql` |
| 11 | Banco de 250 ejercicios | `ejercicios/parte1…parte5` |
| 12 | Evidencias de ejecución | `evidencias/` |

## Pregunta orientadora final

**¿Cómo modelar, normalizar e implementar en MySQL una base de datos relacional para historias clínicas de oftalmología y glaucoma que garantice integridad, reduzca redundancia y soporte consultas y procesos SQL de distintos niveles de complejidad?**
