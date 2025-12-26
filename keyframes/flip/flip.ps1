<#
.SYNOPSIS
    xcss flips and backflips
.DESCRIPTION
    xcss flip and backflip keyframes.
.NOTES
    ### flip keyframes

    Here's a few flips for you.

    A flip will rotate 180 degrees along one or more axis.

    A backflip will rotate -180 degrees along one or more axis.    
#>
param()

# Make sure we're in the right place.
Push-Location $PSScriptRoot

#region Include Help Article
$myName = $MyInvocation.MyCommand.Name -replace '\.ps1$'
$myHelp = Get-Help $MyInvocation.MyCommand.ScriptBlock.File
$title = $myHelp.synopsis
$description = $myHelp.description.text -join [Environment]::NewLine
if ($page -is [Collections.IDictionary]) {
    $page.Title = $title
    $page.Description = $description
}
"<article>"
$myHelp.alertSet.alert.text | 
    ConvertFrom-Markdown | 
    Select-Object -ExpandProperty Html
"</article>"
#endregion Include Help Article


#region Generate Keyframes

$keyframes = [Ordered]@{}

foreach ($direction in '', 'back') {
    foreach ($axis in 'x', 'y', 'z', 'xy', 'xyz') {
        $keyframeName = "${direction}flip", $axis -join ''
        $sign = if ($direction -eq 'back') { '-'} else {''}
        $flip = [Ordered]@{
            $keyframeName = [Ordered]@{
                "to" = [Ordered]@{
                    "transform" = @(
                        if ($axis -match 'x') {
                            "rotateX(${sign}180deg)"
                        }
                        if ($axis -match 'y') {
                            "rotateY(${sign}180deg)"
                        }
                        if ($axis -match 'z') {
                            "rotateZ(${sign}180deg)"
                        }
                    )                
                }
            }
        }
                            
        $keyframes[$keyframeName] = $flip[$keyframeName]
    }
}

#endregion Generate Keyframes

#region Export Keyframes
#Now that we have all of our keyframes calculated, let's make them into CSS and JSON.
$jsonKeyframes = $keyframes | ConvertTo-Json -Depth 5
$jsonKeyframes > "./$myName.json"
$cssKeyframes = Get-CssKeyframe -Keyframe $keyframes 
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

Pop-Location
