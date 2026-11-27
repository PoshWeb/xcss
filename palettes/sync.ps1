<#
.SYNOPSIS
    Synchronizes palettes
.DESCRIPTION
    Synchronizes palettes from iTerm2-Color-Schemes.

    Converts every palette in the iTerm-Color-Schemes repository into a CSS palette and several associated files.    
.EXAMPLE
    ./sync.ps1
.LINK
    https://github.com/mbadolato/iTerm2-Color-Schemes/
#>
[CmdletBinding(SupportsShouldProcess)]
param(
[switch]
$ShouldCommit,

[switch]
$DryRun
)
#requires -Version 7

# Make sure we are in the right place
if ($PSScriptRoot) { Push-Location $PSScriptRoot }

# Make a little function to get our sparse palettes
function SparsePalettes
{    
    param(
    [uri]
    $Repository="https://github.com/mbadolato/iTerm2-Color-Schemes/",
    [string]
    $Path=$(Join-Path "$pwd" "iTerm2-Color-Schemes"),
    [string[]]
    $Pattern=@('windowsterminal/**.json','CREDITS.md')
    )
    
    process {                
        if (Test-Path $path) {
            $null = git pull
            Get-ChildItem -Recurse -File -Path $Path ;return
        }
        $null = git clone --depth 1 --no-checkout --sparse --filter=tree:0 $Repository "$Path"
        Push-Location (Resolve-Path $Path)
        $null = git sparse-checkout set --no-cone @Pattern
        $null = git checkout
        Get-ChildItem -Recurse -File
        Pop-Location
    }
}

# and another to get our palette file names
filter ToPaletteFileName {
    $_ -replace '\s','-' -replace '\p{P}','-' -replace '-+','-' -replace '-$'
}


# Let's synchronize some palettes
$Progress = [Ordered]@{ ID = Get-Random }
$Progress.Activity = "Syncing Palettes"
$Progress.Status = "Getting Sparse Palettes"
$Progress.PercentComplete = 0
Write-Progress @Progress

$paletteSourceFiles = SparsePalettes

$palettes = [Ordered]@{}


$fileNumber = 0 

# Read our json files
foreach ($paletteFile in $paletteSourceFiles ) {
    if ($paletteFile.Extension -ne '.json') { continue }
    $paletteData = (Get-Content -Raw -LiteralPath $paletteFile.FullName) | ConvertFrom-Json        
    $paletteFileName = "$($paletteFile.Name -replace '\.json$' | ToPaletteFileName)"        
    $Progress.Status = "Reading files: $($paletteFile.Name)"
    $Progress.PercentComplete = ++$fileNumber * 100 / $paletteSourceFiles.Length
    Write-Progress @Progress
    if ($paletteData.Name) {
        $paletteData | Add-Member NoteProperty fileName $paletteFileName -Force
        $palettes[$paletteData.Name] = $paletteData
    }
}

#region Give Credit
$creditsFile = $paletteSourceFiles -match 'CREDITS\.md'
$credits = [Ordered]@{}

if ($creditsFile) {
    # Get the credits from the CREDITS.md file in the iTerm2-Color-Schemes repo
    $creditLines = Get-Content -LiteralPath $creditsFile.FullName
    # and declare a small pattern to match markdown links
    $markdownLinkPattern = '\[(?<text>.+?)\]\((?<link>.+?)\)'
    # and a filter to get the credits from the CREDITS.md file
    filter GetCredits {
        $colorSchemeName = $_
        $colorSchemePattern = [Regex]::Escape($colorSchemeName) -replace '\\ ', '\s'    
        foreach ($line in $creditLines) {
            if (-not $line ) { continue }
            if ($line -notmatch $colorSchemePattern) {
                continue
            }
            if ($line -notmatch $markdownLinkPattern) {
                continue
            }        
            [Ordered]@{credit=$Matches.text; link=$Matches.link}
        }
    }
    
    foreach ($paletteName in $palettes.Keys) {
        $creditInfo = @($paletteName | GetCredits)[0]
        if ($creditInfo) {
            $credits[$paletteName] = $creditInfo
        }
    }
    
}

$Progress.Status = "Getting Credits"
$Progress.PercentComplete = 50
Write-Progress @Progress

