# enable_sqlserver_tcp.ps1
# Ejecutar como Administrador en PowerShell

Write-Host "=== Habilitando TCP/IP en SQL Server Express ===" -ForegroundColor Cyan

# 1. Habilitar TCP/IP en el registro
$tcpPath = "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL16.SQLEXPRESS\MSSQLServer\SuperSocketNetLib\Tcp"
Set-ItemProperty -Path $tcpPath -Name "Enabled" -Value 1 -Type DWord
Write-Host "[OK] TCP/IP habilitado" -ForegroundColor Green

# 2. Iniciar SQL Server Browser (necesario para instancias nombradas)
Set-Service -Name "SQLBrowser" -StartupType Automatic
Start-Service -Name "SQLBrowser"
Write-Host "[OK] SQL Server Browser iniciado: $((Get-Service SQLBrowser).Status)" -ForegroundColor Green

# 3. Reiniciar SQL Server Express para aplicar cambios de protocolo
Restart-Service -Name "MSSQL`$SQLEXPRESS" -Force
Start-Sleep -Seconds 3
Write-Host "[OK] SQL Server Express reiniciado: $((Get-Service 'MSSQL`$SQLEXPRESS').Status)" -ForegroundColor Green

Write-Host ""
Write-Host "=== Listo! Ahora ejecuta 'rails db:create' en la terminal ===" -ForegroundColor Yellow
