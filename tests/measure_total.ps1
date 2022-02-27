. $profile

$script_to_measure       = $profile;
$measure_result_filename = (sh_join_path      `
    (sh_dirpath $MyInvocation.InvocationName) `
    ("result_" + (Get-Date -UFormat "%F_%H-%M-%S") + ".txt")
);

$measures   = @{};
$acc_time   = 0.0;
$runs_count = 20;


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
        > $measure_result_filename

    $file = (Get-Content "$measure_result_filename");
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
($measures.Values | Sort-Object -Property "exec_time" -Descending) > $measure_result_filename;
(echo "Total time: $acc_time") >> $measure_result_filename;
