# docker-compose-up-jupyter.ps1

# docker-compose buildを実行
Write-Host "Building with docker-compose..."
Start-Process -Wait -NoNewWindow "docker-compose" -ArgumentList "build"

# docker-composeを非同期で起動
Write-Host "Starting docker-compose in the background..."
Start-Process -NoNewWindow "docker-compose" -ArgumentList "up"

# 少し待機してJupyterLabが起動するのを確認
Write-Host "Waiting for JupyterLab to start..."
Start-Sleep -Seconds 10

# 最新のJupyterLabのコンテナIDを取得
Write-Host "Retrieving the container ID for JupyterLab..."
$containerID = docker ps | Select-String "jupyter" | % { $_.ToString().Split(' ')[0] }

if (-not $containerID) {
    Write-Error "JupyterLab container not found. Please check if it's running."
    exit 1
}

# コンテナのログを取得し、URLを検索
Write-Host "Extracting the JupyterLab URL from the container logs..."
$url = docker logs $containerID 2>&1 | Select-String "http://127.0.0.1:8888/.*?token=.*" | % { $_.Matches[0].Value } | Select-Object -Last 1

if (-not $url) {
    Write-Error "Unable to retrieve the JupyterLab URL from the logs. Please check the container logs manually."
    exit 1
}

# URLをブラウザで開く
Write-Host "Opening JupyterLab in the default browser..."
Start-Process $url
