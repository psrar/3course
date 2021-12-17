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
        Запрос на поиск: <br><textarea name="content" cols="20" rows="2" required></textarea></input><br>
        <input type="submit" name="submit" value="Найти"></input>
    </form><br>

    <?php
    $mysqlcon = mysqli_connect('localhost', 'root', '2030203pa', 'anforum', $port = 3306);
    if ($_POST['content'] != '') {
        try {
            $query = "select * from post where lower(content) like lower('%" . $_POST['content'] . "%')
        or lower(title) like lower('%" . $_POST['content'] . "%');";
            $res = mysqli_query($mysqlcon, $query);
            echo 'Найденные посты:<br>';
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
        } catch (\Throwable $th) {
            echo $th . '<br><br>';
        }
    }
    echo
    '</body>
</html>';
    ?>