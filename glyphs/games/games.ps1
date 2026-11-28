
<#
.SYNOPSIS
    xcss game glyphs
.DESCRIPTION
    xcss glyphs for games
.NOTES
    ### xcss game glyphs

    There are a bunch of standard unicode code points for games.

    Using nothing but glyphs, you could play:

    * Chess
    * Dice
    * Dominos
    * Mahjong
    * Playing Cards
    
    These glyphs are rendered by the current font.
.LINK
    https://xcss.org/glyphs/games
#>
#requires -Module Emoji
param(
# The unicode blocks that contain game symbols
[string[]]
$GamesBlocks = @(
    'chess symbols', 
    'domino tiles', 
    'mahjong tiles', 
    'playing cards'
),

# Additional groups of game glyphs
[Collections.IDictionary]
$GamesGlyphs = [Ordered]@{
    'games-dice' = $(foreach ($n in 1..6) { "die face-$n" })
},

[Collections.IDictionary]
$GameFriendlyName = [Ordered]@{
    'chess symbols' = 'games-chess'
    'domino tiles' = 'games-domino'
    'mahjong tiles' = 'games-mahjong'
    'playing cards' = 'games-cards'
}
)

# Make sure we're in the right place
Push-Location $PSScriptRoot

#region Output
if (Test-Path ../show.ps1) {
    ../show.ps1 -BlockName $GamesBlocks -GlyphGroup $GamesGlyphs -Command $MyInvocation.MyCommand -BlockFriendlyName $GameFriendlyName
} else {
    $GamesBlocks
}
#endregion Output

Pop-Location