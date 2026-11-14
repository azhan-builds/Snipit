$database = "snippets.json"

function Add-Snippet($nickname) {
    if (!(Test-Path $database)) {
        "{}" | Set-Content $database
    }
    $snippets = Get-Content $database -Raw | ConvertFrom-Json
    if ($snippets.$nickname) {
        Write-host "This name has already been taken"
        return
    }

    $command = Read-Host "Enter the command"
    $description = Read-host "What does this command do?"
    $snippets | Add-Member -MemberType NoteProperty -Name $nickname -Value @{
        command = $command
        description = $description
    }
    $snippets | Convertto-json -Depth 5 | Set-Content $database
    Write-Host "Saved, you can now use '$nickname'."
}


$action = read-host "What do you want to do?"
if ($action -eq "add") {
    $nickname = Read-host "Give your command a nickname"
    Add-Snippet $nickname
}