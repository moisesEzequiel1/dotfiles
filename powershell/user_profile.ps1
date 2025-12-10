# PROFILE MINIMALISTA – ULTRA RÁPIDO

# Prompt VANILLA (sin oh-my-posh)
function prompt {
    $path = (Get-Location).Path
    Write-Host "$path" -ForegroundColor Cyan -NoNewline
    return " > "
}

# Alias básicos
Set-Alias ll Get-ChildItem
Set-Alias la "Get-ChildItem -Force"
Set-Alias l Get-ChildItem

# PSReadLine rápido
Set-PSReadLineOption -EditMode Windows
Set-PSReadLineOption -BellStyle None
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineOption -PredictionSource History

# Utilidad ligera
function which ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

# Abrir admin (sin plugins)
function admin {
    param([Parameter(ValueFromRemainingArguments=$true)] $Args)

    if ($Args.Count -gt 0) {
        $escapedArgs = $Args | ForEach-Object { "'$_'" }
        $cmd = $escapedArgs -join ' '
        Start-Process wt -Verb RunAs -ArgumentList "pwsh.exe -NoExit -Command $cmd"
    } else {
        Start-Process wt -Verb RunAs
    }
}
