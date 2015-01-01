PSClient-for-XML-RPC
====================

Invoke Xml-RPC request by PowerShell client.
A PowerShell module that help to send XML-RPC request.
[Suppoted by http://www.pstips.net/](http://www.pstips.net/rpc-client.html)

Implemented features
--------------------
- Convert PowerShell object to XML-RPC object string.
- Convert XML-RPC object string to PowerShell object.
- Generate a XML-RPC request string with method name and parameters. 
- Send XML-RPC request to RPC server.

Data types map
--------------
| PowerShell Type| XML-RPC Data types|
| ------------- |:-------------:|
| System.Array      |array|
| System.Byte[]      |base64|
| System.Boolean |boolean      |
| System.DateTime |date/time|
| System.Double |double|
| System.Double.Int64 |integer|
| System.String |string|
| System.Collections.Hashtable|struct|

Examples
--------
1.Convert .NET object to RPC XML object
```powershell
# integer
$int_obj = 1919
ConvertTo-RPCXmlObject $int_obj

# double
$double_obj = '<double>6.4</double>'
ConvertTo-RPCXmlObject $double_obj

# string
$string_obj = '<string>www.pstips.net</string>'
ConvertTo-RPCXmlObject $string_obj

```
more to see  [ConvertTo-RPCXmlObject](https://github.com/mosserlee/PSClient-for-XML-RPC/blob/master/Test/ConvertTo-RPCXmlObject.Test.ps1).

2.Convert RPC XML object to .NET object
```powershell
# integer
$s1= '<i4>1919</i4>'
ConvertFrom-RPCXmlObject -XmlObject $s1

$s2= '<int>1989</int>'
ConvertFrom-RPCXmlObject -XmlObject $s2

# double
$s3= '<double>6.4</double>'
ConvertFrom-RPCXmlObject -XmlObject $s3
```
more to see  [ConvertFrom-RPCXmlObject](https://github.com/mosserlee/PSClient-for-XML-RPC/blob/master/Test/ConvertFrom-RPCXmlObject.Test.ps1).

3.New RPCMethod
```powershell
# New RPCMethod
$method = 'wp.getPostTypes'
$params = @(1,'userName','Password')
$body = New-RPCMethod -MethodName $method  -Params $params
```

4.Invoke RPCMethod
```powershell
# Invoke RPCMethod
$blogRpcUrl = 'http://www.pstips.net/my-rpc.php' 
Invoke-RPCMethod -RpcServerUri $blogRpcUrl -RequestBody $body

```