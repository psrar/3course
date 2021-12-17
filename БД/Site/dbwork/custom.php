<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>

<body>
    <button onclick="location.href='/dbwork/adminpanel.html'">Назад
    </button><br><br>
    <form action="" , method="POST">
        <textarea type="text" name="query" cols="60"></textarea>
        <input type="submit" name="submit" value="Выполнить запрос"></input>
    </form><br>
</body>

</html>

<?php
$mysqlcon = mysqli_connect('localhost', 'root', '2030203pa', 'anforum', $port = 3306);
if ($_POST['query'] != '') {
    try {
        $res = mysqli_query($mysqlcon, $_POST['query']);
        if (!is_bool($res)) {
            echo 'Результат:<br>';
            echo '<table border=\'1px\'>';
            $colNames = mysqli_fetch_fields($res);
            foreach ($colNames as $var) {
                echo '<th>' . $var->name . '</th>';
            }
            $data = mysqli_fetch_all($res);
            $length = count($colNames);
            $rowCount = mysqli_num_rows($res);
            for ($r = 0; $r < $rowCount; $r++) {
                echo '<tr>';
                for ($i = 0; $i < $length; $i++) {
                    echo
                    '<td>' . $data[$r][$i] . '</td>';
                };
                echo '</tr>';
            }
            echo '</table><br>';
            echo 'Запрос выполнен успешно. Затронуто '. mysqli_affected_rows($mysqlcon).' строк.';
        } else if ($res == false)
            echo 'Запрос не выполнен.';
        else echo 'Запрос выполнен успешно. Затронуто '. mysqli_affected_rows($mysqlcon).' строк.';
    } catch (\Throwable $th) {
        echo $th . '<br><br>';
    }
}
?>