# Temporary git credits file.  Do not check this in, as it may contain emails.
$gitCredits = [Ordered]@{}
$gitCreditsPath = (Join-Path $PSScriptRoot "GitCredits.clixml")
if (Test-Path $gitCreditsPath) {
    $gitCredits += Import-Clixml $gitCreditsPath
}

# A palette authors CSV.  This should only contain IDs, UserNames, and Names.
$paletteAuthors = [Ordered]@{}
$paletteAuthorsPath = Join-Path $PSScriptRoot "_authors.csv"
if (Test-Path $paletteAuthorsPath) {
    foreach ($paletteAuthor in Import-Csv -Path $paletteAuthorsPath) {
        $paletteAuthors[$paletteAuthor.PaletteName] = $paletteAuthor
    }
}
:gettingCredits foreach ($paletteName in @($credits.keys)) {
    # If we already know the author, we can skip all of this 
    if ($paletteAuthors[$paletteName]) {
        continue
    }
    # Otherwise, collect the credits from the link
    $paletteCredits = @(foreach ($link in $credits[$paletteName].link) {
        if ($link -notmatch 'github\.com/') { continue }
        if ($gitCredits[$link].id) { $gitCredits[$link]
            continue
        }
        $linkUri = $link -as [uri]
        $gitUserName = $linkUri.Segments[1] -replace '/'    
        if (-not $gitUserName) { continue }
        if (-not $global:GitUserNameCache) {
            $global:GitUserNameCache = [Ordered]@{}    
        }
        $gitUserInfo = if ($global:GitUserNameCache[$gitUserName]) {
            $global:GitUserNameCache[$gitUserName]
        } else {
            $global:GitUserNameCache[$gitUserName] = try { Invoke-RestMethod -Uri "https://api.github.com/users/$gitUserName" } catch  {$_ }            
            $global:GitUserNameCache[$gitUserName]
        }
        $gitCredits[$link] = $gitUserInfo
        $gitUserInfo
    })
    if ($paletteCredits) {
        $paletteAuthors[$paletteName] = 
            @(foreach ($paletteCredit in $paletteCredits) {
                [PSCustomObject]@{
                    PaletteName = $paletteName
                    UserName = $paletteCredit.login
                    Id = $paletteCredit.id
                    Name = $paletteCredit.Name
                }
            })        
    } else {
        if ($gitCredits[$link] -match '404') {
            $gitCredits[$link] = 404
        }
    }  
}

$gitCredits | Export-Clixml -Path $gitCreditsPath

$paletteAuthors.GetEnumerator() |
    Foreach-Object {
        [PSCustomObject]@{
            PaletteName = $_.Key
            UserName = $_.Value.UserName
            Id = $_.Value.id
            Name = $_.Value.Name
        }
    } | 
    Export-Csv -Path $paletteAuthorsPath    
#endregion Give Credit

# We should be able to preview or use each palette on the command line.

# To do this, order is fundamentally important.

$AnsiColorOrder = 
    'Black','Red','Green','Yellow','Blue','Purple','Cyan','White',
    'BrightBlack','BrightRed','BrightGreen','BrightYellow','BrightBlue','BrightPurple','BrightCyan','BrightWhite'

# This next magic filter turns a palette into an ANSI escape sequence that should set the palette's 16 colors.
# Hat tip 🎩 to [@jaykul](https://gist.github.com/Jaykul/36d18199d3fb49d259c61cefd243b904) for original implementation.
filter paletteToAnsi {
    $palette = $_    
    $colorList = @(foreach ($color in $AnsiColorOrder) {
        $hexColor = $palette.$color
        $hexString = $hexColor -replace '[#;]' 
        @(for ($hexIndex = 0; $hexIndex -lt 6; $hexIndex+=2) {
            $hexString[$hexIndex..($hexIndex + 1)] -join ''
        }) -join '/'
    })

    $e = [char]27
    $i = 0
    @(
        foreach ($color in $colorList) {
            "$e]4;$i;rgb:$color$e\"
            $i++
        }
        $hexColor = $palette.foreground -replace ';'
        $rgb   = ($hexColor -replace '#', '0x') -as [int]

        $r = [byte](($rgb -band 0xff0000) -shr 16)
        $g = [byte](($rgb -band 0x00ff00) -shr 8)
        $b = [byte]($rgb -band 0x0000ff)
        "$e[38;2;$r;$g;${b}m"
        $hexColor = $palette.background -replace ';'
        $rgb   = ($hexColor -replace '#', '0x') -as [int]

        $r = [byte](($rgb -band 0xff0000) -shr 16)
        $g = [byte](($rgb -band 0x00ff00) -shr 8)
        $b = [byte]($rgb -band 0x0000ff)
        "$e[48;2;$r;$g;${b}m"
    ) -join ''
}

