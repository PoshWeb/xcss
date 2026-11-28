
<#
.SYNOPSIS
    xcss arrows
.DESCRIPTION
    xcss glyps for arrows
.NOTES
    ### xcss arrow glyphs

    There are an amazing amount of arrows in most fonts.

    These symbols are included in many fonts.  Some will be rendered in color.
.LINK
    https://xcss.org/glyphs/arrows
#>
#requires -Module Emoji
param(
# The unicode blocks that contain arrows
[string[]]
$ArrowBlocks = @(
    'arrows',    
    'miscellaneous symbols and arrows',
    'supplemental arrows-a',
    'supplemental arrows-b',
    'supplemental arrows-c'
),

[Collections.IDictionary]
$ArrowFriendlyName = [Ordered]@{
    'miscellaneous symbols and arrows' = 'arrows-misc'
    'supplemental arrows-a' = 'arrows-a'
    'supplemental arrows-b' = 'arrows-b'
    'supplemental arrows-c' = 'arrows-c'
}
)

# Make sure we're in the right place
Push-Location $PSScriptRoot

#region Output
if (Test-Path ../show.ps1) {
    ../show.ps1 -BlockName $ArrowBlocks -Command $MyInvocation.MyCommand -BlockFriendlyName $ArrowFriendlyName
} else {
    @(
        $ArrowBlocks
    ) | Sort-Object
}
#endregion Output

Pop-Location