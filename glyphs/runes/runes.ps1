
<#
.SYNOPSIS
    xcss runes
.DESCRIPTION
    xcss rune glyphs
.NOTES
    ### xcss runes

    [Runes](https://en.wikipedia.org/wiki/Runes) have standard unicode characters.

    These glyphs are rendered by the current font.
.LINK
    https://xcss.org/glyphs/runes
#>
#requires -Module Emoji
param(
# The unicode blocks that contain runes
[string[]]
$RuneBlocks = @(
    'runic'
),

[Collections.IDictionary]
$RuneFriendlyName = @{
    'runic' = 'runes'
}
)

# Make sure we're in the right place
Push-Location $PSScriptRoot

#region Output
if (Test-Path ../show.ps1) {
    ../show.ps1 -BlockName $RuneBlocks -Command $MyInvocation.MyCommand -BlockFriendlyName $RuneFriendlyName
} else {
    $RuneBlocks
}
#endregion Output

Pop-Location