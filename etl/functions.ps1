Function GetDayOfWeekString ([int]$dow)
{
    $return_dow = ''
    if ($dow -eq 0) {$return_dow = 'sunday'}
    elseif ($dow -eq 1) {$return_dow = 'monday'}
    elseif ($dow -eq 2) {$return_dow = 'tuesday'}
    elseif ($dow -eq 3) {$return_dow = 'wednesday'}
    elseif ($dow -eq 4) {$return_dow = 'thursday'}
    elseif ($dow -eq 5) {$return_dow = 'friday'}
    elseif ($dow -eq 6) {$return_dow = 'saturday'}
    else {$return_dow = 'unknown'}
    
    return $return_dow
}


Function scrapwebsite ([string]$url, [string]$path, [string]$filename)
{
    $fullpath = $path + $FileName
    If(!(test-path $path))
    {
      New-Item -ItemType Directory -Force -Path $path
    }
    $website = Invoke-WebRequest –Uri $url
    $tables = @($website.ParsedHtml.getElementsByTagName("TABLE"))
    New-item -Name $filename -Path $path -Itemtype File -Force
    For ($i=0; $i -le $tables.Count; $i++){
        $table = $tables[$i]
        $results = @()
        $results += $table.classname
        $results += $table.innerText
        $results += $table.textContent
        $results | Out-File $fullpath -append
    }
    return 1
}


function insertwebsitelog ([Data.SqlClient.SqlConnection] $OpenSQLConnection, [int] $draw_id, [datetime] $draw_date, [string] $website_name, [string] $website_url_full, [string] $local_url_full, [datetime] $download_starts, [datetime] $download_ends, [boolean] $is_success) 
{
    $insert_text = "SET NOCOUNT ON; INSERT INTO dbo.website_log (lottery_draw_id, lottery_draw_date, website_name, website_url_full, local_url_full, download_starts, download_ends, is_success) " +
                    "VALUES (@lottery_draw_id, @lottery_draw_date, @website_name, @website_url_full, @local_url_full, @download_starts, @download_ends, @is_success);"
    $sqlCommand = New-Object System.Data.SqlClient.SqlCommand
    $sqlCommand.Connection = $OpenSQLConnection
    $sqlCommand.CommandText = $insert_text
    $sqlCommand.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@lottery_draw_id",[Data.SQLDBType]::int))) | Out-Null
    $sqlCommand.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@lottery_draw_date",[Data.SQLDBType]::date))) | Out-Null
    $sqlCommand.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@website_name",[Data.SQLDBType]::varchar,64))) | Out-Null
    $sqlCommand.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@website_url_full",[Data.SQLDBType]::varchar,512))) | Out-Null
    $sqlCommand.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@local_url_full",[Data.SQLDBType]::varchar,512))) | Out-Null
    $sqlCommand.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@download_starts",[Data.SQLDBType]::DateTime2))) | Out-Null
    $sqlCommand.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@download_ends",[Data.SQLDBType]::DateTime2))) | Out-Null
    $sqlCommand.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@is_success",[Data.SQLDBType]::boolean))) | Out-Null

    $sqlCommand.Parameters[0].Value = $draw_id
    $sqlCommand.Parameters[1].Value = $draw_date
    $sqlCommand.Parameters[2].Value = $website_name
    $sqlCommand.Parameters[3].Value = $website_url_full
    $sqlCommand.Parameters[4].Value = $local_url_full
    $sqlCommand.Parameters[5].Value = $download_starts
    $sqlCommand.Parameters[6].Value = $download_ends
    $sqlCommand.Parameters[7].Value = $is_success
    $sqlCommand.ExecuteScalar()
}