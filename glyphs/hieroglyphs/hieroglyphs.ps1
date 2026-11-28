
<#
.SYNOPSIS
    xcss hieroglyphs
.DESCRIPTION
    xcss hieroglyphs
.NOTES
    ### xcss hieroglyphs

    Strange as it might be, there are a lot of standard symbols for hieroglyphs.

    Three whole sets of hieroglyphs are included in unicode:

    * [Anatolian Hieroglyphs](https://en.wikipedia.org/wiki/Anatolian_hieroglyphs)
    * [Egyptian Hieroglyphs](https://en.wikipedia.org/wiki/Egyptian_hieroglyphs)
    * [Meroitic Hieroglyphs](https://en.wikipedia.org/wiki/Meroitic_language)
    
    These symbols are rendered by the current font.
.LINK
    https://xcss.org/glyphs/hieroglyphs
#>
#requires -Module Emoji
param(
# The unicode blocks that contain hieroglyphs
[string[]]
$HieroglyphBlocks = @(
    'anatolian hieroglyphs', 
    'egyptian hieroglyphs', 
    'meroitic hieroglyphs'
),

[Collections.IDictionary]
$HieroglyphFriendlyName = [Ordered]@{
    'anatolian hieroglyphs' = 'hieroglyphs-anatolian'
    'egyptian hieroglyphs' = 'hieroglyphs-egyptian' 
    'meroitic hieroglyphs' = 'hieroglyphs-meroitic'
}
)

# Make sure we're in the right place
Push-Location $PSScriptRoot

#region Output
if (Test-Path ../show.ps1) {
    ../show.ps1 -BlockName $HieroglyphBlocks -Command $MyInvocation.MyCommand -BlockFriendlyName $HieroglyphFriendlyName
} else {
    $HieroglyphBlocks
}
#endregion Output

Pop-Location