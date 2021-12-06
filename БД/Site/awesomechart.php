<?php
$path = './userData/awesomeGame.json';
$json = json_decode(file_get_contents($path), true);
if (gettype($json) == 'NULL') {
    $json = (array)json_decode("{}", true);
}

$myobj = array(
    'Email' => $_POST['Email'],
    'Age' => $_POST["Age"],
    'Genre' => $_POST["Genre"],
    'Features' => array($_POST["Feature"][0], $_POST["Feature"][1], $_POST["Feature"][2]),
    'Message' => $_POST["Message"],
    'Color' => $_POST["Color"],
);

array_push($json, $myobj);

$avgAge = 0;

$features = array(
    "Мультиплеер" => 0,
    "Скорость" => 0,
    "Сюжет" => 0,
    "Соревнования" => 0,
    "Стратегия" => 0,
);
$genres = array(
    "Аркада" => 0,
    "Шутер" => 0,
    "Гонки" => 0,
);
$output = json_encode($json, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
file_put_contents($path, $output);

echo "<style>* {font-family: 'Rubik';}</style>";
echo "Мы вышлем результаты опроса вам на почту: " . $_POST["Email"] . "<br>";
echo "А пока что вы можете посмотреть на промежуточные итоги:<br><br><br>";

foreach ($json as $item) {
    $avgAge += $item['Age'];
    ++$genres[$item["Genre"]];

    foreach ($item['Features'] as $value)
        ++$features[$value];
}

$people = count($json);
echo 'Всего проголосовало:<br>' . $people . '<br><br><br>';

$avgAge /= $people;
echo 'Средний возраст игроков:<br>' . intval($avgAge) . '<br>';

echo '<br><br>Предпочитаемые жанры:<br>';
foreach ($genres as $x => $value)
    echo "$x: $value<br>";

echo '<br><br>Предпочитаемые особенности:<br>';
foreach ($features as $x => $value)
    echo "$x: $value<br>";
