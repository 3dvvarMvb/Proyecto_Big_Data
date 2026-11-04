#!/usr/bin/env bash
# Script para compilar todos los documentos del proyecto Big Data FWI Chile

set -e

echo "=== 1. Compilando Paper Estado del Arte y Solución (IEEE) ==="
pdflatex Estado_del_arte_y_Solucion/state_of_the_art_solution_ieee.tex

echo ""
echo "=== 2. Compilando Propuesta de Proyecto ==="
pdflatex Propuesta/propuesta_proyecto_fwi_bigdata.tex

echo ""
echo "=== 3. Compilando Presentación Beamer ==="
pdflatex Presentaciones/slides_presentacion_fwi.tex

echo ""
echo "=== 4. Compilando Guion de Exposición ==="
pdflatex Presentaciones/guion_problema_presentacion.tex

echo ""
echo "=== 5. Limpiando archivos auxiliares ==="
rm -f *.aux *.log *.out *.nav *.snm *.toc *.vrb

echo ""
echo "¡Listo! Todos los PDFs generados exitosamente:"
ls -lh *.pdf
