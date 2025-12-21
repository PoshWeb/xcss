<#
.SYNOPSIS
    xcss fade keyframes
.DESCRIPTION
    xcss fade keyframes.    
.NOTES
    ### fade keyframes

    Here's a fair number of fades for you.

    There are some standard opacity fades:
    
    * `fade-in`
    * `fade-out`

    As well as fades from and to a color, for example: 
    
    * `fade-to-black` fades the `color`.
    * `fade-to-black-box` fades the `color` and `background-color`.
#>
param()

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

# Classic fades first:
foreach ($direction in 'in', 'out') {
    $keyframeName = "fade", $direction -join '-'
    
    $toOpacity = if ($direction -eq 'in') { 1 } else { 0 }
    $fromOpacity = if ($direction -eq 'in') { 0 } else { 1 }
    
    $keyframe = [Ordered]@{
        $keyframeName=
            [Ordered]@{
                "from"=@{opacity=$fromOpacity}
                "to"=@{opacity=$toOpacity}                
            }
    }
    $keyframes[$keyframeName] = $keyframe[$keyframeName]
}

$ColorOrder = @(
    'foreground', 'background',
        'black', 'red', 'green', 'yellow', 'blue', 'purple', 'cyan', 'white',
            'brightBlack', 'brightRed', 'brightGreen', 'brightYellow', 'brightBlue', 'brightPurple', 'brightCyan', 'brightWhite'
)

foreach ($boxed in '', 'box') {
    foreach ($direction in 'from', 'to') {
        foreach ($color in $ColorOrder) {
            $keyframeName = "fade", $direction, $color, $boxed -ne '' -join '-'
                        
            $fade = [Ordered]@{
                $keyframeName = [Ordered]@{
                    "$direction" = [Ordered]@{"opacity" = 
                        if ($direction -eq 'to') {
                            1
                        } else {
                            0
                        }
                    }
                }
            }
            
            $fade.$keyframeName."$direction".color = "var(--$color)"
            if ($boxed) {
                $fade.$keyframeName."$direction".'background-color' = "var(--$color)"
            }
                        
            $keyframes[$keyframeName] = $fade[$keyframeName]
        }   
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
