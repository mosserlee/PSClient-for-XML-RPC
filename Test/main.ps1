dir $PSScriptRoot\*.Test.ps1 | foreach {
  Write-Host "############################################################"

  Write-Verbose "Run: $($_.FullName)"
  &  $_.FullName

  Write-Host "############################################################"
}