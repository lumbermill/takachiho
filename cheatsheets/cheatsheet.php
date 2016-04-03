<?php
isset($_REQUEST["src"]) or die("?src=src.txt");

$src = $_REQUEST["src"];
is_file($src) or die("$src not found.");

date_default_timezone_set("Asia/Tokyo");
$timestamp = date("Y.m.d", filemtime($src));

$title = NULL;
$color = "rgb(234,234,234)";
$font_size = "13px";
$lines = file($src);
$data = array("a" => array(), "b" => array(), "c" => array());
$col = "a";
$sec = NULL;
foreach ($lines as $line) {
    if (strpos($line, "#") === 0 || strlen(trim($line)) == 0) {
        continue;
    } else if (strpos($line, "@") === 0) {
        $vs = explode(":", $line);
        if (count($vs) != 2) {
            continue;
        } else if (strpos($vs[0], "@background-color") === 0) {
            $color = trim($vs[1]);
        } else if (strpos($vs[0], "@font-size") === 0) {
            $font_size = trim($vs[1]);
        }
    } else if (is_null($title)) {
        $title = trim($line);
    } else if (strpos($line, "== ") === 0) {
        $r = strpos($line, " ==");
        if ($r) {
            $sec = substr($line, 3, $r - 3);
        } else {
            $sec = substr(trim($line), 3);
        }
        $data[$col][$sec] = array();
    } else if (strpos($line, "--") === 0) {
        if ($col == "a")
            $col = "b";
        else if ($col == "b")
            $col = "c";
        else
            die("too much columns(--).");
    } else {
        //コンテンツ
        $data[$col][$sec][] = trim($line);
    }
}
?><!DOCTYPE html>
<html>
    <head>
        <style>
            body {
                /*  A4 Paper of 100 dpi */
                height: 1169px;
                width: 827px;
                margin: 8px auto 8px auto;
                border: 1px solid #000;


                color: #333;
                font-family: monospace;
                line-height: 1.3em;
            }

            @media print{
                body{
                    margin: auto;
                    border: none;
                }
            }

            header{

            }

            div.column{
                float: left;
                width: 270px;
                margin-right: 6px;
            }

            div.column h2{
                width: 258px;
                margin: 0;
                padding: 6px;
                background-color: <?php echo $color; ?>;
                -webkit-print-color-adjust: exact;
            }

            div.column table{
                width: 100%;
                border-spacing: 0;
                border-collapse: collapse;
                margin-bottom: 20px;
                font-size: <?php echo $font_size; ?>;
            }

            div.column table td{
                padding: 6px;
            }

            div.column table tr:nth-child(even){
                background-color: #ddd;
                -webkit-print-color-adjust: exact;
            }

            div#column_c{
                margin-right: 0;
            }


            footer{
                position: absolute;
                top: 1139px;
                height: 30px;
                width: 827px;
                background-color: <?php echo $color; ?>;
                -webkit-print-color-adjust: exact;
                text-align: center;
                line-height: 30px;

            }

            /* mm に 3.937 を掛けて px に変換します */
        </style>
    <head>
    <body>
        <header>
            <h1><?php echo $title; ?></h1>

        </header>
        <?php
        foreach ($data as $col => $data_col) {
            echo "<div class='column' id='column_$col'>";
            foreach ($data_col as $sec_title => $data_sec) {
                echo "<h2>$sec_title</h2>";
                echo "<table>";
                foreach ($data_sec as $line) {
                    echo "<tr>";
                    $vs = split("(\t|   +)", trim($line));
                    foreach ($vs as $v) {
                        echo "<td>" . $v . "</td>";
                    }
                    echo "</tr>";
                }
                echo "</table>";
            }
            echo "</div>";
        }
        ?>
        <footer>Available free from <strong>www.lumber-mill.co.jp/notes</strong>, Last modified: <?php echo $timestamp; ?></footer>
    </body>
</html>