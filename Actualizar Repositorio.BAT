@echo off
echo Actualizando el repositorio...

:: Cambiar a la carpeta donde está el script (asegúrate de ejecutarlo desde la raíz del repositorio)
cd /d "%~dp0"

:: Ejecutar git pull para actualizar el repositorio
git pull origin master
if %errorlevel% neq 0 (
    echo Error al actualizar el repositorio.
) else (
    echo Repositorio actualizado con éxito.
)

pause
