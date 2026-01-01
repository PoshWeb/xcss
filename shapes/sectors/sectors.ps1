<#
.SYNOPSIS
    xcss sectors
.DESCRIPTION
    xcss sector shapes
.NOTES
    ### xcss sector shapes

    Sectors are segments of a circle.

    xcss tries to include a sweet spot of sectors.    

    This generates commonly used sectors (quadrants, sextants, octants).

    This also generates "anti" sectors, and morphs between them.

    Then it makes a sector for every N between 3 and an "inelegant" cutoff point (15).

    After this point, it will make a sector for any N up to 120

    Please help yourself to any of these graphics.

    To make your own, use [Turtle](https://github.com/PowerShellWeb/Turtle)
#>
param(
    # The throttle limit for background jobs.
    # This should only be used when regenerating from scratch
    [int]$ThrottleLimit = 16,
    
    # The "inelegant" cutoff point.
    # Any number beneath this point will be used to generate shapes
    # even if the N is not evenly divisble by 360.     
    [Alias('UnelegantCutoff')]
    [int]$InelegantCutoff = 15,

    # The minumum N of sectors
    [int]$SectorMin = 3,

    # The maximum N of sectors.
    [int]$SectorMax = 120
)

#region Declare Named Shapes
$shapes = [Ordered]@{    
    quadrants = {
        turtle id quadrants @(
            'CircleArc',42, 90,
            'Rotate', 90 * 4
        )
    }
    
    'quadrants-to-antiquadrants' = {
        $quadrants = @(
            'CircleArc',42, 90,
            'Rotate', 90 * 4
        )   
        turtle id quadrants-to-antiquadrants $quadrants morph @(
            turtle $quadrants
            turtle @(
                'CircleArc',42, -90,
                'Rotate', 90 * 4
            )   
            turtle $quadrants
        )
    }

    antiquadrants = {
        turtle id antiquadrants @(
            'CircleArc',42, -90,
            'Rotate', 90 * 4
        )
    }

    sextants = {
        Turtle id sextants @(
            'CircleArc',42, 60,
            'Rotate', 60 * 6
        )
    }

    'sextants-to-antisextants' = {
        $sextants = @(
            'CircleArc',42, 60,
            'Rotate', 60 * 6
        )   
        turtle id sextants-to-antisextants $sextants morph @(
            turtle $sextants
            turtle @(
                'CircleArc',42, -60,
                'Rotate', 60 * 6
            )   
            turtle $sextants
        )
    }
        
    antisextants = {
        Turtle id antisextants @(
            'CircleArc',42, -60,
            'Rotate', 60 * 6
        )
    }

    octants = {
        Turtle id octants @(
            'CircleArc',42, 45,
            'Rotate', 45 * 8
        )
    }

    'octants-to-antioctants' = {
        $octants = @(
            'CircleArc',42, 45,
            'Rotate', 45 * 8
        )   
        turtle id octants-to-antioctants $octants morph @(
            turtle $octants
            turtle @(
                'CircleArc',42, -45,
                'Rotate', 45 * 8
            )   
            turtle $octants
        )
    }

    antioctants = {
        Turtle id antioctants @(
            'CircleArc',42, -45,
            'Rotate', 45 * 8
        )
    }
}
#endregion Declare Named Shapes

#region Generate Shapes
$denominator = 360
:nextNumber foreach ($n in $SectorMin..$SectorMax) {        
    $angle = $($denominator / $n)

    if ($n -gt $InelegantCutoff -and ([Math]::Floor($angle) -ne $angle)) {
        continue nextNumber
    }
    
    $id = "sector$n"
    $positiveArc =
        [ScriptBlock]::Create("
            turtle id '$id' title '$id' $(if ($n % 2) {
                "rotate $(180 + $angle * .25)"
            }) @('CircleArc',42, $angle, 'Rotate', $angle * $n)
        ")
    $shapes[$id] = $positiveArc 

    $id = "sector-$n"
    $negativeArc = [ScriptBlock]::Create("
        turtle id '$id' title '$id' $(if ($n % 2) {
            "rotate $(180 + $angle * .25)"
        }) @('CircleArc',42, -$angle, 'Rotate', $angle * $n)
    ")        

    $shapes[$id] = $negativeArc

    $id = "sector$n-to-$n"
    $morphArc = [ScriptBlock]::Create("
    turtle id '$id' title '$id' @('CircleArc',42, $($numerator / $n), 'Rotate', $($numerator / $n) * $n) morph @(
        $positiveArc
        $negativeArc
        $positiveArc
    )
    ")        
    
    $shapes[$id] = $morphArc

    $id = "sector-$n-to$n"
    $morphArc = [ScriptBlock]::Create("
    turtle id '$id' title '$id' @('CircleArc',42, -$($numerator / $n), 'Rotate', $($numerator / $n) * $n) morph @(
        $negativeArc
        $positiveArc
        $negativeArc
    )
    ")

    $shapes[$id] = $morphArc

    continue nextNumber
    
}
#endregion Generate Shapes


Push-Location $PSScriptRoot

@"
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