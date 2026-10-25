$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Push-Location $ScriptDir
try { python -m ubtoolkit @args; exit $LASTEXITCODE } finally { Pop-Location }
