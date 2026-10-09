# 4. Modelo conceptual

El modelo conceptual muestra **qué** información maneja el dominio y **cómo se relaciona**, sin detalles del motor (tipos de dato, índices, AUTO_INCREMENT, ENUM). Los nombres están en español porque describen conceptos del negocio; el modelo lógico los traduce a las tablas en inglés.

Notación de cardinalidad: `1:1`, `1:N`, `N:M`. La participación se indica como **obligatoria** (todo ejemplar debe participar) u **opcional**.

## Entidades y atributos principales

| Entidad | Atributos principales |
|---|---|
| PACIENTE | documento, tipo de documento, nombres, apellidos, fecha de nacimiento, sexo, contacto, ciudad |
| HISTORIA CLÍNICA | número, fecha de apertura, estado |
| PROFESIONAL | documento, nombres, registro profesional, especialidad, activo |
| ESPECIALIDAD | nombre |
| CONSULTA | fecha, motivo, valoración, plan, observaciones, cerrada |
| DIAGNÓSTICO | código CIE-10, nombre, es glaucoma |
| ANTECEDENTE PERSONAL | tipo, descripción, fecha |
| ANTECEDENTE FAMILIAR | enfermedad, parentesco |
| ALERGIA (ALÉRGENO) | sustancia, reacción |
| EXAMEN OFTALMOLÓGICO | ojo, agudeza visual, copa/disco, segmento anterior, fondo de ojo |
| PRESIÓN INTRAOCULAR | ojo, valor, método, fecha |
| PAQUIMETRÍA | ojo, espesor, fecha |
| GONIOSCOPÍA | ojo, grado de Shaffer, hallazgos, fecha |
| OCT | ojo, RNFL promedio, copa/disco, interpretación, validado, fecha |
| CAMPO VISUAL | ojo, MD, PSD, VFI, confiabilidad, interpretación, fecha |
| REGISTRO DE GLAUCOMA | tipo de glaucoma, fecha de diagnóstico, presión objetivo, estado clínico |
| CONTROL DE GLAUCOMA | fecha, progresión detectada, notas |
| MEDICAMENTO | nombre, principio activo, presentación, activo |
| TRATAMIENTO | ojo, dosis, frecuencia, fecha de inicio, fecha de fin, estado |
| PROCEDIMIENTO | tipo, categoría, ojo, fecha, notas |
| DOCUMENTO CLÍNICO | tipo, nombre de archivo, ruta, fecha de carga |
| ALERTA CLÍNICA | tipo, mensaje, leída |
| AUDITORÍA | tabla, registro, acción, valores anterior y nuevo, usuario, fecha |

## Relaciones y cardinalidades

| Relación | Cardinalidad | Participación |
|---|---|---|
| PACIENTE **tiene** HISTORIA CLÍNICA | 1:1 | Historia: obligatoria. Paciente: opcional (puede registrarse antes de abrir la historia). |
| HISTORIA CLÍNICA **registra** CONSULTA | 1:N | Consulta: obligatoria. Historia: opcional (puede estar recién abierta). |
| PROFESIONAL **atiende** CONSULTA | 1:N | Consulta: obligatoria. |
| ESPECIALIDAD **agrupa** PROFESIONAL | 1:N | Profesional: obligatoria. |
| CONSULTA **se asocia con** DIAGNÓSTICO | N:M (entidad asociativa *diagnóstico de consulta*: ojo, principal) | Opcional en ambos lados. |
| PACIENTE **presenta** ANTECEDENTE PERSONAL | 1:N | Opcional. |
| PACIENTE **reporta** ANTECEDENTE FAMILIAR de un DIAGNÓSTICO | 1:N (y N:1 con diagnóstico) | Opcional. |
| PACIENTE **es alérgico a** ALÉRGENO | N:M (entidad asociativa *alergia*: reacción) | Opcional. |
| CONSULTA **incluye** EXAMEN OFTALMOLÓGICO | 1:N (máximo uno por ojo) | Opcional. |
| CONSULTA **registra** PRESIÓN INTRAOCULAR | 1:N | Opcional. |
| CONSULTA **genera** PAQUIMETRÍA / GONIOSCOPÍA / OCT / CAMPO VISUAL | 1:N cada una | Opcional. |
| PACIENTE **tiene** REGISTRO DE GLAUCOMA | 1:0..1 | Solo pacientes con glaucoma. |
| REGISTRO DE GLAUCOMA **se clasifica en** TIPO DE GLAUCOMA | N:1 | Obligatoria. |
| REGISTRO DE GLAUCOMA **se sigue con** CONTROL DE GLAUCOMA | 1:N | Opcional. |
| CONSULTA **corresponde a** CONTROL DE GLAUCOMA | 1:0..1 | Opcional. |
| CONSULTA **formula** TRATAMIENTO de un MEDICAMENTO | 1:N (y N:1 con medicamento) | Opcional. |
| CONSULTA **origina** PROCEDIMIENTO de un TIPO | 1:N (y N:1 con tipo) | Opcional. |
| HISTORIA CLÍNICA **adjunta** DOCUMENTO CLÍNICO | 1:N | Opcional. |
| PACIENTE **recibe** ALERTA CLÍNICA | 1:N | Opcional. |
| AUDITORÍA | Independiente: referencia lógica a cualquier registro | — |

## Diagrama conceptual

```
                    ESPECIALIDAD
                         │ 1
                         │ N
PACIENTE ──1───1── HISTORIA CLÍNICA ──1───N── CONSULTA ──N───1── PROFESIONAL
 │  │  │                 │ 1                   │
 │  │  │                 │ N                   ├──N───M── DIAGNÓSTICO
 │  │  │          DOCUMENTO CLÍNICO            ├──1───N── EXAMEN OFTALMOLÓGICO (OD / OI)
 │  │  │                                       ├──1───N── PRESIÓN INTRAOCULAR
 │  │  ├──1───N── ANTECEDENTE PERSONAL         ├──1───N── PAQUIMETRÍA
 │  │  ├──1───N── ANTECEDENTE FAMILIAR         ├──1───N── GONIOSCOPÍA
 │  │  ├──N───M── ALÉRGENO                     ├──1───N── OCT
 │  │  └──1───N── ALERTA CLÍNICA               ├──1───N── CAMPO VISUAL
 │  │                                          ├──1───N── TRATAMIENTO ──N───1── MEDICAMENTO
 │  │                                          ├──1───N── PROCEDIMIENTO ──N───1── TIPO DE PROCEDIMIENTO
 │  │                                          │
 │  └──1──0..1── REGISTRO DE GLAUCOMA ──1───N── CONTROL DE GLAUCOMA ──0..1───1── CONSULTA
 │                      │ N
 │                      │ 1
 │               TIPO DE GLAUCOMA
```

## Reglas de negocio del dominio

1. Un paciente tiene una sola historia clínica; toda consulta pertenece a una historia.
2. Los datos clínicos (PIO, exámenes, tratamientos, procedimientos) se registran **dentro de una consulta**, lo que conserva fecha, profesional y contexto.
3. La mayoría de las mediciones se toman por ojo (OD/OI); diagnósticos, tratamientos y procedimientos admiten además AO (ambos ojos).
4. Un paciente con glaucoma tiene un único registro de glaucoma con su presión objetivo; cada control queda ligado a una consulta distinta.
5. Alergias, antecedentes familiares y antecedentes personales son conjuntos **independientes** entre sí (base de la 4FN).
6. Los cambios relevantes quedan registrados en la auditoría.
