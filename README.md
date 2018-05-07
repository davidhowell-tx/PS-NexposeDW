# PS-NexposeDW
PowerShell Module to make querying the Nexpose Data Warehouse much easier.

# Install/Uninstall
I've provided some simple scripts to aid installing and uninstalling the module so that it is loaded when you start PowerShell.
Just execute Install-Module.ps1 or Uninstall-Module.ps1.  These scripts just add or remove the module to your PSModulePath.

# Saving Data Warehouse Configuration
It's annoying to specify the server name, port, database name, etc. every time you execute a query.  If you wish, you can choose to save this configuration to disk.
NOTE: Passwords are saved in an encrypted standard string by using the ConvertFrom-SecureString commandlet.

Below is an example of saving your configuration. You will be prompted for the credentials so that you don't have to type them in clear text into PowerShell.
```
Set-NPDWConfig -Server "ACMECorpDW.domain.local" -Port 5432 -Database nexpose -Credentials (Get-Credential)
```

View the saved configuration
```
Get-NPDWConfig
```

Remove the saved configuration with the below
```
Set-NPDWConfig -RemoveConfig
```

# Performing a Query against the Data Warehouse
Querying the data warehouse is now as simple as wrapping your query in double quotes (be sure to use single quotes within your query itself. otherwise, the double quotes within your query will need to be escaped with a backtick).

```
$Query = "
SELECT *
FROM dim_site
"
```

You can then call Invoke-NPDWQuery with the query variable
```
Invoke-NPDWQuery -Query $Query
```

If you don't want to save your configuration to disk you can supply the configuration directly
```
Invoke-NPDWQuery -Query $Query -Server "ACMECorpDW.domain.local" -Port 5432 -Database nexpose -Credentials (Get-Credential)
```

Or even save portions of the configuration, and supply others on demand
```
Set-NPDWConfig -Server "ACMECorpDW.domain.local" -Port 5432 -Database nexpose
Invoke-NPDWQuery -Query $Query -Credentials (Get-Credential)
```

# Future for this module?
There is a lot of potential to define specific SQL Queries with this module, and provide them as various built in commandlets.
I haven't yet decided if I'm going to take the module in this direction.

For example, the site listing example of performing `SELECT * FROM dim_site` could be turned into a `Get-NPDWSite` commandlet.
Various joins could then be done and provided through parameters such as `Get-NPDWSite -Name Test` running `SELECT * FROM dim_site WHERE name ='Test'`