# For our next trick, we want to align all palettes to the longest name
$longestPaletteName = 
    @($palettes.Keys) |
        Measure-Object -Property Length -Maximum |
            Select-Object -ExpandProperty Maximum

# and make a filter to demonstrate a palette.
filter paletteToAnsiDemo {
    $palette = $_
    # This should write the name in the default colors
    @($psstyle.Foreground.FromRgb("0x$($palette.foreground -replace '[#;]')" -as [uint32])
    $psstyle.Background.FromRgb("0x$($palette.background -replace '[#;]')" -as [uint32])
    # and pad it out to the longest name    
    "$($palette.Name)".PadRight($longestPaletteName, ' ')

    # Then, it should make a box with the color as the foreground / background.
    @(foreach ($color in $AnsiColorOrder) {
        $hexColor = $palette.$color
        $hexString = $hexColor -replace '[#;]'
        $psstyle.Foreground.FromRgb("0x$($hexString)" -as [uint32])
        $psstyle.Background.FromRgb("0x$($hexString)" -as [uint32])
        " `u{2588} "
    })
    # and rest the style.
    $psstyle.Reset

    # (by writing it this way, we can preview all the palettes with Get-Content)
    ) -join ''
}

$allAnsiDemos = @()
#region Generate Palettes
$fileNumber = 0
foreach ($paletteName in $palettes.Keys) {    
    $Progress.Status = "Generating CSS Palettes: $paletteName"
    $Progress.PercentComplete = ++$fileNumber * 100 / $palettes.Count

    Write-Progress @Progress
    
    $paletteCredit = [Ordered]@{}

    # Each palette goes in it's own directory
    $paletteDirectory = Join-Path $PSScriptRoot $palettes[$paletteName].FileName
    
    $paletteDirectory = if (-not (Test-Path $paletteDirectory)) {
        New-Item -ItemType Directory -Path $paletteDirectory -Force
    } else {
        Get-Item $paletteDirectory
    }
    
    # If we have palette author information, give credit
    if ($paletteAuthors[$paletteName]) {
        $byUser = $paletteAuthors[$paletteName].UserName
        $paletteCredit.By = $paletteAuthors[$paletteName]
        $palettes[$paletteName] |
            Add-Member NoteProperty by ([Ordered]@{
                username = $byUser
                link = "https://github.com/$byUser"
                name = $paletteAuthors[$paletteName].name
                id = $paletteAuthors[$paletteName].id
            }) -Force
    }
    
    # Generate the whole palette
    $paletteCss = $palettes[$paletteName] | Get-CssPalette @paletteCredit
    # And pick back out the luma
    if ($paletteCss -match '--Luma:\s?(?<luma>[\d\.]+);') {
        $palettes[$paletteName] | 
            Add-Member NoteProperty luma $($matches.luma -as [double]) -Force
    }

    # and contrast
    if ($paletteCss -match '--Contrast:\s?(?<contrast>[\d\.]+);') {
        $palettes[$paletteName] | 
            Add-Member NoteProperty contrast $($matches.contrast -as [double]) -Force
    }
    
    # then predict the file name
    $paletteFileName = $paletteName | ToPaletteFileName
    
    # Export the whole palette
    $paletteCss > (
        Join-Path $paletteDirectory.FullName "$paletteFileName.css"
    )
    
    # Then a minimal palette
    $paletteCssMin = $palettes[$paletteName] | Get-CssPalette @paletteCredit -Minimal
        
    $paletteCssMin > (
        Join-Path $paletteDirectory.FullName "$paletteFileName.minimal.css"
    )
    
    # Then a variables only palette.
    $paletteCssVars = $palettes[$paletteName] | Get-CssPalette @paletteCredit -OnlyVariables
    
    $paletteCssVars > (
        Join-Path $paletteDirectory.FullName "$paletteFileName.variables.css"
    )

    # Then we export the palette as json
    $palettes[$paletteName] | ConvertTo-Json -Depth 5 > (
        Join-Path $paletteDirectory.FullName "$paletteFileName.json"
    )

    # And as an ansi.txt file
    $palettes[$paletteName] | paletteToAnsi > (
        Join-Path $paletteDirectory.FullName "$paletteFileName.ansi.txt"
    )

    # And then as a demo file
    $ansiDemo = "$($palettes[$paletteName] | paletteToAnsiDemo)"
    # (add that to all of the demos)
    $allAnsiDemos += $ansiDemo
    $ansiDemo > (
        Join-Path $paletteDirectory.FullName "$paletteFileName.ansi.demo.txt"
    )

    @(foreach ($property in $palettes[$paletteName].psobject.properties) {
        if ($property.Value -match '#[0-9a-f]{6}') {
            $matches.0
        }
    }) | Select-Object -Unique > (
        Join-Path $paletteDirectory.FullName "$paletteFileName.unique.txt"
    )
}
#endregion Generate Palettes

