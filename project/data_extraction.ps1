# EUROMILLION RESULTS ETL PROCESS #
#
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