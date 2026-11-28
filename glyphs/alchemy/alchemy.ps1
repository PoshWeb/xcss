<#
.SYNOPSIS
    xcss alchemy
.DESCRIPTION
    xcss alchemy glyphs
.NOTES
    Alchemy may not actually work, but it has been codified into Unicode.

    These symbols are rendered by the current font, if available.
.LINK
    https://xcss.org/glyphs/alchemy
#>
#requires -Module Emoji
param(
# The blocks containing alchemy symbols
[string[]]
$AlchemyBlocks = @('Alchemical Symbols')
)

# Make sure we're in the right place
Push-Location $PSScriptRoot

#region Output
if (Test-Path ../show.ps1) {
    ../show.ps1 -BlockName $AlchemyBlocks -Command $MyInvocation.MyCommand -BlockFriendlyName @{
        'Alchemical Symbols' = 'alchemy'
    }
} else {
    $AlchemyBlocks
}
#endregion Output

Pop-Location