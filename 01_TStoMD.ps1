# スクリプトファイルのディレクトリパスを取得
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# テキストファイルの一覧を取得
$txtFiles = Get-ChildItem -Path $scriptDir -Filter "*.txt"

# 処理済みファイルを格納するディレクトリ
$processedDir = Join-Path -Path $scriptDir -ChildPath "出力"

# 処理済みファイルを格納するディレクトリが存在しない場合は作成する
if (-not (Test-Path $processedDir)) {
    New-Item -ItemType Directory -Path $processedDir | Out-Null
}

# 各テキストファイルを処理
foreach ($txtFile in $txtFiles) {
    # 出力ファイル名を生成
    $outputFile = [System.IO.Path]::ChangeExtension($txtFile.FullName, ".md")

    # ファイルの内容を読み取る
    $content = Get-Content $txtFile.FullName

    # 出力ファイルにヘッダーを書き込む
    $streamedDate = [DateTime]::ParseExact($txtFile.BaseName.Substring(0, 8), "yyyyMMdd", $null)
    $header = "### " + $streamedDate.ToString("yyyy 年 MM 月 dd 日の配信") + "`n| No | 曲名 | アーティスト | タイムスタンプ |`n| --: | :-- | :-- | :-- |"
    $header | Out-File -FilePath $outputFile -Encoding UTF8

    # 曲情報を出力ファイルに追加する
    $lineNumber = 1
    $songInfoPattern = "\((\d{2}:\d{2}:\d{2})\) ♪ (.*) / (.*)"
    foreach ($line in $content) {
        if ($line -like "*♪*") {
            #$timestamp = $line -replace '.*\((.*)\).*', '$1'
            #$songInfo = $line -replace '.*♪\s+(.*)', '$1'
            #$songInfo = $songInfo.Trim()

            #$outputLine = "| $lineNumber | $songInfo |  | $timestamp |"
            #$outputLine | Out-File -FilePath $outputFile -Append -Encoding UTF8

            # 曲情報を取得
            $matches = [regex]::Match($line, $songInfoPattern)

            # データを抽出
            $timeStamp = $matches.Groups[1].Value
            $songTitle = $matches.Groups[2].Value
            $artist = $matches.Groups[3].Value

            # 書き込む
            $outputLine = "| $lineNumber | $songTitle | $artist | $timeStamp |"
            $outputLine | Out-File -FilePath $outputFile -Append -Encoding UTF8

            $lineNumber++
        }
    }

    # 処理済みファイルを移動する
    $processedFile = Join-Path -Path $processedDir -ChildPath $txtFile.Name
    Move-Item -Path $txtFile.FullName -Destination $processedFile
}