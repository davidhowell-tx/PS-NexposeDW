function Set-NPDWConfig {
	<#
	.SYNOPSIS
		Used to save configuration options in the current user profile.

    .PARAMETER Server
        Used to save the Server for the Nexpose Data Warehouse    
    
    .PARAMETER Port
        Used to save the port used by the Nexpose Data Warehouse
    
    .PARAMETER Database
        Used to save the name of the database for the Nexpose Data Warehouse
	
	.PARAMETER Credentials
		Used to store an encrypted version of your credentials. Encryption uses the Windows Data Protect API, and can only be decrypted on the same computer by the same username when it was encrypted.
	
	.PARAMETER RemoveConfig
		Used to delete the configuration file currently saved under the user's profile
	#>
    [CmdletBinding()]
    Param(
		[Parameter(Mandatory=$False,ParameterSetName="SetConfig")]
		[String]
        $Server,
        
        [Parameter(Mandatory=$False,ParameterSetName="SetConfig")]
		[String]
        $Port,
        
        [Parameter(Mandatory=$False,ParameterSetName="SetConfig")]
		[String]
		$Database,

		[Parameter(Mandatory=$False,ParameterSetName="SetConfig")]
		[System.Management.Automation.PSCredential]
		[System.Management.Automation.Credential()]
		$Credentials,
		
		[Parameter(Mandatory=$True,ParameterSetName="RemoveConfig")]
		[Switch]
		$RemoveConfig
    )
    if ($PSCmdlet.ParameterSetName -eq "SetConfig") {
        Write-Verbose -Message "Checking for configuration file."

        if (Test-Path -Path $NexposeDWConfigPath) {
			Write-Verbose -Message "Configuration file found, importing to make changes."
			$Configuration = Get-Content -Path $NexposeDWConfigPath | ConvertFrom-Json
		} else {
            Write-Verbose -Message "Configuration file not found, creating one."
            $Configuration = [PSCustomObject]@{
                PSTypeName = "Nexpose.Configuration"
            }
		}

        if ($Server) {
			if (-not $Configuration.Server) {
                Add-Member -InputObject $Configuration -MemberType NoteProperty -Name Server -Value $Server
			} else {
				$ConfigObject.Server = $Server
			}
        }

        if ($Port) {
			if (-not $Configuration.Port) {
                Add-Member -InputObject $Configuration -MemberType NoteProperty -Name Port -Value $Port
			} else {
				$ConfigObject.Port = $Port
			}
        }

        if ($Database) {
			if (-not $Configuration.Database) {
                Add-Member -InputObject $Configuration -MemberType NoteProperty -Name Database -Value $Database
			} else {
				$ConfigObject.Database = $Database
			}
        }

        if ($Credentials) {
			if (-not $Configuration.Username) {
                Add-Member -InputObject $Configuration -MemberType NoteProperty -Name Username -Value $Credentials.UserName
			} else {
				$Configuration.Username = $Credentials.UserName
			}

			if (-not $Configuration.Password) {
                Add-Member -InputObject $Configuration -MemberType NoteProperty -Name Password -Value (ConvertFrom-SecureString -SecureString $Credentials.Password)
			} else {
				$Configuration.Password = "$(ConvertFrom-SecureString -SecureString $Credentials.Password)"
			}
        }
        
        Try {
            Write-Verbose -Message "Saving configuration to $NexposeDWConfigPath"
            $Configuration | ConvertTo-Json | Out-File -FilePath $NexposeDWConfigPath
		} Catch {
			Write-Error -Message "Error received when attempting to save configuration to $NexposeDWConfigPath"
		}
	} elseif ($PSCmdlet.ParameterSetName -eq "RemoveConfig") {
		if (Test-Path -Path $NexposeDWConfigPath) {
			Write-Verbose -Message "Deleting the configuration file from $NexposeDWConfigPath"
			Remove-Item -Path $NexposeDWConfigPath -Force
		}
	}
}