# integer
$int_obj = 1919
ConvertTo-RPCXmlObject $int_obj

# double
$double_obj = '<double>6.4</double>'
ConvertTo-RPCXmlObject $double_obj

# string
$string_obj = '<string>www.pstips.net</string>'
ConvertTo-RPCXmlObject $string_obj

# base64
$base64_obj = '<base64>d3d3LnBzdGlwcy5uZXQ=</base64>'
ConvertTo-RPCXmlObject $base64_obj

# bool
$bool_obj1 = $false
ConvertTo-RPCXmlObject $bool_obj1

$bool_obj2 = $true
ConvertTo-RPCXmlObject $bool_obj2

# date time
$date_obj = Get-Date
ConvertTo-RPCXmlObject $date_obj

# struct
$struct_obj = @{
foo=1;
bar=2}
ConvertTo-RPCXmlObject $struct_obj

# array
$array_obj =  @(1404,'Something here',[datetime]::Now)

ConvertTo-RPCXmlObject $array_obj