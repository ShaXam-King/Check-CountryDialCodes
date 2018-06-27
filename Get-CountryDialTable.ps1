<#
param(

    [Parameter(Mandatory = $true)]
    [Microsoft.PowerShell.Commands.HtmlWebResponseObject] $WebRequest,
    
    [Parameter(Mandatory = $true)]
    [int] $TableNumber
)

#>
cls
$Savefile = $true
$CountryDialCodes = New-Object System.Data.DataTable
$CountryDialCodes.Columns.Add((New-Object System.Data.DataColumn 'COUNTRY', ([STRING])))
$CountryDialCodes.Columns.Add((New-Object System.Data.DataColumn 'COUNTRYCODE', ([STRING])))
$CountryDialCodes.Columns.Add((New-Object System.Data.DataColumn 'DIALCODE', ([STRING])))

$WebRequest = invoke-webrequest "https://www.countrycode.org/"
$TableNumber = 0

## Extract the tables out of the web request
$tables = @($WebRequest.ParsedHtml.getElementsByTagName("TABLE"))
$table = $tables[$TableNumber]
$titles = @()
$rows = @($table.Rows)
## Go through all of the rows in the table
foreach($row in $rows)
{
    $cells = @($row.Cells)
    
    ## If we've found a table header, remember its titles
    if($cells[0].tagName -eq "TH")
    {
        $titles = @($cells | % { ("" + $_.InnerText).Trim() })
        continue
    }
    

    $DTrow = $CountryDialCodes.NewRow()
    $DTrow.'DIALCODE' = ($cells[1].InnerText).Trim()
    $DTrow.'COUNTRY' = ($cells[0].InnerText).Trim()
    $DTrow.'COUNTRYCODE' = (($cells[2].InnerText).Split('/')[0]).Trim()
    
    $CountryDialCodes.Rows.Add($DTrow)
    ## And finally cast that hashtable to a PSCustomObject
    #[PSCustomObject] $resultObject
} 

if ($Savefile){
$CountryDialCodes | Export-Csv countrydialcodes.csv
}


write-host "All Done"