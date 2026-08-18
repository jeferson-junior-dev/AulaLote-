@echo off
setlocal

title Backup logico das tabelas

set "MYSQL_BIN=C:\Program Files\MySQL\MySQL Server 8.0\bin"
set "BANCO=dbteste"
set "DESTINO=C:\teste\backups\tabelas"
set "LOG=C:\teste\logs\backup_tabelas.log"

for /f %%I in ('powershell -NoProfile -Command "Get-Date -Format yyyy-MM-dd_HH-mm-ss"') do set "DATAHORA=%%I"

set "PASTA_BACKUP=%DESTINO%\tabelas_%DATAHORA%"
mkdir "%PASTA_BACKUP%" 2>nul

echo ================================================== >> "%LOG%"
echo Inicio do backup: %date% %time% >> "%LOG%"

echo Gerando backup de categorias...
"%MYSQL_BIN%\mysqldump.exe" --login-path=aula_backup --single-transaction --skip-lock-tables "%BANCO%" categorias > "%PASTA_BACKUP%\categorias.sql" 2>> "%LOG%"
if errorlevel 1 goto ERRO

echo Gerando backup de fornecedores...
"%MYSQL_BIN%\mysqldump.exe" --login-path=aula_backup --single-transaction --skip-lock-tables "%BANCO%" fornecedores > "%PASTA_BACKUP%\fornecedores.sql" 2>> "%LOG%"
if errorlevel 1 goto ERRO

echo Gerando backup de produtos...
"%MYSQL_BIN%\mysqldump.exe" --login-path=aula_backup --single-transaction --skip-lock-tables "%BANCO%" produtos > "%PASTA_BACKUP%\produtos.sql" 2>> "%LOG%"
if errorlevel 1 goto ERRO

echo Gerando backup conjunto...
"%MYSQL_BIN%\mysqldump.exe" --login-path=aula_backup --single-transaction --skip-lock-tables "%BANCO%" categorias fornecedores produtos > "%PASTA_BACKUP%\cadastros.sql" 2>> "%LOG%"
if errorlevel 1 goto ERRO

echo Backup concluido com sucesso.
echo Sucesso: %date% %time% >> "%LOG%"
goto FIM

:ERRO
echo ERRO durante o backup.
echo Falha: %date% %time% >> "%LOG%"
exit /b 1

:FIM
echo Termino: %date% %time% >> "%LOG%"
echo ================================================== >> "%LOG%"
pause
endlocal