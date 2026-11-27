function Get-CssPalette
{
    <#
    .SYNOPSIS
        Creates a new palette
    .DESCRIPTION        
        Creates a new CSS color palette.

        Each palette contains up to 20 distinct colors
    .NOTES    
        Each palette can define any of the following colors:        

        * `--foreground`
        * `--background`

        We also have some colors for the cursor and selection

        * `--cursorColor`
        * `--selectionBackground`

        We also have the original 8 terminal colors        

        * `--black`
        * `--red`
        * `--green`
        * `--yellow`
        * `--blue`
        * `--purple`
        * `--cyan`
        * `--white`

        And we can define another set of 8 "bright" colors

        * `--brightBlack`
        * `--brightRed`
        * `--brightGreen`
        * `--brightYellow`
        * `--brightBlue`
        * `--brightPurple`
        * `--brightCyan`
        * `--brightWhite`
    .EXAMPLE
        [PSCustomObject]@{
            Foreground = '#dddddd'
            Background = '#111111'
            Black = '#222222'
            Red = '#ff4422'
            Green = '#008100'
            Yellow = '#e68d00'
            Blue = '#4488ff'
            Purple = '#844284'
            Cyan = '#008080'
            White = '#efefef'
            BrightBlack = '#333333'
            BrightRed = '#e50000'
            BrightGreen = '#44ff22'
            BrightYellow = '#e6d600'
            BrightBlue = '#004cff'
            BrightPurple = '#760188'
            BrightCyan = '#42F4F4'
            BrightWhite = '#FFFFFF'
        } | Get-CssPalette
    #>
    [Alias( 'CSS.Palette' , 'Palette.css' , 'xcss.palette' )]
    param(
    # The name of the color scheme.
    [Parameter(ValueFromPipelineByPropertyName)]
    [ComponentModel.DefaultBindingProperty("name")]
    [string]
    $Name,

    # The color for Black (ANSI 0)
    # CSS variable: `--black`
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('ANSI0')]
    [ComponentModel.DefaultBindingProperty("black")]
    [string]
    $Black = '#000420',

    # The color for Red (ANSI 1).
    # CSS variable: `--red`
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('ANSI1')]
    [ComponentModel.DefaultBindingProperty("red")]
    [string]
    $Red = '#ff4422',

    # The color for Green (ANSI 2).
    # CSS variable: `--green`
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('ANSI2')]
    [ComponentModel.DefaultBindingProperty("green")]
    [string]
    $Green = '#008400',
    
    # The color for Yellow (ANSI 3).
    # CSS variable: `--yellow`
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('ANSI3')]
    [ComponentModel.DefaultBindingProperty("yellow")]
    [string]
    $Yellow = '#e68d00',
    
    # The color for Blue (ANSI 4).
    # CSS variable: `--blue`
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('ANSI4')]
    [ComponentModel.DefaultBindingProperty("blue")]
    [string]
    $Blue = '#004cff',

    # The color for Purple/Magneta (ANSI 5).
    # CSS variable: `--purple`
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('ANSI5')]
    [Alias('Magenta')]
    [ComponentModel.DefaultBindingProperty("purple")]
    [string]
    $Purple = '#844284',

    # The color for Cyan (ANSI 6).
    # CSS variable: `--cyan`
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('ANSI6')]
    [ComponentModel.DefaultBindingProperty("cyan")]
    [string]
    $Cyan = '#008080',

    # The color for White (ANSI 7).
    # CSS variable: `--white`
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('ANSI7')]
    [ComponentModel.DefaultBindingProperty("white")]
    [string]
    $White = '#efefef',

    # The color for Bright Black (ANSI 8).
    # CSS variable: `--brightBlack`
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('ANSI8')]
    [ComponentModel.DefaultBindingProperty("brightBlack")]
    [string]
    $BrightBlack = '#808080',

    # The color for Bright Red (ANSI 9).
    # CSS variable: `--brightRed`
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('ANSI9')]
    [ComponentModel.DefaultBindingProperty("brightRed")]
    [string]
    $BrightRed = '#e50000',

    # The color for Bright Green (ANSI 10).
    # CSS variable: `--brightGreen`
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('ANSI10')]
    [ComponentModel.DefaultBindingProperty("brightGreen")]
    [string]
    $BrightGreen = '#00a800',

    # The color for Bright Yellow (ANSI 11).
    # CSS variable: `--brightYellow`
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('ANSI11')]
    [ComponentModel.DefaultBindingProperty("brightYellow")]
    [string]
    $BrightYellow = '#e6d600',

    # The color for Bright Blue (ANSI 12).
    # CSS variable: `--brightBlue`
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('ANSI12')]
    [ComponentModel.DefaultBindingProperty("brightBlue")]
    [string]
    $BrightBlue = '#4488ff',

    # The color for Bright Purple / Magneta (ANSI 13).
    # CSS variable: `--brightPurple`
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('BrightMagenta')]
    [Alias('ANSI13')]
    [ComponentModel.DefaultBindingProperty("brightPurple")]
    [string]
    $BrightPurple = '#760188',

    # The color for Bright Cyan (ANSI 14).
    # CSS variable: `--brightCyan`
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('ANSI14')]
    [ComponentModel.DefaultBindingProperty("brightCyan")]
    [string]
    $BrightCyan = '#42F4F4',

    # The color for Bright White (ANSI 15).
    # CSS variable: `--brightWhite`
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('ANSI15')]
    [ComponentModel.DefaultBindingProperty("brightWhite")]
    [string]
    $BrightWhite = '#FFFFFF',

    # The background color. (Should be the value for Black)
    [Parameter(ValueFromPipelineByPropertyName)]
    [ComponentModel.DefaultBindingProperty("background")]
    [string]
    $Background = '#111111',

    # The foreground color. (Should be the value for White)
    [Parameter(ValueFromPipelineByPropertyName)]
    [ComponentModel.DefaultBindingProperty("foreground")]
    [string]
    $Foreground = '#dddddd',

    # The cursor color.
    [Parameter(ValueFromPipelineByPropertyName)]
    [ComponentModel.DefaultBindingProperty("cursorColor")]
    [string]
    $CursorColor = '#dddddd',

    # The selection background.
    [Parameter(ValueFromPipelineByPropertyName)]
    [ComponentModel.DefaultBindingProperty("selectionBackground")]
    [string]
    $SelectionBackground = '#111111',

    # If provided, will add a --creditTo variable containing the name of the author
    [Parameter(ValueFromPipelineByPropertyName)]
    [psobject]
    $By,

    # If set, will not generate css classes for well-known streams
    [Alias('NoStreams','NoStreamColors')]
    [switch]
    $NoStream,

    # If set, will not generate css classes for each color.
    [Alias('NoColorNames', 'NoNamedColors')]
    [switch]
    $NoColorName,

    # If set, will not generate css classes for each potential fill
    [Alias('NoFills','NoNamedColorFill')]
    [switch]
    $NoFill,

    # If set, will not generate css classes for each potential stroke.
    [Alias('NoStrokes','NoNamedColorStroke')]
    [switch]
    $NoStroke,

    # If set, will not generate css classes for each background-color.
    [Alias('NoBackgrounColors')]
    [switch]
    $NoBackgroundColor,    

    # If set, will not generate css classes that correspond to `$psStyle`.
    [Alias('NoStyles','NoPSStyle','NoPSStyles')]
    [switch]
    $NoStyle,

    # If set, will not include CSS for common page elements
    [Alias('NoElements')]
    [switch]
    $NoElement,

    # If set, will not generate CSS for highlight.js
    [Alias('NoHighlights','NoHighlightJS')]
    [switch]
    $NoHighlight,

    # A collection of highlight styles.
    # The key should be the selector for one or more highlight js classes, and the value should be a series of CSS rules.
    [Collections.IDictionary]
    $HighlightStyle = $([Ordered]@{
        ".hljs" = 'display: block','overflow-x: auto','padding: 0.5em','background: var(--background)','color: var(--foreground)'
        ".hljs-comment, .hljs-quote, .hljs-variable, .hljs-string, .hljs-doctag" = 'color: var(--green);'
        ".hljs-keyword, .hljs-selector-tag, .hljs-built_in, .hljs-name, .hljs-tag" = 'color: var(--cyan);'
        ".hljs-title, .hljs-section, .hljs-attribute, .hljs-literal, .hljs-template-tag, .hljs-template-variable, .hljs-type, .hljs-addition" = 'color: var(--blue);'
        ".hljs-deletion, .hljs-selector-attr, .hljs-selector-pseudo, .hljs-meta" = 'color: var(--red);'
        ".hljs-attr,.hljs-symbol,.hljs-bullet,.hljs-link" = 'color: var(--purple);'        
        ".hljs-emphasis" = 'font-style: italic;'
        ".hljs-strong" = 'font-weight: bold;'
    }),

    # If set, will generate minimal css
    # Implies all other -No* switches
    [switch]
    $Minimal,

    # If set, will only output the CSS variables, and no additional styles
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('OnlyVariable', 'VariableOnly', 'VariablesOnly')]
    [switch]
    $OnlyVariables,

    # The selector the palette should apply to.
    # By default, this is `:root`.
    # If this is any other value than root, `-OnlyVariables` is implied.
    [string]
    $Selector = ':root'
    )

    begin {
        filter GetLuma {
            $colorString = $_
            # Convert the background color to a uint32
            $rgb = ($colorString -replace "#", "0x" -replace ';') -as [UInt32]
            # then make it into a percentage red, green, and blue.
            $r, $g, $b = ([float][byte](($rgb -band 0xff0000) -shr 16)/255),
                ([float][byte](($rgb -band 0x00ff00) -shr 8)/255),
                ([float][byte]($rgb -band 0x0000ff)/255)
        
            # Calculate the luma of the background color
            [Math]::Round(
                0.2126 * $R + 0.7152 * $G + 0.0722 * $B,
                6
            )
        }

        filter ToPaletteFileName {
            $_ -replace '\s','-' -replace '\p{P}','-' -replace '-+','-' -replace '-$'
        }
        
        $myCmd = $MyInvocation.MyCommand
    }

    process {                        
        $jsonObject = [Ordered]@{}
        
        $ColorOrder = @(
            'Black', 'Red', 'Green', 'Yellow', 'Blue', 'Purple', 'Cyan', 'White'
        )

        :nextParameter foreach ($parameterName in $myCmd.Parameters.Keys) {
            $value = $ExecutionContext.SessionState.PSVariable.Get($parameterName).Value
            foreach ($attr in $myCmd.Parameters[$parameterName].Attributes) {
                if ($attr -isnot [ComponentModel.DefaultBindingPropertyAttribute]) {
                    continue
                }
                
                $jsonObject[$attr.Name] = $value
                # (don't forget to turn switches into booleans)
                if ($jsonObject[$attr.Name] -is [switch]) {
                    $jsonObject[$attr.Name] = [bool]$jsonObject[$attr.Name]
                }
                continue nextParameter
            }
        }

        # Walk over each parameter
        :nextParam foreach ($keyValue in $PSBoundParameters.GetEnumerator()) {
            # and walk over each of it's attributes to see if it part of the payload
            foreach ($attr in $myCmd.Parameters[$keyValue.Key].Attributes) {
                # If the parameter is bound to part of the payload
                if ($attr -is [ComponentModel.DefaultBindingPropertyAttribute]) {
                    # copy it into our payload dicitionary.
                    $jsonObject[$attr.Name] = $keyValue.Value
                    # (don't forget to turn switches into booleans)
                    if ($jsonObject[$attr.Name] -is [switch]) {
                        $jsonObject[$attr.Name] = [bool]$jsonObject[$attr.Name]
                    }
                    continue nextParam
                }
            }
        }

        $jsonObject['luma'] = $Background | GetLuma
        $jsonObject['contrast'] = [Math]::Abs(($foreground | GetLuma) - $jsonObject['Luma'])
        $jsonObject['paletteName'] = $Name
        $jsonObject['paletteFileName'] = "$($name | ToPaletteFileName)"        
        $jsonObject = [PSCustomObject]$jsonObject
        
        # and determine if it is bright or dark.
        $IsBright = $luma -ge .4

        if ($Selector -ne ':root') {
            $OnlyVariables = $true
        }

        if ($Minimal -or $OnlyVariables) {
            $NoStream = $true
            $NoColorName = $true
            $NoFill = $true
            $NoElement = $true
            $NoStroke = $true
            $NoBackgroundColor = $true
            $NoStyle = $true
            $NoHighlight = $true
        }
        
        # Generate a CSS class name for the color palette
        # replacing space and leading digits with an underscore.
        $className  = $Name -replace '\s' -replace '^\d', '_$0'

        # Generate the CSS content
        $cssContent = @(
@"
$selector {
  $(
@(
    foreach ($prop in $jsonObject.psobject.properties) {                
        if ($prop.Name -in 'Name', 'FileName','PaletteName','PaletteFileName') {
            if ($prop.Value -notmatch '^#' -and $prop.Value) {
                "--$($prop.Name): $($prop.Value)"
            }
            
        } elseif ("$($prop.Value)") {
            "--$($prop.Name): $($prop.Value)"
        }    
    }
    "--isBright: $($IsBright -as [int])"
    "--isDark: $((-not $IsBright) -as [int])"
    if ($By.UserName) {"--by: $($by.userName)"}
) -join (';' + [Environment]::NewLine + '  '))  
}
"@

# Foreground and background colors
if (-not $OnlyVariables) {
@"
.foreground, .Foreground { color: var(--foreground); }
.background, .Background { background-color: var(--background); }

.foreground-border , .Foreground-Border   { border-color: var(--foreground)  }
.foreground-fill   , .Foreground-Fill     { fill: var(--foreground)          }
.foreground-stroke , .Foreground-Stroke   { stroke: var(--foreground)        }

.background-border , .Background-Border  { border-color: var(--background)   }
.background-fill   , .Background-Fill    { fill: var(--background)           }
.background-stroke , .Background-Stroke  { stroke: var(--background)         }
"@

}

# Colors for well-known "Streams" of data.
if (-not $NoStream) {
@"
.output   , .Output      { color: var(--foreground)   }
.success  , .Success     { color: var(--brightGreen)  }
.failure  , .Failure     { color: var(--red)          }
.error    , .Error       { color: var(--brightRed)    }
.warning  , .Warning     { color: var(--brightYellow) }
.debug    , .Debug       { color: var(--yellow)       }
.verbose  , .Verbose     { color: var(--brightCyan)   }
.progress , .Progress    { color: var(--cyan)         }
.link     , .Link        { color: var(--cyan)         }

.error-border      , .Error-Border       { border-color: var(--brightRed)    }
.error-fill        , .Error-Fill         { fill: var(--brightRed)            }
.error-stroke      , .Error-Stroke       { stroke: var(--brightRed)          }

.success-border    , .Success-Border     { border-color: var(--brightGreen)  }
.success-fill      , .Sucesss-Fill       { fill: var(--brightGreen)          } 
.sucesss-stroke    , .Success-Stroke     { stroke: var(--brightGreen)        }

.warning-border    , .Warning-Border     { border-color: var(--brightYellow) }
.warning-fill      , .Warning-Fill       { fill: var(--brightYellow)         }
.warning-stroke    , .Warning-Stroke     { stroke: var(--brightYellow)       }
"@
}

if (-not $NoColorName) {
@"

/* named colors */
.black   ,  .Black   , .ANSI0, .ANSI30  { color: var(--black)  }
.red     ,  .Red     , .ANSI1, .ANSI31  { color: var(--red)    }
.green   ,  .Green   , .ANSI2, .ANSI32  { color: var(--green)  }
.yellow  ,  .Yellow  , .ANSI3, .ANSI33  { color: var(--yellow) }
.blue    ,  .Blue    , .ANSI4, .ANSI34  { color: var(--blue)   }
.magenta ,  .Magenta , .ANSI5, .ANSI35  { color: var(--purple) }
.cyan    ,  .Cyan    , .ANSI6, .ANSI36  { color: var(--cyan)   }
.white   ,  .White   , .ANSI7, .ANSI37  { color: var(--white)  }

.brightblack   ,  .bright-black   , .BrightBlack   , .ANSI8, .ANSI100   { color: var(--brightBlack)  }
.brightred     ,  .bright-red     , .BrightRed     , .ANSI9, .ANSI101   { color: var(--brightRed)    }
.brightgreen   ,  .bright-green   , .BrightGreen   , .ANSI10, .ANSI102  { color: var(--brightGreen)  }
.brightyellow  ,  .bright-yellow  , .BrightYellow  , .ANSI11, .ANSI103  { color: var(--brightYellow) }
.brightblue    ,  .bright-blue    , .BrightBlue    , .ANSI12, .ANSI104  { color: var(--brightBlue)   }
.brightmagenta ,  .bright-magenta , .BrightMagenta , .ANSI13, .ANSI105  { color: var(--brightPurple) }
.brightcyan    ,  .bright-cyan    , .BrightCyan    , .ANSI14, .ANSI106  { color: var(--brightCyan)   }
.brightwhite   ,  .bright-white   , .BrightWhite   , .ANSI15, .ANSI107  { color: var(--brightWhite)  }

.purple       ,  .Purple  { color: var(--purple) }

.brightpurple ,  .bright-purple , .BrightPurple  { color: var(--brightPurple) }
"@
}

if (-not $NoBackgroundColor) {
@"
/* background colors */
.black-background, .BlackBackground, .ANSI0-Background, .ansi0-background { background-color: var(--black)  }
.red-background, .RedBackground, .ANSI1-Background, .ansi1-background { background-color: var(--red)  }
.green-background, .GreenBackground, .ANSI2-Background, .ansi2-background { background-color: var(--green)  }
.yellow-background, .YellowBackground, .ANSI3-Background, .ansi3-background { background-color: var(--yellow)  }
.blue-background, .BlueBackground, .ANSI4-Background, .ansi4-background { background-color: var(--blue)  }
.magenta-background, .MagentaBackground, .purple-background, .PurpleBackground, .ANSI5-Background, .ansi5-background { background-color: var(--purple)  }
.cyan-background, .CyanBackground, .ANSI6-Background, .ansi6-background { background-color: var(--cyan)  }
.white-background, .WhiteBackground, .ANSI7-Background, .ansi7-background { background-color: var(--white)  }
.brightblack-background, .bright-black-background, .BrightBlackBackground, .ANSI8-Background, .ansi8-background { background-color: var(--brightBlack)  }
.brightred-background, .bright-red-background, .BrightRedBackground, .ANSI9-Background, .ansi9-background { background-color: var(--brightRed)  }
.brightgreen-background, .bright-green-background, .BrightGreenBackground, .ANSI10-Background, .ansi10-background { background-color: var(--brightGreen)  }
.brightyellow-background, .bright-yellow-background, .BrightYellowBackground, .ANSI11-Background, .ansi11-background { background-color: var(--brightYellow)  }
.brightblue-background, .bright-blue-background, .BrightBlueBackground, .ANSI12-Background, .ansi12-background { background-color: var(--brightBlue)  }
.brightmagenta-background, .bright-magenta-background, .BrightMagentaBackground, .ANSI13-Background, .ansi13-background { background-color: var(--brightPurple)  }
.brightcyan-background, .bright-cyan-background, .BrightCyanBackground, .ANSI14-Background, .ansi14-background { background-color: var(--brightCyan)  }
.brightwhite-background, .bright-white-background, .BrightWhiteBackground, .ANSI15-Background, .ansi15-background { background-color: var(--brightWhite)  }
"@
}

if (-not $NoFill) {
@"
/* fills */
.black-fill   ,  .BlackFill   , .ANSI0-Fill,   .ansi0-fill   { fill: var(--black)  }
.red-fill   ,  .RedFill   , .ANSI1-Fill,   .ansi1-fill   { fill: var(--red)  }
.green-fill   ,  .GreenFill   , .ANSI2-Fill,   .ansi2-fill   { fill: var(--green)  }
.yellow-fill   ,  .YellowFill   , .ANSI3-Fill,   .ansi3-fill   { fill: var(--yellow)  }
.blue-fill   ,  .BlueFill   , .ANSI4-Fill,   .ansi4-fill   { fill: var(--blue)  }
.magenta-fill   ,  .MagentaFill   , .ANSI5-Fill,   .ansi5-fill   { fill: var(--purple)  }
.purple-fill, .PurpleFill     { fill: var(--purple) }
.cyan-fill   ,  .CyanFill   , .ANSI6-Fill,   .ansi6-fill   { fill: var(--cyan)  }
.white-fill   ,  .WhiteFill   , .ANSI7-Fill,   .ansi7-fill   { fill: var(--white)  }
.brightblack-fill   ,  .bright-black-fill   , .BrightBlackFill   , .ANSI8-Fill, .ansi8-fill   { fill: var(--brightBlack)         }
.brightred-fill   ,  .bright-red-fill   , .BrightRedFill   , .ANSI9-Fill, .ansi9-fill   { fill: var(--brightRed)                 }
.brightgreen-fill   ,  .bright-green-fill   , .BrightGreenFill   , .ANSI10-Fill, .ansi10-fill   { fill: var(--brightGreen)       }
.brightyellow-fill   ,  .bright-yellow-fill   , .BrightYellowFill   , .ANSI11-Fill, .ansi11-fill   { fill: var(--brightYellow)   }
.brightblue-fill   ,  .bright-blue-fill   , .BrightBlueFill   , .ANSI12-Fill, .ansi12-fill   { fill: var(--brightBlue)           }
.brightmagneta-fill   ,  .bright-magneta-fill   , .BrightMagnetaFill   , .ANSI13-Fill, .ansi13-fill   { fill: var(--brightPurple) }
.brightpurple-fill      , .bright-purple-fill, .BrightPurpleFill { fill: var(--brightPurple)                                      }
.brightcyan-fill   ,  .bright-cyan-fill   , .BrightCyanFill   , .ANSI14-Fill, .ansi14-fill   { fill: var(--brightCyan)           }
.brightwhite-fill   ,  .bright-white-fill   , .BrightWhiteFill   , .ANSI15-Fill, .ansi15-fill   { fill: var(--brightWhite)       }
"@
}

if (-not $NoStroke) {
@"
/* strokes */
.black-stroke ,  .BlackStroke , .ANSI0-Stroke, .ansi0-stroke { stroke: var(--black)  }
.red-stroke ,  .RedStroke , .ANSI1-Stroke, .ansi1-stroke { stroke: var(--red)  }
.green-stroke ,  .GreenStroke , .ANSI2-Stroke, .ansi2-stroke { stroke: var(--green)  }
.yellow-stroke ,  .YellowStroke , .ANSI3-Stroke, .ansi3-stroke { stroke: var(--yellow)  }
.blue-stroke ,  .BlueStroke , .ANSI4-Stroke, .ansi4-stroke { stroke: var(--blue)  }
.magenta-stroke ,  .MagentaStroke , .ANSI5-Stroke, .ansi5-stroke { stroke: var(--purple)  }
.purple-stroke, .PurpleStroke { stroke: var(--purple) }
.cyan-stroke ,  .CyanStroke , .ANSI6-Stroke, .ansi6-stroke { stroke: var(--cyan)  }
.white-stroke ,  .WhiteStroke , .ANSI7-Stroke, .ansi7-stroke { stroke: var(--white)  }
.brightblack-stroke ,  .bright-black-stroke , .BrightBlackStroke   , .ANSI8-Stroke, .ansi8-stroke   { stroke: var(--brightBlack)  }
.brightred-stroke ,  .bright-red-stroke , .BrightRedStroke   , .ANSI9-stroke, .ansi9-stroke   { stroke: var(--brightRed)  }
.brightgreen-stroke ,  .bright-green-stroke , .BrightGreenStroke   , .ANSI10-Stroke, .ansi10-stroke   { stroke: var(--brightGreen)     }
.brightyellow-stroke ,  .bright-yellow-stroke , .BrightYellowStroke, .ANSI11-Stroke, .ansi11-stroke   { stroke: var(--brightYellow) }
.brightblue-stroke ,  .bright-blue-stroke , .BrightBlueStroke   , .ANSI12-Stroke, .ansi12-stroke   { stroke: var(--brightBlue)  }
.brightmagneta-stroke ,  .bright-magneta-stroke , .BrightMagnetaStroke   , .ANSI13-Stroke, .ansi13-stroke   { stroke: var(--brightPurple)  }
.brightpurple-stroke    , .bright-purple-stroke, .BrightPurpleStroke { stroke: var(--brightPurple)  }
.brightcyan-stroke ,  .bright-cyan-stroke , .BrightCyanStroke   , .ANSI14-Stroke, .ansi14-stroke   { stroke: var(--brightCyan)  }
.brightwhite-stroke ,  .bright-white-stroke , .BrightWhiteStroke   , .ANSI15-Stroke, .ansi15-stroke   { stroke: var(--brightWhite)     }
"@
}

if (-not $NoStyle) {
@"
/* psStyles */
.dim, .Dim { opacity: .5; }
.hidden, .Hidden { opacity: 0; }
b, bold, .bold, .Bold { font-weight: bold; }
.boldOff, .BoldOff { font-weight: normal; }
i, italic, .italic, .Italic { font-style: italic; }
.italicOff, .ItalicOff { font-style: normal; }
u, underline, .underline, .Underline { text-decoration: underline; }
.underlineOff, .UnderlineOff { text-decoration: none; }
s, strike, .strike, .Strike, .strikethrough, .Strikethrough { text-decoration: line-through; }
.strikeOff, .StrikeOff, .strikethroughOff, .StrikethroughOff { text-decoration: none; }
"@

foreach ($subproperty in 'Formatting', 'Progress') {
    :nextStyleProperty foreach ($styleProperty in $PSStyle.$subproperty.psobject.properties) {
        if ($styleProperty.Value -notmatch '\e') { continue }
        $null = $styleProperty.Value -match '\e\[(?<n>[\d;]+)m'
        $styleBytes = $matches.n -split ';' -as [byte[]]
        $cssProperties = @(
            switch ($styleBytes) {
                1 { 'font-weight: bold' }
                3 { 'font-style: italic' }
                4 { 'text-decoration: underline' }
                9 { 'text-decoration: line-through' }
                22 { 'font-weight: normal' }
                23 { 'font-style: normal' }
                24 { 'text-decoration: none' }
                default {
                    if ($_ -in 30..37) {
                        $colorName = $ColorOrder[$_ - 30]
                        if (-not $colorName) {
                            Write-Warning "Could not translate `$psStyle.$($subproperty).$($styleProperty.Name) to a color."
                            continue nextStyleProperty
                        }
                        $colorName = $colorName.Substring(0, 1).ToLower() + $colorName.Substring(1)
                        "color: var(--$colorName)"
                    } elseif ($_ -in 40..47) {
                        $colorName = $ColorOrder[$_ - 40]
                        if (-not $colorName) {
                            Write-Warning "Could not translate `$psStyle.$($subproperty).$($styleProperty.Name) to a color."
                            continue nextStyleProperty
                        }
                        $colorName = $colorName.Substring(0, 1).ToLower() + $colorName.Substring(1)
                        "background-color: var(--$colorName)"
                    } elseif ($_ -eq 38) {                
                        "color: var(--foreground)"
                    } elseif ($_ -eq 48) {                
                        "background-color: var(--background)"
                    }
                    elseif ($_ -in 90..97) {
                        $colorName = "bright$($ColorOrder[$_ - 90])"
                        if (-not $colorName) {
                            Write-Warning "Could not translate `$psStyle.$($subproperty).$($styleProperty.Name) to a color."
                            continue nextStyleProperty
                        }
                        "color: var(--$colorName)"
                    } elseif ($_ -in 100..107) {
                        $colorName = "bright$($ColorOrder[$_ - 100])"
                        if (-not $colorName) {
                            Write-Warning "Could not translate `$psStyle.$($subproperty).$($styleProperty.Name) to a color."
                            continue nextStyleProperty
                        }
                        "background-color: var(--$colorName)"
                    }
                }
            }
        )

        $className = ".$subproperty-$($styleProperty.Name)"
        "$className { $($cssProperties -ne '' -join ';') }"
    }
}
}

if ((-not $NoHighlight) -and $HighlightStyle.Count) {
"/* highlight.js styles */"
foreach ($keyValuePair in $HighlightStyle) {
    foreach ($key in $HighlightStyle.Keys) {
        $cssProperties = $HighlightStyle[$key]
        $cssProperties = if ($cssProperties -is [Collections.IDictionary]) {
            foreach ($cssKeyValue in $cssProperties.GetEnumerator()) {
                "$($cssKeyValue.Key): $($cssKeyValue.Value)"
            }
        } else {
            $cssProperties
        }
        @("$key {"
        "  $($cssProperties -join (';' + [Environment]::NewLine + ' '))"
        "}") -join [Environment]::NewLine
    }
}
}

if (-not $NoElement) {
@"
body {
    color: var(--foreground);
    background-color: var(--background);
    caret-color: var(--cursorColor);
}

a, a:visited, a:hover  { color: var(--cyan); }

::selection, ::-moz-selection {
    color: var(--cursorColor);
    background-color: var(--selectionBackground);
}
    
form input[type="text"], form input[type="checkbox"], input[type="button"], button, textarea, select, option {
    color: var(--foreground);
    background-color: var(--background);
}

input[type="file"]::file-selector-button {
    color: var(--foreground);
    background-color: var(--background);
}

option {
    color: var(--foreground);
    background: var(--background);
}

form input[type="text"], textarea, select, button {
    border : 1px solid var(--foreground);
    outline: 1px solid var(--foreground);
}

hr {
    color: var(--foreground)
}
"@
}

        ) -join [Environment]::NewLine
        $cssContent
    }
}
