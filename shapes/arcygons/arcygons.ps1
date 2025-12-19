<#
.SYNOPSIS
    xcss arcygons
.DESCRIPTION
    xcss arcygons - polygons with arcs attached
#>
param(
[int]
$ThrottleLimit = 12
)
$shapes = [Ordered]@{}


# $shapes = [Ordered]@{}
$numerator = 360
$avoidDuplicateRatios = @{}


$matrix = @(
    foreach ($n in @(3..12)) {
        foreach ($radius in 25, 50, 100, 200) {
            foreach ($length in 25, 50, 100, 200, -200, -100, -50, -25) {
                if ($avoidDuplicateRatios["$n-$($radius/$length)"]) {
                    continue
                }
                $avoidDuplicateRatios["$n-$($radius/$length)"] = $true
                @{radius=$radius;length=$length; n=$n}                
            }
        }        
    }    
)

:nextNumber foreach ($point in $matrix) {    
    $n = $point.n
    $radius = $point.radius
    $length = $point.length
    $angle = $($numerator / $n)
    $optionalRotation = if (($n -gt 4) -and $n % 2) {
        "" # "rotate $($angle * -0.5)"
    } else { "" }
    
    $ratio = $radius/$length
    $id = "arcygon$n-ratio$ratio"
    $positiveArcygon =
        [ScriptBlock]::Create("
            turtle id '$id' title '$id' $(
                $optionalRotation
            ) @('CircleArc',$radius, $angle, 'Forward', $length, 'Rotate', $angle * $n)
        ")
    $shapes[$id] = $positiveArcygon


    $id = "arcygon-$n-ratio$ratio"
    $negativeArcygon =
        [ScriptBlock]::Create("
            turtle id '$id' title '$id' $($optionalRotation) @('CircleArc',$radius, -$angle, 'Forward', $length, 'Rotate', $angle * $n)
        ")
    $shapes[$id] = $negativeArcygon
    
    $id = "arcygon$n-to-$n-ratio$ratio"
    $morphArc = [ScriptBlock]::Create("
    turtle id '$id' title '$id' $(
        $optionalRotation
    ) @('CircleArc',$radius, $($numerator / $n), 'Forward', $length, 'Rotate', $($numerator / $n) * $n) morph @(
        $positiveArcygon
        $negativeArcygon
        $positiveArcygon
    )
    ")        

    $shapes[$id] = $morphArc

    $id = "arcygon-$n-to$n-ratio$ratio"
    $morphArc = [ScriptBlock]::Create("
    turtle id '$id' title '$id' $(
        $optionalRotation
    ) @('CircleArc',$radius, -$($numerator / $n), 'Forward', $length, 'Rotate', $($numerator / $n) * $n) morph @(
        $negativeArcygon    
        $positiveArcygon
        $negativeArcygon            
    )
    ")        

    $shapes[$id] = $morphArc        
}

"<style>
h4, table { text-align: center }
table { margin-left: auto;margin-right: auto; border: 1px }
</style>"

Push-Location $PSScriptRoot

@"
Arcygons are formed by adding a CircleArc to each corner of a polygon.

Please help yourself to any of these graphics.

To make your own, use [Turtle](https://github.com/PowerShellWeb/Turtle)

$(
    $filesHere = @(Get-ChildItem -Filter *.svg)
    $measured = $filesHere | Measure-Object -Average -Property Length -Sum
    @(
        "|File Count|Average Size (kb)|TotalSize(mb)|"
        "|-|-|-|"
        "|$($measured.Count,(
            [Math]::Round($measured.Average/1kb, 2)
        ), (
            [Math]::Round($measured.Sum/1mb, 2)
        ) -join '|')|"
    ) -join [Environment]::NewLine    
)

"@ | ConvertFrom-Markdown | Select-Object -ExpandProperty HTML


$turtleJobs = @()
$progress = @{Status = 'Generating shapes';PercentComplete=0;id=Get-Random}
$counter = 0 
foreach ($key in $shapes.Keys) {
    $counter++
    $progress.PercentComplete = $counter * 100 / $shapes.Count
    $progress.Activity = "$counter / $($shapes.Count)"
    Write-Progress @progress

    if (Test-Path "./$key.svg") {
        "<h4>$key</h4>"
        Get-Item "./$key.svg"
        "<hr/>"
    } else {
        $turtleJobs += Start-ThreadJob -ScriptBlock {
            param([ScriptBlock]$turtleScript, [string]$Key)
            Import-Module Turtle
            & $turtleScript.GetNewClosure() | Save-Turtle "./$key.svg"
        } -ThrottleLimit $ThrottleLimit -ArgumentList $shapes[$key],$key
    }
}

if ($turtleJobs) {
    do {
        $stillRunning = @($turtleJobs | ? State -ne 'Completed')
        $progress.PercentComplete = $($stillRunning).Count / $turtleJobs.Count
        $progress.Activity = "waiting for $($stillRunning.Count) jobs"
        Write-Progress @progress
        Start-sleep -Seconds (Get-Random -Min 1 -Max 3)
    } while ($stillRunning)
}


$turtleJobs | Wait-Job | Receive-Job

$progress.Remove('PercentCompleted')
$progress.Completed = $true
Write-Progress @progress 
Pop-Location
