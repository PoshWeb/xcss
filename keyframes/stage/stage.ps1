<#
.SYNOPSIS
    xcss stage keyframes
.DESCRIPTION
    xcss keyframes to move an element around a stage
.NOTES
    ### stage keyframes

    Here's a small set of keyframes to help you move elements around a virtual stage.
#>
param(
# The distance until you are completely offstage, horizontally.
$StageDistanceX = 200,

# The distance until you are completely offstage, vertically.
$StageDistanceY = 200
)

# Make sure we're in the right place.
Push-Location $PSScriptRoot

#region Include Help
$myName = $MyInvocation.MyCommand.Name -replace '\.ps1$'
$myHelp = Get-Help $MyInvocation.MyCommand.ScriptBlock.File
$title = $myHelp.synopsis
$description = $myHelp.description.text -join [Environment]::NewLine
if ($page -is [Collections.IDictionary]) {
    $page.Title = $title
    $page.Description = $description
}
$myHelp.alertSet.alert.text | 
    ConvertFrom-Markdown | 
    Select-Object -ExpandProperty Html
#endregion Include Help


#region Generate Keyframes

# Collect all keyframes into one dictionary as we go.
$keyframes = [Ordered]@{}

# Loop over any variations
foreach ($stage in 'enter', 'exit') {
    foreach ($direction in 
        'stage-left','stage-right',
        'upstage',
        'upstage-left', 'upstage-right',
        'downstage',
        'downstage-left', 'downstage-right'        
    ) {
        # designate a name for the keyframe        
        $keyframeName = "$stage-$direction"

        # and declare it.
        $keyframe = [Ordered]@{
            $keyframeName = [Ordered]@{
                $(
                    # We can use a dynamic key to flip the animation  
                    if ($stage -eq 'enter') { 'from' }
                    else { 'to' }
                ) = @{
                    # Set the CSS property for the animation
                    'translate' =
                        # by joining together the component parts.
                        @(
                            # We can use a -regex switch to simplify implementation.                            
                            switch -regex ($direction) {
                                'left' { "-${StageDistanceX}vw" }
                                'right' { "${StageDistanceY}vw" }
                                default { 0 }
                            }
                            # this can be especially helpful when iterating over multiple dimensions.
                            switch -regex ($direction) {
                                'up' { "-${StageDistanceX}vh" }
                                'down' { "${StageDistanceY}vh" }
                                default { 0 }
                            }
                        ) -join ' '
                }
                $(
                    # We can use another dynamic key for the other side of the flip
                    if ($stage -eq 'enter') { 'to' }
                    else { 'from' }
                ) = @{
                    # which is often just setting the properties to a default.
                    'translate' = '0 0'
                }
            }
        }
        # Store this keyframe in our dictionary
        $keyframes[$keyframeName] = $keyframe[$keyframeName]
    }
}

#endregion Generate Keyframes


#region Export Keyframes
#Now that we have all of our keyframes calculated, let's make them into CSS and JSON.
$jsonKeyframes = $keyframes | ConvertTo-Json -Depth 5
$jsonKeyframes > "./$myName.json"
$cssKeyframes = $keyframes | Get-CssKeyframe 
$cssKeyframes > "./$myName.css"

foreach ($animationName in $keyframes.Keys) {
    $keyframe = [Ordered]@{$animationName=$keyframes[$animationName]}
    $keyframe | ConvertTo-Json -Depth 5 > "./$animationName.json"
    $keyframe | Get-CssKeyframe > "./$animationName.css"
}
#endregion Export Keyframes

"<style>$cssKeyframes</style>"

if (Test-Path ../../keyframes/show.ps1) {
    ../../keyframes/show.ps1 -KeyframeDefinition $keyframes -SelectType Both
}

#region View Source
"<details id='view-source'>"
"<summary>View Source</summary>"
"<pre><code class='language-powershell'>"
[Web.HttpUtility]::HtmlEncode("$($MyInvocation.MyCommand.ScriptBlock)")
"</code></pre>"
"</details>"
#endregion View Source

# Go back to where we were.
Pop-Location