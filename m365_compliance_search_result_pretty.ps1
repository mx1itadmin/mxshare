Param(
	[string] $CompSearchIdentity
)

if ($CompSearchIdentity) {
	$complianceSearch = Get-ComplianceSearch -Identity $CompSearchIdentity

	if ($complianceSearch) {
		$successResults = $complianceSearch.SuccessResults

		if ($successResults) {
			# Split the string into individual lines
			$lines = $successResults -split "\r\n"

			# Create an array to store the parsed objects
			$resultsTable = @()

			foreach ($line in $lines) {
				# Example parsing for lines like "Location: UserMailbox, Item count: 10, Size: 1MB"
				if ($line -match "Location: (?<Location>.+?), Item count: (?<ItemCount>\d+), Total size: (?<Size>.+)") {
					$resultsTable += [PSCustomObject]@{
						Location = $matches.Location
						ItemCount = [int]$matches.ItemCount
						Size = $matches.Size
					}
				}
				# Add more parsing logic here if your SuccessResults format varies or includes other details
			}

			# Format the parsed objects as a table
			$resultsTable | Format-Table -AutoSize
		} else {
			Write-Host "No SuccessResults found for the compliance search."
		}
	} else {
		Write-Host "Compliance search '$($CompSearchIdentity)' not found."
	}
} else {
	Write-Host "Please use -CompSearchIdentity."	
}
	
