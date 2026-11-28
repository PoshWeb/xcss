
<#
.SYNOPSIS
    xcss math glyphs
.DESCRIPTION
    xcss glyphs for math
.NOTES
    ### xcss math glyphs

    There are a calculable number of unicode code points for math.

    These glyphs are included in many fonts.
.LINK
    https://xcss.org/glyphs/math
#>
#requires -Module Emoji
param(
# The unicode blocks that contain math glyphs
[string[]]
$MathBlocks = @(
    'mathematical alphanumeric symbols',
    'mathematical operators',
    'miscellaneous mathematical symbols-a',
    'miscellaneous mathematical symbols-b',
    'superscripts and subscripts',
    'supplemental mathematical operators'
),

[Collections.IDictionary]
$MathBlockFriendlyName = [Ordered]@{
    'mathematical alphanumeric symbols' = 'math-alphanumeric'
    'mathematical operators' = 'math-operators'
    'miscellaneous mathematical symbols-a' = 'math-symbols-a'
    'miscellaneous mathematical symbols-b' = 'math-symbols-b'
    'superscripts and subscripts' = 'math-scripts'
    'supplemental mathematical operators' = 'math-operators-2'
}
)

# Make sure we're in the right place
Push-Location $PSScriptRoot

#region Output
if (Test-Path ../show.ps1) {
    ../show.ps1 -BlockName $MathBlocks -Command $MyInvocation.MyCommand -BlockFriendlyName $mathBlockFriendlyName
} else {
    $MathBlocks
}
#endregion Output

Pop-Location