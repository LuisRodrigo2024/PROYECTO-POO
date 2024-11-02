@echo off
echo Actualizando el repositorio...

:: Cambia el directorio al directorio donde se encuentra el archivo .BAT
cd /d %~dp0

:: Ejecuta git pull para actualizar el repositorio
git pull origin master

echo Repositorio actualizado con éxito.
pause
