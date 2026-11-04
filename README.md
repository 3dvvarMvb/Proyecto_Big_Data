# Proyecto Big Data: Estimación Distribuida del Peligro de Incendios en Chile (FWI 1960–2100)

**Universidad Diego Portales (UDP) — Facultad de Ingeniería y Ciencias**  
*Curso:* Sistemas de Procesamiento para Big Data  
*Profesor Guía:* Dr. Nicolás Hidalgo  
*Integrantes:* Agustín Pizarro, Eduardo Valenzuela, Benjamín Zúñiga  

---

## 📌 Documento Maestro de Contexto Completo

Para conocer la historia detallada del proyecto, desde cómo se ideó hasta el estado actual, fundamentos matemáticos del FWI, auditoría de datos, respuestas a las dudas del profesor y el diseño arquitectónico de sistemas distribuidos, consulte:

👉 **[`PROYECTO_CONTEXTO_COMPLETO.md`](PROYECTO_CONTEXTO_COMPLETO.md)**

---

## 📁 Estructura del Repositorio

El repositorio está organizado en directorios modulares según los distintos hitos y tipos de entregas:

```text
/home/edu/Documentos/proyecto_big_data/
├── README.md                                    # Esta portada
├── PROYECTO_CONTEXTO_COMPLETO.md                # Memoria completa y contexto del proyecto
├── compile_all.sh                               # Script para compilar todos los documentos
│
├── Propuesta/                                   # HITO 1: Definición del Problema y Propuesta Inicial
│   ├── README.md                                # Detalle de la propuesta
│   ├── propuesta_proyecto_fwi_bigdata.tex       # Código fuente LaTeX
│   ├── propuesta_proyecto_fwi_bigdata.pdf       # Documento compilado
│   └── wildfire_fwi_bigdata_project.md          # Resumen original en markdown
│
├── Presentaciones/                              # EXPOSICIONES ORALES Y DIAPOSITIVAS
│   ├── README.md                                # Detalle del material oral
│   ├── slides_presentacion_fwi.tex              # Presentación en Beamer
│   ├── slides_presentacion_fwi.pdf              # Diapositivas compiladas
│   ├── guion_problema_presentacion.tex          # Guion formal del orador
│   ├── guion_problema_presentacion.pdf          # Guion compilado
│   └── presentacion.pdf                         # Presentación previa
│
└── Estado_del_arte_y_Solucion/                  # HITO 2: Estado del Arte y Solución (IEEE)
    ├── README.md                                # Detalle del Hito 2
    ├── state_of_the_art_solution_ieee.tex       # Paper formal IEEE (6 páginas, dos columnas)
    ├── state_of_the_art_solution_ieee.pdf       # Paper compilado listo para entrega
    ├── IEEEtran.cls                             # Plantilla oficial IEEE v1.8b
    ├── auditoria_papers_y_apis.md               # Auditoría técnica de 18 papers y catálogo de 6 APIs
    └── Paper_instructions.md                    # Pauta de evaluación del profesor
```

---

## 🚀 Compilación Automatizada

Para compilar todos los informes, presentaciones y papers de una sola vez:

```bash
cd /home/edu/Documentos/proyecto_big_data
./compile_all.sh
```

El script utiliza el compilador local **Tectonic/pdflatex**, genera todos los PDFs en sus respectivas carpetas y limpia automáticamente los archivos auxiliares temporales.
