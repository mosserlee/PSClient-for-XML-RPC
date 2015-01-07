<#
.Synopsis
   New XML_RPC method string.
.DESCRIPTION
   New XML_RPC method string with RPC method and parameters.
.EXAMPLE
   New-RPCMethod -MethodName 'new.post' -Params @("1",2,'string')
.INPUTS
   Object.
.OUTPUTS
   Xml format string.
#>
function New-RPCMethod
{
    param(
    [string]$MethodName,
    [Array]$Params
    )
    $xmlMethod = "<?xml version='1.0' encoding='ISO-8859-1' ?>
      <methodCall>
      <methodName>{0}</methodName>
      <params>{1}</params>
     </methodCall>"

     [string]$paramsValue=""
     foreach($param in $Params)
     {
        $paramsValue += '<param>{0}</param>' -f (ConvertTo-RPCXmlObject -Object $param)
     }
     return ([xml]($xmlMethod -f $MethodName,$paramsValue)).OuterXml
}


<#
.Synopsis
   Invoke XML_RPC method request.
.DESCRIPTION
   Invoke XML_RPC request to RPC server.
.EXAMPLE
   $blogUrl = 'http://www.pstips.net/myrpc.php'
   $method = New-RPCMethod -MethodName 'wp.getPostTypes' -Params @(1,'userName','password')
.OUTPUTS
   The response result from RPC server.
#>
function Invoke-RPCMethod
{
    param(
    [uri]$RpcServerUri,
    [string]$RequestBody
    )
    $xmlResponse = Invoke-RestMethod -Uri $RpcServerUri -Method Post -Body $RequestBody
    if($xmlResponse)
    {
        # Normal response
        $paramNodes =  $xmlResponse.SelectNodes('methodResponse/params/param/value')
        if($paramNodes)
        {
            $paramNodes | foreach {
              $value = $_.ChildNodes |
               Where-Object { $_.NodeType -eq 'Element' } |
               Select-Object -First 1
              ConvertFrom-RPCXmlObject -XmlObject  $value
            }
        }

        # Fault response
        $faultNode =  $xmlResponse.SelectSingleNode('methodResponse/fault')
        if ($faultNode)
        {
            $fault = ConvertFrom-RPCXmlObject -XmlObject $faultNode.value.struct
            return $fault
        }
    }
}


<#
.Synopsis
   Convert object to XML-RPC object string.
.DESCRIPTION
   Convert object to XML-RPC object string.
.EXAMPLE
   ConvertTo-RPCXmlObject 3
   <int>3</int>

   ConvertTo-RPCXmlObject '3'
   <string>3</string>

   ConvertTo-RPCXmlObject 3.5
   <double>3.5</double>
.OUTPUTS
   The XML-RPC object string.
#>
function ConvertTo-RPCXmlObject
{
    param(
    $Object
    )
    if($Object -ne $null)
    {
        # integer type
        if( ($Object -is [int]) -or ($Object -is [int64]))
        {
            return "<int>$Object</int>"
        }
        # double type
        elseif( ($Object -is [float]) -or ($Object -is [double]) -or ($Object -is [decimal]))
        {
            return "<double>$Object</double>"
        }
        # string type
        elseif( $Object -is [string])
        {
            return "<string>$Object</string>"
        }
        # date/time type
        elseif($Object -is [datetime])
        {
            $dateStr = $Object.ToString('yyyyMMddTHH:mm:ss')
            return "<dateTime.iso8601>$dateStr</dateTime.iso8601>"
        }
        # boolean type
        elseif($Object -is [bool])
        {
            $bool = [int]$Object
            return "<boolean>$bool</boolean>"
        }
        # base64 type
        elseif( ($Object -is [array]) -and ($Object.GetType().GetElementType() -eq [byte]))
        {
            $base64Str = [Convert]::ToBase64String($Object)
            return "<base64>$base64Str</base64>"
        }
        # array type
        elseif( $Object -is [array])
        {
            $result = '<array>
            <data>'
            foreach($element in $Object)
            {
                $value = ConvertTo-RPCXmlObject -Object $element
                $result +=  "<value>{0}</value>" -f $value
            }
            $result += '</data>
            </array>'
            return $result
        }
        # struct type
        elseif($Object -is [Hashtable])
        {
            $result = '<struct>'
            foreach ($key in $Object.Keys)
            {
                $member = "<member>
                <name>{0}</name>
                <value>{1}</value>
                </member>"
                $member = $member -f $key, (ConvertTo-RPCXmlObject -Object $Object[$key])
                $result = $result + $member
            }
            $result = $result + '</struct>'
            return $result
        }
        elseif($Object -is [PSCustomObject])
        {
            $result = '<struct>'
            $Object | 
            Get-Member -MemberType NoteProperty | 
            ForEach-Object{
                $member = "<member>
                <name>{0}</name>
                <value>{1}</value>
                </member>"
                $member = $member -f $_.Name, (ConvertTo-RPCXmlObject -Object $Object.($_.Name))
                $result = $result + $member
            }
            $result = $result + '</struct>'
            return $result
        }
        else{
            throw "[$Object] type is not supported."
        }
    }
}


<#
.Synopsis
   Convert to object from XML-RPC object string.
.DESCRIPTION
   Convert to object from XML-RPC object string.
.EXAMPLE
   $s1= '<i4>1919</i4>'
   ConvertFrom-RPCXmlObject -XmlObject $s1
.OUTPUTS
   The XML-RPC object string.
#>
function ConvertFrom-RPCXmlObject
{
 param($XmlObject)
 if($XmlObject -is [string])
 {
    $XmlObject= ([xml]$XmlObject).DocumentElement
 }
 elseif( $XmlObject -is [xml] ){
    $XmlObject = $XmlObject.DocumentElement
 }
 elseif( $XmlObject -isnot [Xml.XmlElement])
 {
    throw 'Only types [string](xml format), [xml], [System.Xml.XmlElement] are supported'
 }
  
 $node = $XmlObject
 if($node)
 {
    $typeName = $node.Name
    switch($typeName)
    {
     # Bool
     ('boolean') { 
        if($node.InnerText -eq '1'){ 
            return $true
        } 
        return $false 
     }

     # Number
     ('i4') {[int64]::Parse($node.InnerText) }
     ('int') {[int64]::Parse($node.InnerText) }
     ('double'){ [double]::Parse($node.InnerText) }
     
     # String
     ('string'){ $node.InnerText }

     # Base64
     ('base64') {
      [Text.UTF8Encoding]::UTF8.GetBytes($node.InnerText)
     }

     # Date Time
     ('dateTime.iso8601'){
      $format = 'yyyyMMddTHH:mm:ss'
      $formatProvider = [Globalization.CultureInfo]::InvariantCulture
      [datetime]::ParseExact($node.InnerText, $format, $formatProvider) 
      }

      # Array
      ('array'){
        $node.SelectNodes('data/value') | foreach{
         ConvertFrom-RPCXmlObject -XmlObject $_.FirstChild
        }
      }

      # Struct
      ('struct'){
       $hashTable = @{}
       $node.SelectNodes('member') | foreach {
        $hashTable.Add($_.name,(ConvertFrom-RPCXmlObject -XmlObject $_.value.FirstChild))
       }
        [PSCustomObject]$hashTable
      }
    }
 }
}
