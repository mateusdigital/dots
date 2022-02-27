. $profile

$SCRIPT_DIR = (sh_dirpath $MyInvocation.InvocationName)
$MEASURE_OUTPUT_FILE = (sh_join_path $SCRIPT_DIR "result.txt");

## Measure it and just save:
##   Line Number - Time Taken - Line
Measure-Script $PROFILE
    | tail +7                 `
    | grep -v "00:00.0000000" `
    | grep  "00:00."          `
    | tr -s " "               `
    | cut -d " " -f 3-1000    `
    > $MEASURE_OUTPUT_FILE


$entries       = @();
$total_time    = 0.0;
$slowest_entry = $null;

$file = (Get-Content "$MEASURE_OUTPUT_FILE")
foreach ($line in $file) {
    $comps = $line.Split(" ");

    $line_no   = $comps[0];
    $exec_time = $comps[1].Split(":")[1];
    $statement = $comps[2..$comps.Length]
    $obj = [pscustomobject]@{
        line_no   = [int]$line_no
        exec_time = [float]$exec_time
        statement = $statement;
    }

    $entries += $obj;
}

$total_time = 0;
foreach($entry in $entries) {
    $total_time += $entry.exec_time;
    if($null -eq $slowest_entry -or $entry.exec_time -gt $slowest_entry.exec_time) {
        $slowest_entry = $entry;
    }
}

echo $total_time
echo $slowest_entry
