# Loop to check each module path in the configured module paths
ForEach ($ModulePath in ($Env:PSModulePath -split ";")){
	# Check if the module exists in the path, and remove it if it does
	if (Test-Path -Path $ModulePath\PS-NexposeDW) {
		Remove-Item -Path $ModulePath\PS-NexposeDW -Recurse -Force
	}
}