# Save all of the palettes to a JSON file
$palettes | 
    ConvertTo-Json -Depth 10 |
    Set-Content ./all.json

# Also export each palette to CSV, since they are flat enough for this to be helpful.
@($palettes.Values) | Export-Csv ./all.csv

# And output all of our demos
$allAnsiDemos | Set-Content ./all.demo.txt

# Also output a list.json
@($palettes.Keys) |
    ConvertTo-Json -Depth 3 |
    Set-Content ./list.json

# And a list.txt
@($palettes.Keys) | Set-Content ./list.txt


# Set a line between bright and dark palettes
$brightLine = 0.4

# and group palettes into light and dark
$brightPalettes = [Ordered]@{}
$darkPalettes = [Ordered]@{}
foreach ($paletteName in $palettes.Keys) {
    if ($palettes[$paletteName].Luma -ge $brightLine) {
        $brightPalettes[$paletteName] = $palettes[$paletteName]
    }
    else {
        $darkPalettes[$paletteName] = $palettes[$paletteName]
    }
}

# Then save bright palettes to 
$brightPalettes | 
    ConvertTo-Json -Depth 10 | 
    Set-Content ./bright.json       # * `bright.json`
@($brightPalettes.Values) | 
    Export-Csv ./bright.csv         # * `bright.csv`
@($brightPalettes.Keys) |
    ConvertTo-Json -Depth 3 |
    Set-Content ./brightList.json   # * `brightList.json`
@($brightPalettes.Keys) | 
    Set-Content ./brightList.txt    # * `brightList.txt`

# Then save dark palettes to 
$darkPalettes | 
    ConvertTo-Json -Depth 10 | 
    Set-Content ./dark.json         # * `dark.json`
@($darkPalettes.Values) | 
    Export-Csv ./dark.csv           # * `dark.csv`
@($darkPalettes.Keys) |
    ConvertTo-Json -Depth 3 |
    Set-Content ./darkList.json     # * `darkList.json`
@($darkPalettes.Keys) | 
    Set-Content ./darkList.txt      # * `darkList.txt`

if ($PSScriptRoot) { Pop-Location }
$Progress.Remove('PercentComplete')
$Progress.Completed = $true
Write-Progress @Progress


if ($ShouldCommit) {
    $status = git status 
    $paletteChanges = $status.Modified -match '/palettes'
    $changesByDirectory = $paletteChanges  | Group-Object { $_.Directory.Name }    
    foreach ($directory in $changesByDirectory) {
        $jsonFile = $directory.Group -match '.json$'
        if (-not $jsonFile) { continue }
        $paletteData = Get-Content -Path $jsonFile.FullName -Raw | ConvertFrom-Json
        if (-not $paletteData.foreground) { continue }
        $paletteName = $paletteData.Name
        
        $gitArgs = @(
            'commit'
            '-m'
            "feat: ``$($paletteName)`` palette"            
            if ($paletteData.by.username -and $paletteData.by.id) {
                $paletteAuthor = $paletteData.by
                "--trailer=Co-authored-by=$(
                    if ("$($paletteAuthor.Name)") { $paletteAuthor.Name } else { $paletteAuthor.username }
                ) <$($paletteAuthor.id)+$($paletteAuthor.username)@users.noreply.github.com>"                
            }
        )

        if ($DryRun) {
            $gitArgs
        } elseif ($PSCmdlet.ShouldProcess("$gitArgs")) {
            foreach ($file in $directory.Group) {
                git add $file.FullName
            }
            git @gitArgs
        }
    }
}
