<#
.SYNOPSIS
    Shows glyphs
.DESCRIPTION
    Shows a collection of glyphs from a block.
.NOTES
    If the blocks do not yet exist, this will generate them.
#>
param(
    # The names of one or more blocks to render.
    # These must be standard unicode block names.
    [string[]]$BlockName,    

    # The command calling `show`.
    # If this is included, the help from the command will become an article
    [Management.Automation.CommandInfo]
    $Command = $MyInvocation.MyCommand,

    # One or more glyph groups to display.
    # The key should be the name of the group.
    # The values should be a list of glyph names.
    [Collections.IDictionary]
    $GlyphGroup,

    # A dictionary of block friendly names.
    # Each key is an original block name.
    # Each value is the friendly name for the block.
    [Collections.IDictionary]
    $BlockFriendlyName
)

$blocksToRender = @(
    $BlockName
    if ($GlyphGroup.Keys) {
        $GlyphGroup.Keys
    }
) | Sort-Object

if (-not $blocksToRender) { return }
# Declare some filters to show a block
filter showBlock {
    "<style>$blockCssLayer</style>"
    "<details open=''><summary>$block ($($symbolsByBlock[$block].Count))</summary>"
    "<blockquote>"    
        @(foreach ($symbolName in $symbolsByBlock[$block].Keys) {
            "<details><summary class='$symbolName-list'>$symbolName</summary>"
            @(
                "<span class='$symbolName'>$symbolName</span>"
                "<span class='$symbolName-after'>$symbolName-after</span>"
                "<span class='$symbolName-both'>$symbolName-both</span>"
            ) -join '<br/>'
            "</details>"
        })
    "</blockquote>"
    "</details>"
}

# and to convert a block name to a file name
filter blockFileName { "$_".ToLower() -replace '\s','-'}

# We want to collect all symbols in a dictionary

$symbolsByBlock = [Ordered]@{}

$progress= @{id=Get-Random;status='Generating styles'}
$counter = 0
$totalSymbolCount = 0 

$showBlocks = @()



$showBlocks += foreach ($block in $blocksToRender) {
    $blockFileName = $block | blockFileName
        
    $progress.Activity = $blockFileName
    $progress.PercentComplete = ++$counter * 100 / $blocksToRender.Count    
    Write-Progress @progress

    $blockPath = "$blockFileName"

    if ($BlockFriendlyName -and $BlockFriendlyName[$block]) {
        $blockPath = $BlockFriendlyName[$block]
    }
        
    if (
        (Test-Path "./$blockPath.css") -and 
        (Test-Path "./$blockPath.json") -and
        (Test-Path "./$blockPath.csv")
    ) {        
        $blockCssLayer = Get-Content -Path "./$blockPath.css" -Raw
        $symbolsByBlock[$block] = [Ordered]@{}
        foreach ($property in (Get-Content "./$blockPath.json" -Raw | ConvertFrom-Json).psobject.properties) {
            $symbolsByBlock[$block][$property.Name] = $property.Value
            $totalSymbolCount++
        }
        showBlock
        continue
    }
    
    $blockSymbols = 
        if ($GlyphGroup -and $GlyphGroup[$block]) {
            Emoji -Name $GlyphGroup[$block]
        } else {
            Emoji -BlockName $block
        }
                    
    $block = $blockFileName

    $symbolsByBlock[$block] = [Ordered]@{}

    $blockVariables = foreach ($symbol in $blockSymbols) {
        $symbolName = $symbol.Name.ToLower() -replace '\s+', '-'
        $symbolText = $symbol.String            
        $symbolsByBlock[$block][$symbolName] = $symbolText
        "--${symbolName}:'\$($symbol.Hex)';"
    }    

    $blockCss = foreach ($symbol in $blockSymbols) {
        $symbolName = $symbol.Name.ToLower() -replace '\s+', '-'
        $symbolText = $symbol.String
        $symbolsByBlock[$block][$symbolName] = $symbolText
        $variableRef = "var(--$SymbolName)"
        [Environment]::NewLine * 2
        ".${symbolName}::before, .${symbolName}-before::before{ content:$variableRef}"        
        ".${symbolName}-after::after{content:$variableRef}"        
        ".${symbolName}-both::after, .${symbolName}-both::before {content:$variableRef}"        
        ".${symbolName}-list { list-style: $variableRef}"        
        $totalSymbolCount++
    }

    $blockCssLayer = @(
        "@layer $block {"
            ":root {"
                $blockVariables
            "}"
            $blockCss
        "}"
    ) -join [Environment]::NewLine

    $blockSymbols | 
        Select-Object Name, String, Hex |
        Export-Csv "./$blockPath.csv"

    $null = New-Item -ItemType File -Path "./$blockPath.css" -Force -Value $blockCssLayer
    $null = New-Item -ItemType File -Path "./$blockPath.json" -Force -Value "$(
        $symbolsByBlock[$block] | ConvertTo-Json -Depth 5        
    )"
    
    showBlock    
}

#region Style
$css = @'
summary {
    padding: .25rem; font-size: 1.25rem;
}
'@
"<style>$css</style>"
#endregion Style

#region Article
$myName = $Command.Name -replace '\.ps1$'
$myHelp = if ($command.ScriptBlock.File) {
    Get-Help $Command.ScriptBlock.File
} else { $null }

$title = $myHelp.synopsis
$description = $myHelp.description.text -join [Environment]::NewLine

if ($page -isnot [Collections.IDictionary]) {
    $page = [Ordered]@{}
}

$page.Title = $title
$page.Description = $description

"<article>"

if ($myHelp.alertSet.alert.text) {
    $myHelp.alertSet.alert.text | 
        ConvertFrom-Markdown | 
        Select-Object -ExpandProperty Html    
}

"<h3>$totalSymbolCount glyphs in $myName</h3>"

$showBlocks
"</article>"

#endregion Article

$progress.Remove('PercentComplete')
$progress.Completed = $true
Write-Progress @progress
