function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false)  {
    if ($elevated) {
        # tried to elevate, did not work, aborting
    } else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
    }
    exit
}

'running with full privileges'
Write-output "Warning, this script downloads and runs Tron this will take 3-10 hours depending on your PC. Do not cancel Tron mid scan or you risk the possibility of Bricking your PC! Press enter if you are prepared to not be able to use your pc for a while. (TSW v1,8.3.22)"
Pause
start iexplore
Start-sleep -seconds 10
Stop-Process -Name "iexplore"
$dir = [Environment]::GetFolderPath("Desktop")
New-Item -Itemtype "Directory" -Name "Tron" -Path "$dir"
Invoke-WebRequest -Uri "https://bmrf.org/repos/tron/Tron%20v12.0.2%20(2022-01-18).exe" -OutFile "$dir\Tron\Tron.exe"
If((Get-FileHash $dir\Tron\Tron.exe).Hash -eq "6e08a1e90462ea77e87d27701067c99d7aeca0272e781df455d763c4db73f774"){
Write-Output "Checksum passed!"
}
else{
Write-Output "Checksum Failed! Closing powershell and removing Tron. (Tron is out of date or invalid checksum)"
Remove-Item '$dir\Tron'

}

