. $profile

$SCRIPT_DIR          = (sh_dirpath $MyInvocation.InvocationName)
$MEASURE_OUTPUT_FILE = (sh_join_path $SCRIPT_DIR "result.txt");

$measures          = @{};
$acc_time          = 0.0;
$runs_count        = 10;
$script_to_measure = $profile;

for($i = 0; $i -lt $runs_count; $i += 1) {
    Write-Progress                      `
        -Activity "Running Measurement"  `
        -Status "$i of $runs_count completed..." `
        -PercentComplete ($i / $runs_count);

    ## Measure it and just save:
    ##   Line Number - Time Taken - Line
    Measure-Script $PROFILE       `
        | tail +7                 `
        | grep -v "00:00.0000000" `
        | grep  "00:"          `
        | tr -s " "               `
        | cut -d " " -f 3-1000    `
        > $MEASURE_OUTPUT_FILE

    $file = (Get-Content "$MEASURE_OUTPUT_FILE");
    foreach ($line in $file) {
        $comps = $line.Split(" ");

        $line_no   = [int]  ($comps[0]);
        $exec_time = [float]($comps[1].Split(":")[1]);
        $statement = $comps[2..$comps.Length];

        if(-not $measures.Contains($line_no)) {
            $entry = [pscustomobject]@{
                cost      = 0;
                exec_time = $exec_time;
                line_no   = $line_no;
                statement = $statement;
            }

            $measures.Add($line_no, $entry);
        } else {
            $measures[$line_no].exec_time += $exec_time;
        }

        $acc_time += $exec_time;
    }
}

foreach($item in $measures.Values) {
    $item.cost = (($item.exec_time / $acc_time) * 100);
}

## Display table...
$measures.Values | Sort-Object -Property "exec_time" -Descending;
echo "Total time: $acc_time";
