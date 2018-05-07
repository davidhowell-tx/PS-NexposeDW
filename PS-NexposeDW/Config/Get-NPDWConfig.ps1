function Get-NPDWConfig {
	<#
	.SYNOPSIS
		Checks for Nexpose Data Warehouse Module Configuration file and returns any saved values
	#>
    [CmdletBinding()]
    Param()
    $Configuration = [PSCustomObject]@{
		PSTypeName = "Nexpose.Configuration"
	}

    Write-Verbose -Message "Checking for configuration file to import settings."
	if (-not (Test-Path -Path $NexposeDWConfigPath)) {
        Write-Error -Message "$NexposeDWConfigPath not found." -ErrorAction Stop
    }
    
    $ConfigObject = Get-Content -Path $NexposeDWConfigPath | ConvertFrom-Json

	if ($ConfigObject.Username -and $ConfigObject.Password) {
        Add-Member -InputObject $Configuration -MemberType NoteProperty -Name Credentials -Value (New-Object System.Management.Automation.PSCredential($ConfigObject.Username, ($ConfigObject.Password | ConvertTo-SecureString)))
	}

	if ($ConfigObject.Server) { 
		Add-Member -InputObject $Configuration -MemberType NoteProperty -Name Server -Value $ConfigObject.Server
    }
    
    if ($ConfigObject.Port) { 
		Add-Member -InputObject $Configuration -MemberType NoteProperty -Name Port -Value $ConfigObject.Port
    }
    
    if ($ConfigObject.Database) { 
		Add-Member -InputObject $Configuration -MemberType NoteProperty -Name Database -Value $ConfigObject.Database
    }

	return $Configuration
}