#requires -Module Emoji
param(
[string[]]
$BrailleBlocks = @('braille patterns'),

[Collections.IDictionary]
$BrailleFriendlyNames = @{'braille patterns'='braille'}
)

# Make sure we're in the right place
Push-Location $PSScriptRoot

#region Output
if (Test-Path ../show.ps1) {
    ../show.ps1 -BlockName $BrailleBlocks -Command $MyInvocation.MyCommand -BlockFriendlyName $BrailleFriendlyNames
} else {
    @(
        $BrailleBlocks
    ) | Sort-Object
}
#endregion Output

Pop-Location