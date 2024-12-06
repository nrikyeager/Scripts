# Nettoyage et mise à jour pour PowerShell et Bash
# Vérification des privilèges administrateur
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "Veuillez exécuter ce script en tant qu'administrateur."
    exit
}

# --------------------------
# Étape 1 : Nettoyage Windows
# --------------------------

Write-Host "Nettoyage des fichiers temporaires Windows..." -ForegroundColor Cyan
Remove-Item -Path "$env:Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:SystemRoot\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "Nettoyage des fichiers temporaires terminé." -ForegroundColor Green

Write-Host "Nettoyage du dossier WinSx
