$objects = Get-AppxPackage | Select-Object "PackageFamilyName" 
$array = @()
foreach ($object in $objects)
{

    $array += $object

}


foreach($ray in $array){

    write-host """$($ray.PackageFamilyName)"","

}



