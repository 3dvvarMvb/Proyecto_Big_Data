# Presentaciones y Material de Exposición Oral

Este directorio contiene las presentaciones en formato Beamer y los guiones orales utilizados para defender el proyecto ante el profesor Dr. Nicolás Hidalgo.

---

## Contenido del Directorio

| Archivo | Formato | Descripción |
| :--- | :--- | :--- |
| **`slides_presentacion_fwi.tex`** | LaTeX (Beamer) | Código fuente de las diapositivas de la presentación del proyecto. |
| **`slides_presentacion_fwi.pdf`** | PDF | Diapositivas compiladas para proyección. |
| **`guion_problema_presentacion.tex`** | LaTeX | Guion formal estructurado para el orador (Eduardo Valenzuela) enfocado en la diapositiva *"The problem we want to address"*. |
| **`guion_problema_presentacion.pdf`** | PDF | Guion compilado con tiempos, énfasis vocal y respuestas preparadas a posibles preguntas del profesor. |
| **`presentacion.pdf`** | PDF | Versión previa de la presentación del equipo. |

---

## Cómo Compilar

Para recompilar las diapositivas y el guion:
```bash
cd Presentaciones
pdflatex slides_presentacion_fwi.tex
pdflatex guion_problema_presentacion.tex
```
O desde la raíz del proyecto ejecutando `./compile_all.sh`.
