<#
.SYNOPSIS
    xcss palettes
.DESCRIPTION
    Plenty of Palettes
.NOTES
    Want a palette?  We've got plenty.
#>
param(
[PSObject]
$Palette
)

if ($PSScriptRoot) { Push-Location $PSScriptRoot }

$palettePreviewEllipse = Get-Content ./ellipse.svg -Raw

function colorSquare() {

    $colorOrder = 
        'black', 'brightBlack', 'red', 'brightRed', 
        'green','brightGreen',  'blue', 'brightBlue', 
        'yellow', 'brightYellow', 'purple', 'brightPurple',
        'cyan', 'brightCyan', 'white', 'brightWhite'

    $index = 0
    $rowHeight = 25
    $columnWidth = 25
    
    foreach ($row in 0..3) {
        foreach ($column in 0..3) {
            $color = $colorOrder[$index % $colorOrder.Count]
            "<rect class='$color-fill' x='$($column * 25)%' y='$($row * 25)%' width='$columnWidth%' height='$rowHeight%'>"
                
            "</rect>"

            $index++
        }
    }
}


filter viewPalette {
    $palette = $palettes[$_]
    if (-not $palette) { return }
    "<style>
    
    .demoContainer {
        display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 2.5em; margin: 2.5em;
    }

    h1, h2 { text-align: center }


        
    
    </style>"    
    "<h1>"
    "<a class='palette-link' href='/palettes/$($palette.FileName)'>"
    "<span class='palette-name'>$([Web.HttpUtility]::HtmlEncode($palette.Name))</span>"
    "</a>"
    "</h1>"
    
    "<h2><a href='/palettes'>$($palettes.Count) palettes</a></h2>"    
    
    "<a class='palette-css-link' href='/palettes/$($palette.FileName).css'>css</a>"
    "<div class='demoContainer'>"        
        "<div>"
        $palettePreviewEllipse
        "</div>"
    "</div>"
    "<script type='module'>"
@"

const paletteLink = document.getElementById("palette");


// Palettes 
function updatePaletteLinks() {
    var paletteName = getComputedStyle(paletteLink).getPropertyValue('--name');
    var paletteFileName = getComputedStyle(paletteLink).getPropertyValue('--PaletteFileName');
    console.log(paletteName)
    for (const nameElement of [...document.querySelectorAll('.palette-name')]) {
        nameElement.innerText = paletteName
    }
    for (const linkElement of [...document.querySelectorAll('.palette-css-link')]) {
        linkElement.href = ``/palettes/`${paletteFileName}/`${paletteFileName}.css``
    }
    for (const linkElement of [...document.querySelectorAll('.palette-css-cdn-link')]) {
        linkElement.href = 
            ``https://cdn.jsdelivr.net/gh/PoshWeb/xcss@latest/palettes/`${paletteFileName}/`${paletteFileName}.css``
    }
    for (const linkElement of [...document.querySelectorAll('.palette-link')]) {
        linkElement.href = ``/palettes/`${paletteFileName}/``
    }
}

paletteLink.addEventListener('load', updatePaletteLinks)
const paletteObserver = new MutationObserver(function(mutations) {
    mutations.forEach(function(mutationRecord) {
        console.log('palette changing');        
        console.log(mutationRecord);
        setTimeout(50, updatePaletteLinks())        
    });
});


paletteObserver.observe(paletteLink, { attributes : true, attributeFilter : ['href'] })
"@
    "</script>"    
}

$title = 'xcss palettes'

$allPalettes = Get-Content -Path ./all.json | ConvertFrom-Json

$palettes = [Ordered]@{}
foreach ($property in $allPalettes.psobject.Properties) {
    $palettes[$property.Name] = $property.Value
}

if ($site.Palette) {
    $site.Palette | viewPalette
} else {
    "Konsolas" | viewPalette
}

$layout = if ($site.Layout) {
    $site.Layout
} else {
    Get-Command ../layout.ps1
}

$progress = [Ordered]@{ID = Get-Random}
$progress.Status = "Generating Palette Pages"

$total = $palettes.Count
$counter = 0 
foreach ($paletteName in $palettes.Keys) {    
    $paletteDirectory = Get-Item -Path (
        Join-Path $PSScriptRoot $palettes[$paletteName].FileName 
    )
    $progress.Activity = $paletteName
    $progress.PercentComplete = (++$counter*100)/$total
    Write-Progress @progress
    $paletteHtml = $paletteName | viewPalette
    $paletteLayout = [Ordered]@{} + $(
        if ($layoutParameters) {
            $layoutParameters
        }
    )
    $paletteLayout.title = $paletteName
    $paletteLayout.PaletteName = $palettes[$paletteName].FileName 
    $paletteHtml = $paletteHtml | . $layout @paletteLayout
    foreach ($destination in 'index.html', "$($palettes[$paletteName].FileName).html") {
        $paletteIndex = Join-Path $paletteDirectory.FullName index.html
        $paletteHtml > "$paletteIndex"
    }        
}
 
$progress.Remove('PercentComplete')
$progress.Completed = $true
Write-Progress @progress
if ($PSScriptRoot) { Pop-Location }