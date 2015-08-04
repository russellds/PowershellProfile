<#
    PowerShell Profile

    2015-08-03
#>

#Aliases

Set-Alias -Name ep -Value edit-profile | out-null

Set-Alias -Name tch -Value Test-ConsoleHost | out-null

Set-Alias -Name gfl -Value Get-ForwardLink | out-null

Set-Alias -Name gwp -Value Get-WebPage | out-null

Set-Alias -Name rifc -Value Replace-InvalidFileCharacters | out-null

Set-Alias -Name gev -Value Get-EnumValues | out-null

#Variables

$docProperties = @{
    Name = 'doc'
    Value = "$home\documents"
    Description = "My documents library. Profile created"
    Option = 'ReadOnly '
    Scope = "Global"
}

New-Variable @docProperties

#PS_Drives

# New-PSDrive -Name Mod -Root ($env:PSModulePath -split ';')[0] `

# -PSProvider FileSystem | out-null

#Functions

function Edit-Profile
{ 
    ISE $profile
}

function Test-ConsoleHost
{

    if( $host.Name -match 'consolehost' )
    {
        $true
    }
    else
    {
        $false
    }  
}

function Replace-InvalidFileCharacters
{
    param ($stringIn,

        $replacementChar)

    # Replace-InvalidFileCharacters "my?string"
    # Replace-InvalidFileCharacters (get-date).tostring()

    $stringIN -replace "[$( [System.IO.Path]::GetInvalidFileNameChars() )]", $replacementChar
}

function Get-TranscriptName
{

    $date = Get-Date -format s

    "{0}.{1}.{2}.txt" -f "PowerShell_Transcript", $env:COMPUTERNAME,
        (rifc -stringIn $date.ToString() -replacementChar "-")
}

function Get-WebPage
{
    param($url)

    # Get-WebPage -url (Get-CmdletFwLink get-process)

    (New-Object -ComObject shell.application).open($url)
}

function Get-ForwardLink
{
    param($cmdletName)

    # Get-WebPage -url (Get-CmdletFwLink get-process)

    (Get-Command $cmdletName).helpuri
}


function Get-EnumValues
{
    # get-enumValues -enum "System.Diagnostics.Eventing.Reader.StandardEventLevel"
    param([string]$enum)

    $enumValues = @{}

    [enum]::getvalues([type]$enum) |
        ForEach-Object { $enumValues.add($_, $_.value__) }

    $enumValues
}

#Commands

Set-Location c:\

if( tch )
{
    Start-Transcript -Path (Join-Path -Path $doc -ChildPath $(Get-TranscriptName))
}