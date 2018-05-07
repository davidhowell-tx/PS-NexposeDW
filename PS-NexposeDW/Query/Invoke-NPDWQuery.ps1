function Invoke-NPDWQuery {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)]
        [String]
        $Query,

        [Parameter(Mandatory=$False)]
        [String]
        $Server,

        [Parameter(Mandatory=$False)]
        [String]
        $Port,

        [Parameter(Mandatory=$False)]
        [String]
        $Database,

        [Parameter(Mandatory=$False)]
        [System.Management.Automation.PSCredential]
        $Credentials
    )
    $Config = Get-NPDWConfig

    if (-not $Server) {
        if (-not $Config.Server) {
            Write-Error -ErrorAction Stop -Message "Server must be specified either directly, or saved in the configuration with Set-NPDWConfig"
        }
        $Server = $Config.Server
    }
    if (-not $Port) {
        if (-not $Config.Server) {
            Write-Error -ErrorAction Stop -Message "Port must be specified either directly, or saved in the configuration with Set-NPDWConfig"
        }
        $Port = $Config.Port
    }
    if (-not $Database) {
        if (-not $Config.Server) {
            Write-Error -ErrorAction Stop -Message "Database name must be specified either directly, or saved in the configuration with Set-NPDWConfig"
        }
        $Database = $Config.Database
    }
    if (-not $Credentials) {
        if (-not $Config.Server) {
            Write-Error -ErrorAction Stop -Message "Credentials must be specified either directly, or saved in the configuration with Set-NPDWConfig"
        }
        $Credentials = $Config.Credentials
    }
    

    $Connection = New-Object System.Data.Odbc.OdbcConnection
    $Connection.ConnectionString = "Driver={PostgreSQL Unicode(x64)};Server=$Server;Port=5432;Database=$DB;Uid=$($Credentials.UserName);Pwd=$($Credentials.GetNetworkCredential().Password);Encrypt=Yes;"
    $Connection.Open()

    $Command = New-Object System.Data.Odbc.OdbcCommand($Query, $Connection)
    $DataSet = New-Object System.Data.DataSet
    (New-Object system.Data.odbc.odbcDataAdapter($Command)).fill($DataSet) | out-null
    $Connection.close()
    $DataSet.Tables[0]
}