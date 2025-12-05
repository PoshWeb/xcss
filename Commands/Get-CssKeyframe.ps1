function Get-CssKeyframe {
    <#
    .SYNOPSIS
        Gets CSS Keyframes
    .DESCRIPTION
        Creates CSS Keyframes and an associated CSS class from a dictionary
    .EXAMPLE
        [Ordered]@{
            'blur-out' = 
                [Ordered]@{
                    from = [Ordered]@{
                        filter = "blur(0px)"
                    }
                    to = [Ordered]@{
                        filter = "blur(5px)"
                    }
                }
            'blur-in' = 
                [Ordered]@{
                    from = [Ordered]@{
                        filter = "blur(5px)"
                    }
                    to = [Ordered]@{
                        filter = "blur(0px)"
                    }
                }
        } | Get-CSSKeyframe        
    #>
    [Alias('CSSKeyframe','CSS.Keyframe','Keyframes.css')]
    param(
    # Keyframes in nested hashtables or dictionaries up to two layers deep.
    # Each key will become the name of a keyframe and CSS class
    # Each nested key will be the from/to/percentage.
    # Each nested value should be a dictionary of css properties.  
    [Parameter(ValueFromPipeline)]
    [Collections.IDictionary]
    $Keyframe = [Ordered]@{}
    )

    begin {        
        function dictionaryToKeyframes {
            param([Collections.IDictionary]$keyframe)
            process {
                foreach ($keyframeName in $keyframe.Keys) {
                    $keyframeKeyframes = $keyframe[$keyframeName]
                    
                    @(
                        "@keyframes $keyframeName {"
                                foreach ($percent in $keyframeKeyframes.Keys) {
                                    "  $percent {"
                                    $props = $keyframeKeyframes[$percent]
                                    foreach ($prop in $props.Keys) {
                                        $value = $props.$prop
                                        "    ${prop}: $value;"
                                    }
                                    "  }"
                                }
                        "}"
                        [Environment]::NewLine + 
                            ".$keyframeName { animation-name: $keyframeName; }"  +
                                [Environment]::NewLine
                    ) -join [Environment]::NewLine
                    
                }
            }    
        }
    }

    process {
        dictionaryToKeyframes $Keyframe
    }
}