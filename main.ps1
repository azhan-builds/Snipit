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

function List-Snippets {
    if (!(Test-path $database)) {
        Write-host "No snippets found yet"
        return
    }

    $snippets = Get-content $database -Raw | Convertfrom-Json
    if (($snippets.PSobject.properties.count -eq 0)) {
        write-host "Your snippet collection is empty "
        return
    }
    write-host "`nSaved snippets"
    write-host "---------------------"
    foreach ($snippet in $snippets.PSObject.properties) {
        write-host ""
        write-host $snippet.Name -Foregroundcolor Cyan
        write-host $snippet.Value.description
    }
}

function Show-Snippet($nickname) {
    if (!(test-path $database)) {
        write-host "no snippets found yet"
        return
    }

    $snippets = Get-content $database -Raw | Convertfrom-Json
    if (!($snippets.PSobject.properties.Name -contains $nickname)){
        write-host "no snippets foound under that name"
        return
    }
    write-host "`nSnippet: $nickname" -foregroundcolor cyan
    write-host "Description: $($snippets.$nickname.description)"
    write-host ""
    write-host "Command:"
    write-host $snippets.$nickname.command -foregroundcolor yellow
}

$action = read-host "What do you want to do?"
if ($action -eq "add") {
    $nickname = Read-host "Give your command a nickname"
    Add-Snippet $nickname
}
elseif ($action -eq "list") {
    List-Snippets
}
elseif ($action -eq "show"){
    $nickname = read-host "Which snippet do you want to see?"
    Show-Snippet($nickname)
}
else {
    Write-host "Unknown command!"
}