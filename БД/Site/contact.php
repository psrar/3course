<?php
echo "<style>* {font-family: 'Rubik';}</style>";
echo "Мы приняли вашу заявку, " . $_POST["FName"] . "<br>";

$path = './userData/userFeedback.json';
$json = json_decode(file_get_contents($path), true);
if (gettype($json) == 'NULL') {
    $json = (array)json_decode("{}", true);
}

$myobj = array(
    'IP' => $_SERVER['REMOTE_ADDR'],
    'FirstName' => $_POST["FName"],
    'LastName' => $_POST["LName"],
    'City' => $_POST["City"],
    'Message' => $_POST["Message"]
);

array_push($json, $myobj);

$json = json_encode($json, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);

file_put_contents($path, $json); ?>