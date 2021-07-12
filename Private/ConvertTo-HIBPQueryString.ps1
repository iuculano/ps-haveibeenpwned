function ConvertTo-HIBPQueryString
{
    <#
        .SYNOPSIS
        Helper function to build query strings automatically based off a 
        function's parameter set.

        .PARAMETER PSCmdletVariable
        Specifies a cmdlet's PSCmdlet... variable.


        ConvertTo-HIBPQueryString.ps1
        Alex Iuculano, 2018
    #>

    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCmdlet]$PSCmdletVariable
    )


    $boundParams = $PSCmdletVariable.MyInvocation.BoundParameters
    $query       = [System.Web.HttpUtility]::ParseQueryString("")

    foreach ($param in $boundParams.GetEnumerator())
    {         
        $variable  = (Get-Variable $param.Key)
        $attribute = $variable.Attributes | Where-Object { $_.TypeId.Name -contains "APIQueryStringAttribute" }

        
        if ($attribute)
        {
            if ($attribute.APIParameterName)
            {
                $key = $attribute.APIParameterName
            }

            else
            {
                # If a parameter name isn't specified on the  attribute, make the
                # assumption that the parameter name is a direct match

                # Just need to massage it into camelCase at this point
                $key = $variable.Name.Substring(0, 1).ToLower() + $variable.Name.Substring(1)
            }


            # If you need do any further data bending before passing it along...
            # For instance, transforming a DateTime string into a differnet format
            # that whatever underlying API expects

            # This will differ on whatever API you're working with
            switch ($variable.Value.GetType().Name)
            {
                { @("Boolean", "SwitchParameter") -contains $_ }
                {
                    # Not sure if the query string is actually case sensitive?
                    # This may not be needed, but I guess it's more 'correct'
                    $value = $variable.Value.ToString().ToLower()
                }

                default
                {
                    $value = $variable.Value
                }
            }

            
            # aand done.
            $query[$key] = $value
        }
    }
    
    
    # Return just the query string, don't need the entire URI
    if ($query.Count)
    {
        "?$($query.ToString())"
        return
    }

    else
    {
        # Not sure if this better or worse than nothing?
        return [String]::Empty
    }
}
