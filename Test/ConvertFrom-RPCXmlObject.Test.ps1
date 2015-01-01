# integer
$s1= '<i4>1919</i4>'
ConvertFrom-RPCXmlObject -XmlObject $s1

$s2= '<int>1989</int>'
ConvertFrom-RPCXmlObject -XmlObject $s2

# double
$s3= '<double>6.4</double>'
ConvertFrom-RPCXmlObject -XmlObject $s3

# string
$s4= '<string>www.pstips.net</string>'
ConvertFrom-RPCXmlObject -XmlObject $s4

# base64
$s5= '<base64>d3d3LnBzdGlwcy5uZXQ=</base64>'
ConvertFrom-RPCXmlObject -XmlObject $s5

# boolean
$s6= '<boolean>1</boolean>'
ConvertFrom-RPCXmlObject -XmlObject $s6

$s7= '<boolean>0</boolean>'
ConvertFrom-RPCXmlObject -XmlObject $s7

# struct
$s8="
<struct>
  <member>
    <name>foo</name>
    <value><i4>1</i4></value>
  </member>
  <member>
    <name>bar</name>
    <value><i4>2</i4></value>
  </member>
</struct>
"
ConvertFrom-RPCXmlObject -XmlObject $s8

# array
$s9 = "
<array>
  <data>
    <value><i4>1404</i4></value>
    <value><string>Something here</string></value>
    <value><i4>1</i4></value>
  </data>
</array>
"
ConvertFrom-RPCXmlObject -XmlObject $s9