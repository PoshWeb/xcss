<#
.SYNOPSIS
    xcss fractal shapes
.DESCRIPTION
    xcss fractals
.NOTES
    xcss uses [Turtle](https://psturtle.com/Commands/Get-Turtle) to generate graphics.

    It includes several classic fractals generated using [L-Systems](https://en.wikipedia.org/wiki/L-system).

    Feel free to use any of these fractals.
#>

Push-Location $PSScriptRoot

$shapes = [Ordered]@{}

$outliers = [Ordered]@{
    'boardfractal' = 4        
    'boxfractal' = 4
    'crystalfractal' = 4    
    'kochsnowflake' = 4
    'kochisland' = 4
    'pentaplexity' = 4
    'tilefractal' = 4
    'ringfractal' = 4
    'levycurve' = 12
}

"<style>h3,h4 { text-align: center; } </style>"

@"

xcss uses [Turtle](https://psturtle.com/Commands/Get-Turtle) to generate graphics.

It includes several classic fractals generated using [L-Systems](https://en.wikipedia.org/wiki/L-system).

Feel free to use any of these fractals.

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

"@ | ConvertFrom-Markdown | Select-Object -ExpandProperty Html

$fractalOutput = 
foreach ($fractalName in 'binarytree',
    'boardfractal',
    'boxfractal',     
    'crystalfractal', 
    'hilbertcurve', 
    'kochisland',
    'kochsnowflake',
    'levycurve',
    'moorecurve',
    'pentaplexity', 
    'sierpinskiarrowheadcurve',
    'sierpinskitriangle',
    'ringfractal',
    'terdragoncurve',
    'tilefractal'
) {
    $iterations = $outliers[$fractalName]
    if (-not $iterations) { $iterations = 6 }
    "<h3>$fractalName</h3>"
    foreach ($iteration in 1..$iterations) {
        $id = "$fractalName-$iteration"
        "<h4>$fractalName-$iteration</h4>"
        $shapes[$id] = [ScriptBlock]::Create("turtle id '$id' title '$id' $fractalName 42 $iteration")
        if (Test-Path "./$id.svg") {
            Get-Item "./$id.svg"
        } else {
            & $shapes[$id] | Save-Turtle "./$id.svg"
        }
    }
}



$fractalOutput

Pop-Location

