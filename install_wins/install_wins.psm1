# This is the file that is supplied to powershell dsc so it knows what to do

Configuration Setup
{
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    Node localhost
    {
        Script Install
        {
            GetScript = { Get-Service rancher-wins; }            
            TestScript = { if(Get-Service rancher-wins -ErrorAction SilentlyContinue){return $true} else {return $false} }
            SetScript = 
            {
                $ErrorActionPreference = 'Stop';
                function Install-Wins
                {
                    Copy-Item -Path $env:ProgramFiles\WindowsPowerShell\Modules\install_wins\dsc_resources\wins.exe -Destination $env:windir\wins.exe
                    & "$env:windir\wins.exe" srv app run --register
                    Start-Service -Name rancher-wins
                }
                
                Install-Wins;
            }
        }
    }
}