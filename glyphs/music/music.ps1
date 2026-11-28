<#
.SYNOPSIS
    xcss music glyphs
.DESCRIPTION
    xcss glyphs for music
.NOTES
    ### xcss music glyphs

    There is some harmonious agreement about how to show music.

    These glyphs are included in many fonts.
.LINK
    https://xcss.org/glyphs/music
#>
#requires -Module Emoji
param(
# The unicode blocks that contain music glyphs
[string[]]
$MusicBlocks = @(
    'musical symbols',
    'ancient greek musical notation',
    'byzantine musical symbols'
),

[Collections.IDictionary]
$MusicBlockFriendlyName = [Ordered]@{
    'musical symbols' = 'music-symbols'
    'ancient greek musical notation' = 'music-greek'
    'byzantine musical symbols' = 'music-byzantine'
}
)

# Make sure we're in the right place
Push-Location $PSScriptRoot

#region Output
if (Test-Path ../show.ps1) {
    ../show.ps1 -BlockName $MusicBlocks -Command $MyInvocation.MyCommand -BlockFriendlyName $MusicBlockFriendlyName
} else {
    $MusicBlocks
}
#endregion Output

Pop-Location