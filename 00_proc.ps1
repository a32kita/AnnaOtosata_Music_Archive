# �X�N���v�g�t�@�C���̃f�B���N�g���p�X���擾
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# �e�L�X�g�t�@�C���̈ꗗ���擾
$txtFiles = Get-ChildItem -Path $scriptDir -Filter "*.txt"

# �����ς݃t�@�C�����ړ�����f�B���N�g��
$processedDir = Join-Path -Path $scriptDir -ChildPath "��"

# �����ς݃t�@�C�����i�[����f�B���N�g�������݂��Ȃ��ꍇ�͍쐬����
if (-not (Test-Path $processedDir)) {
    New-Item -ItemType Directory -Path $processedDir | Out-Null
}

# �e�e�L�X�g�t�@�C��������
foreach ($txtFile in $txtFiles) {
    # �t�@�C���̓��e��ǂݎ��
    $content = Get-Content $txtFile.FullName -Encoding UTF8 | Where-Object { $_.Contains(") ��") }

    # �o�̓t�@�C�����𐶐�
    $outputFile = [System.IO.Path]::ChangeExtension($txtFile.FullName, "_TS.txt")

    # �o�̓t�@�C���ɓ��e����������
    $content | Out-File -FilePath $outputFile -Encoding UTF8

    # �����ς݃t�@�C�����ړ�����
    $processedFile = Join-Path -Path $processedDir -ChildPath $txtFile.Name
    Move-Item -Path $txtFile.FullName -Destination $processedFile
}
