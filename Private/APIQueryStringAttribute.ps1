# Using a native PowerShell class is an obnoxious nightmare to expose internally 
# for reasons beyond earthly logic. So instead, we wind up with this - which seems
# to work with much less friction, somehow.
$source = @"
public class APIQueryStringAttribute : System.Attribute
{
    public string APIParameterName;


    public APIQueryStringAttribute(string apiParameterName)
    {
        this.APIParameterName = apiParameterName;
    }

    public APIQueryStringAttribute()
    {

    }
}
"@

Add-Type -TypeDefinition $source
