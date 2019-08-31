# EUROMILLION RESULTS ETL PROCESS #
#
# Process to be executed four times: Friday 10pm, Saturday 6pm, Tuesday 10pm, Wednesday 6pm
#
# High-level view of ETL process:
# 1) Scrape data from website and save it into a csv or xlxs format
# 2) Load data into SQL Server
# 3) Run SQL Server script to extract and transform only the desired data. Historical data may have a different format
# 4) Run DQ process to ensure data is consistent and accurate 
# 5) Send email to inform success or failure and to provide report of data extracted
#
#
# ETL filename: F:\Gorilla\etl\etl.ps1

# INSERT DATA INTO DATABASE
#http://www.sqlservercentral.com/blogs/nycnet/2013/05/24/performing-an-insert-from-a-powershell-script/


. "$PSScriptRoot\functions.ps1"

$servername = 'SONIA010\SQL2016DEV'
$databasename = 'Gorilla2.0'
$query1 = 'SELECT web.website_name, web.lottery_name, web.website_url, web.website_page_format, web.website_data_from_when, max_lottery_draw_id = MAX(lottery_draw_id),  max_lottery_draw_date = MAX(lottery_draw_date)
          FROM dbo.website web LEFT JOIN dbo.website_log wlg ON wlg.website_name = web.website_name
          GROUP BY web.website_name, web.lottery_name, web.website_url, web.website_page_format, web.website_data_from_when'
$query2 = 'SELECT * FROM dbo.lottery_frequency WHERE IsActive = 1'
$connectiontimeout = 90
$querytimeout = 90


$conn=new-object System.Data.SqlClient.SQLConnection
$connectionstring = "Server={0};Database={1};Integrated Security=True;Connect Timeout={2}" -f $servername,$databasename,$connectiontimeout
$conn.connectionstring=$connectionstring
$conn.Open()

$cmd=new-object system.Data.SqlClient.SqlCommand($query1,$conn)
$cmd.CommandTimeout=$querytimeout
$ds_website=New-Object system.Data.DataSet
$da_website=New-Object system.Data.SqlClient.SqlDataAdapter($cmd)
[void]$da_website.fill($ds_website)

$cmd=new-object system.Data.SqlClient.SqlCommand($query2,$conn)
$cmd.CommandTimeout=$querytimeout
$ds_frequency=New-Object system.Data.DataSet
$da_frequency=New-Object system.Data.SqlClient.SqlDataAdapter($cmd)
[void]$da_frequency.fill($ds_frequency)

$conn.Close()
$conn.Dispose()

$today_date = Get-Date
$today_weekday = GetDayOfWeekString($today_date.DayOfWeek.value__)


write-output "today_date: $today_date"
write-output "today_weekday: $today_weekday"

if ($ds_website.Tables[0].rows.Count -eq 0)
    {
        write-output "ds_website is empty"
        Exit
    }

###################################################################################
# Loop through website table (dbo.website) e.g. euro-millions.com, merseyside, etc.
###################################################################################
foreach ($row in $ds_website.tables[0].rows)
{ 
    $website_name = $row.website_name
    $lottery_name = $row.lottery_name
    $website_url = $row.website_url
    $website_page_format = $row.website_page_format
    $website_data_from_when = $row.website_data_from_when
    $max_lottery_draw_id = [int]::($row.max_lottery_draw_id)
    $max_lottery_draw_date = $row.max_lottery_draw_date
    $path = "F:\Gorilla\etl\$website_name\"

    $sqlConnection = New-Object System.Data.SqlClient.SqlConnection
    $sqlConnection.ConnectionString = "Server=$servername;Database=$databasename;Integrated Security=True;"
    $sqlConnection.Open()


    if (!$max_lottery_draw_id)
      { 
        $wrk_draw_id = 0
        $wrk_date = $website_data_from_when
        $wrk_date_ddMMYYYY = $wrk_date.toString("dd-MM-yyyy")
        $wrk_weekday = GetDayOfWeekString($wrk_date.DayOfWeek.value__)

        if ($ds_frequency.Tables[0].rows.Count -eq 0)
            {
                write-output "ds_frequency is empty"
                Exit
            }

        do
        {
            ##############################################
            # Loop through website's frequency to download
            ############################################## 
            foreach ($row in $ds_frequency.tables[0].rows)
            {
                $frequency_draw_from_date = $row.draw_from_date
                $frequency_weekday = $row.weekday

                #write-host ("wrk_date: $wrk_date")
                #write-output ("wrk_weekday: $wrk_weekday")
                #write-output ("frequency_draw_date: $frequency_draw_from_date")
                #write-output ("frequency_weekday: $frequency_weekday")
                #write-output ("")

                if ($wrk_date -ge $frequency_draw_from_date -And $wrk_weekday -eq $frequency_weekday)
                    {
                    $wrk_draw_id++
                    $download_starts = Get-Date

                    if ($website_name = "euro-millions") {
                        $url = $website_url + $wrk_date_ddMMYYYY
                        $filename= "euro$wrk_draw_id.txt"   
                    } elseif ($website_name = "merseyworld") {
                        $url = $website_url + "Lott" + $wrk_draw_id.ToString("000") + ".html"
                        $filename= "mersey$wrk_draw_id.txt"   
                    }
            
                    write-output ("wrk_draw_id: $wrk_draw_id")
                    write-output ("website_name: $website_name")
                    $scraperesult = scrapwebsite $url $path $filename
                    $download_ends = Get-Date               
                    $insertresult = insertwebsitelog $sqlconnection $wrk_draw_id $wrk_date $website_name $url $path$filename $download_starts $download_ends 1

                    }
            }
            $wrk_date = $wrk_date.AddDays(1)
            $wrk_date_ddMMYYYY = $wrk_date.toString("dd-MM-yyyy")
            $wrk_weekday = GetDayOfWeekString($wrk_date.DayOfWeek.value__)

        } while ($wrk_date -le $today_date)
      }
      else
      { 
        Write-Host "variable is NOT null" 

        write-output $max_lottery_draw_id
        write-output $max_lottery_draw_date
      }

    if ($sqlConnection.State -eq [Data.ConnectionState]::Open) 
    {
        $sqlConnection.Close()
    }
  
}




