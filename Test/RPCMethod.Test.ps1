# New RPCMethod
$method = 'wp.getPostTypes'
$params = @(1,'userName','Password')
$body = New-RPCMethod -MethodName $method  -Params $params

# Invoke RPCMethod
$blogRpcUrl = 'http://www.pstips.net/my-rpc.php' 
Invoke-RPCMethod -RpcServerUri $blogRpcUrl -RequestBody $body
