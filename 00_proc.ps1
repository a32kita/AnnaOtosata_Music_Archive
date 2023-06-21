# スクリプトファイルのディレクトリパスを取得
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# テキストファイルの一覧を取得
$txtFiles = Get-ChildItem -Path $scriptDir -Filter "*.txt"

# 処理済みファイルを移動するディレクトリ
$processedDir = Join-Path -Path $scriptDir -ChildPath "済"

# 処理済みファイルを格納するディレクトリが存在しない場合は作成する
if (-not (Test-Path $processedDir)) {
    New-Item -ItemType Directory -Path $processedDir | Out-Null
}

# 各テキストファイルを処理
foreach ($txtFile in $txtFiles) {
    # ファイルの内容を読み取る
    $content = Get-Content $txtFile.FullName -Encoding UTF8 | Where-Object { $_.Contains(") ♪") }

    # 出力ファイル名を生成
    $outputFile = [System.IO.Path]::ChangeExtension($txtFile.FullName, "_TS.txt")

    # 出力ファイルに内容を書き込む
    $content | Out-File -FilePath $outputFile -Encoding UTF8

    # 処理済みファイルを移動する
    $processedFile = Join-Path -Path $processedDir -ChildPath $txtFile.Name
    Move-Item -Path $txtFile.FullName -Destination $processedFile
}
