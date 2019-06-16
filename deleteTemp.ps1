$paths = "$env:userprofile\AppData\Local\Temp", "C:\Windows\Temp", "C:\Windows\Prefetch"
foreach($path in $paths){
    write-host $path
    set-location $path
    remove-item * -recurse -force
}
set-location C:
cls