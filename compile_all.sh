#!/usr/bin/env bash
# Script para compilar todos los documentos del proyecto Big Data FWI Chile
set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== 1. Compilando Propuesta de Proyecto (Hito 1) ==="
cd "$PROJECT_ROOT/Propuesta"
pdflatex propuesta_proyecto_fwi_bigdata.tex

echo ""
echo "=== 2. Compilando Presentación Beamer y Guion de Exposición ==="
cd "$PROJECT_ROOT/Presentaciones"
pdflatex slides_presentacion_fwi.tex
pdflatex guion_problema_presentacion.tex

echo ""
echo "=== 3. Compilando Paper Estado del Arte y Solución (Hito 2 - IEEE) ==="
cd "$PROJECT_ROOT/Estado_del_arte_y_Solucion"
pdflatex state_of_the_art_solution_ieee.tex

echo ""
echo "=== 4. Limpiando archivos auxiliares ==="
cd "$PROJECT_ROOT"
find . -type f \( -name "*.aux" -o -name "*.log" -o -name "*.out" -o -name "*.nav" -o -name "*.snm" -o -name "*.toc" -o -name "*.vrb" \) -delete

echo ""
echo "¡Listo! Todos los PDFs generados exitosamente:"
find "$PROJECT_ROOT" -type f -name "*.pdf" | sort -u | while read -r pdf; do
    echo "  - $(basename "$pdf") (${pdf#$PROJECT_ROOT/})"
done
