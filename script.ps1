Param(
[Parameter(Mandatory, HelpMessage = "Enter the path of the folder you want to investigate")]
[string]$path
)
write-host "Hello"($env:username) 
$files = Get-ChildItem -Path $path
$files | ForEach-Object {
	$file = Get-Item $path/$_
	if(-not($file-is[System.IO.DirectoryInfo])) {
		(remove-item $file)
	}
	else{
		$ChildFile = Get-ChildItem -Path $file/ | Measure-Object
		if ($childFile.count -eq 0){
			(remove-item $file)
		}
	}
}
$name = "Exports_$((Get-Date).ToString("MM.dd.yy"))"
mkdir -Path $path/ -Name $name.replace(":","_")
