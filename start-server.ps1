# Serveur HTTP simple pour Windows
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  Serveur Web Local - LuxeWatch" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Le site sera accessible sur: " -NoNewline
Write-Host "http://localhost:8000" -ForegroundColor Yellow
Write-Host ""
Write-Host "Appuyez sur Ctrl+C pour arrêter le serveur" -ForegroundColor Red
Write-Host ""

$port = 8000
$url = "http://localhost:$port/"
$path = Split-Path -Parent $MyInvocation.MyCommand.Path

# Créer un listener HTTP
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($url)
$listener.Start()

Write-Host "Serveur démarré avec succès!" -ForegroundColor Green
Write-Host ""
Start-Process $url

# Fonction pour obtenir le type MIME
function Get-MimeType {
    param([string]$filePath)
    $extension = [System.IO.Path]::GetExtension($filePath).ToLower()
    $mimeTypes = @{
        '.html' = 'text/html; charset=utf-8'
        '.css' = 'text/css'
        '.js' = 'application/javascript'
        '.json' = 'application/json'
        '.png' = 'image/png'
        '.jpg' = 'image/jpeg'
        '.jpeg' = 'image/jpeg'
        '.gif' = 'image/gif'
        '.svg' = 'image/svg+xml'
        '.ico' = 'image/x-icon'
    }
    return $mimeTypes[$extension] ?? 'text/plain'
}

# Boucle principale du serveur
try {
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response
        
        $localPath = $request.Url.LocalPath
        if ($localPath -eq "/") {
            $localPath = "/index.html"
        }
        
        $filePath = Join-Path $path $localPath.TrimStart('/')
        
        if (Test-Path $filePath -PathType Leaf) {
            $content = [System.IO.File]::ReadAllBytes($filePath)
            $mimeType = Get-MimeType $filePath
            
            $response.ContentType = $mimeType
            $response.ContentLength64 = $content.Length
            $response.StatusCode = 200
            $response.OutputStream.Write($content, 0, $content.Length)
            
            Write-Host "$($request.HttpMethod) $localPath - 200" -ForegroundColor Green
        } else {
            $response.StatusCode = 404
            $response.ContentType = 'text/html; charset=utf-8'
            $notFound = "<html><body><h1>404 - Page non trouvée</h1></body></html>"
            $buffer = [System.Text.Encoding]::UTF8.GetBytes($notFound)
            $response.ContentLength64 = $buffer.Length
            $response.OutputStream.Write($buffer, 0, $buffer.Length)
            
            Write-Host "$($request.HttpMethod) $localPath - 404" -ForegroundColor Red
        }
        
        $response.Close()
    }
} finally {
    $listener.Stop()
    Write-Host "Serveur arrêté." -ForegroundColor Yellow
}
