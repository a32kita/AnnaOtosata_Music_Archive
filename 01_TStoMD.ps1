# �X�N���v�g�t�@�C���̃f�B���N�g���p�X���擾
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# �e�L�X�g�t�@�C���̈ꗗ���擾
$txtFiles = Get-ChildItem -Path $scriptDir -Filter "*.txt"

# �����ς݃t�@�C�����i�[����f�B���N�g��
$processedDir = Join-Path -Path $scriptDir -ChildPath "�o��"

# �����ς݃t�@�C�����i�[����f�B���N�g�������݂��Ȃ��ꍇ�͍쐬����
if (-not (Test-Path $processedDir)) {
    New-Item -ItemType Directory -Path $processedDir | Out-Null
}

# �e�e�L�X�g�t�@�C��������
foreach ($txtFile in $txtFiles) {
    # �o�̓t�@�C�����𐶐�
    $outputFile = [System.IO.Path]::ChangeExtension($txtFile.FullName, ".md")

    # �t�@�C���̓��e��ǂݎ��
    $content = Get-Content $txtFile.FullName

    # �o�̓t�@�C���Ƀw�b�_�[����������
    $streamedDate = [DateTime]::ParseExact($txtFile.BaseName.Substring(0, 8), "yyyyMMdd", $null)
    $header = "### " + $streamedDate.ToString("yyyy �N MM �� dd ���̔z�M") + "`n| No | �Ȗ� | �A�[�e�B�X�g | �^�C���X�^���v |`n| --: | :-- | :-- | :-- |"
    $header | Out-File -FilePath $outputFile -Encoding UTF8

    # �ȏ����o�̓t�@�C���ɒǉ�����
    $lineNumber = 1
    $songInfoPattern = "\((\d{2}:\d{2}:\d{2})\) �� (.*) / (.*)"
    foreach ($line in $content) {
        if ($line -like "*��*") {
            #$timestamp = $line -replace '.*\((.*)\).*', '$1'
            #$songInfo = $line -replace '.*��\s+(.*)', '$1'
            #$songInfo = $songInfo.Trim()

            #$outputLine = "| $lineNumber | $songInfo |  | $timestamp |"
            #$outputLine | Out-File -FilePath $outputFile -Append -Encoding UTF8

            # �ȏ����擾
            $matches = [regex]::Match($line, $songInfoPattern)

            # �f�[�^�𒊏o
            $timeStamp = $matches.Groups[1].Value
            $songTitle = $matches.Groups[2].Value
            $artist = $matches.Groups[3].Value

            # ��������
            $outputLine = "| $lineNumber | $songTitle | $artist | $timeStamp |"
            $outputLine | Out-File -FilePath $outputFile -Append -Encoding UTF8

            $lineNumber++
        }
    }

    # �����ς݃t�@�C�����ړ�����
    $processedFile = Join-Path -Path $processedDir -ChildPath $txtFile.Name
    Move-Item -Path $txtFile.FullName -Destination $processedFile
}