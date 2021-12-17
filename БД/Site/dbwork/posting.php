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
        Номер автора <br><input type="number" name="authorid" value="1" required></input><br>
        Категория <br><input type="text" name="category" required></input><br>
        Заголовок <br><input type="text" name="title" required></input><br>
        Содержание <br><textarea name="content" cols="80" rows="10" required></textarea></input><br>
        <input type="submit" name="submit" value="Запостить"></input>
    </form><br>

    <?php
    $mysqlcon = mysqli_connect('localhost', 'root', '2030203pa', 'anforum', $port = 3306);
    if ($_POST['title'] != '' and $_POST['content'] != '' and $_POST['category'] != '') {
        try {
            mysqli_query($mysqlcon, 'insert into post(author, category, title, content) values(\'' .
                $_POST['authorid'] . '\',\'' . $_POST['category'] . '\',\'' . $_POST['title'] . '\',\'' . $_POST['content'] .
                '\');');
            echo 'Запись опубликована<br><br>';
        } catch (\Throwable $th) {
            echo $th . '<br><br>';
        }
    }
    $table = 'post';
    echo 'Последние посты:<br>';
    echo '<table border=\'1px\'>';
    $query = 'SELECT * from ' . $table . ' order by id desc limit 100;';
    $res = mysqli_query($mysqlcon, $query);
    $colNames = mysqli_fetch_fields(mysqli_query($mysqlcon, $query));
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