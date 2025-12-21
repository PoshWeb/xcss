<#
.SYNOPSIS
    xcss glow keyframes
.DESCRIPTION
    xcss keyframes for glowing shadows.
.NOTES
    ### glow keyframes

    Here's a good number of glowkeyframes for you.

    glow keyframes animate the `box-shadow` or `text-shadow` properties.    
#>

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

$keyframes = [Ordered]@{}

$ColorOrder = @(
    'foreground', 'background',
        'black', 'red', 'green', 'yellow', 'blue', 'purple', 'cyan', 'white',
            'brightBlack', 'brightRed', 'brightGreen', 'brightYellow', 'brightBlue', 'brightPurple', 'brightCyan', 'brightWhite'    
)

foreach ($shadowType in 'box', 'text') {
    foreach ($color in $ColorOrder) {
        $keyframeName = "glow-$shadowType-$color"
        
        $keyframe = [Ordered]@{
            $keyframeName = [Ordered]@{
                "0%, 100%" = @{
                    "$shadowType-shadow" = "0 0 0rem var(--$color)"
                }
                "50%" = @{
                    "$shadowType-shadow" = "0 0 0.5rem var(--$color)"
                }                
            }
        }
        
        $keyframes[$keyframeName] = $keyframe[$keyframeName]
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
