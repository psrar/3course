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

    <?php
    $mysqlcon = mysqli_connect('localhost', 'root', '2030203pa', 'anforum', $port = 3306);
    echo 'Самые активные пользователи:<br>';
    echo '<table border=\'1px\'>';
    $query = 'select count(post.id) as postscount, usr.*
    from usr join post on usr.id = post.author group by usr.id order by postscount desc;';
    $res = mysqli_query($mysqlcon, $query);
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
    echo
    '</body>
</html>';
    ?>