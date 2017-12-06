$targetgroup = Get-ELB2TargetGroup
$targetgroup

Get-ELB2LoadBalancer -LoadBalancerArn $targetgroup.LoadBalancerArn