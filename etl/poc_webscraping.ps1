
cls
$url = 'https://www.euro-millions.com/results/20-07-2018'
$PathFile = "F:\Gorilla\etl\"
$FileName = "so.txt"
$FullPath = $PathFile + $FileName
$FullPath2 = $PathFile + "so2.txt"
$results = @()
$website = Invoke-WebRequest –Uri $url
$tables = @($website.ParsedHtml.getElementsByTagName("TABLE"))
New-item -Name $FileName -Path $PathFile -Itemtype File -Force
For ($i=0; $i -le $tables.Count; $i++){
    $table = $tables[$i]
    $results = @()
    $results += $table.classname
    $results += $table.innerText
    $results += $table.textContent
    $results += "----------------------------------------------------------"
    $results | Out-File $FullPath -append
}
