<?php
function alert($message)
{
    echo "<script>alert('$message');</script>";
}
$mysqlcon = mysqli_connect('localhost', 'root', '2030203pa', 'anforum', $port = 3306);
$query = 'SELECT * from usr;';
echo mysqli_fetch_all(mysqli_query($mysqlcon, $query))[1][1];
//получаю результаты. можно приступать к панели управления
if (isset($_POST['Username']) and $_POST['Username'] != '' and $_POST['Password'] != '') {
    $login = $_POST['Username'];
    $password = $_POST['Password'];
    if (preg_match('/[();*-]/', $login) or preg_match('/[();*-]/', $password))
        alert('Прекратите взламывать!');
    else {
    }
};

?>
<html lang="ru">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Animpaf Studio</title>
    <link rel="stylesheet" href="/style.css">
</head>

<body>
    <div class="header">
        <a class="header_ref" href="/index.html ">Animpaf</a>
    </div>
    <div class="logincanvas">
        <div class="login">
            <form action="" method="POST">
                Логин: <br><input type="text" name="Username" required>
                <br><br> Пароль:<br><input type="password" name="Password" required><br><br>
                <div style="display: flex; justify-content: center;">
                    <input type="submit" name="submit" value="Авторизоваться">
                </div>
            </form>
        </div>
    </div>
</body>
<style>
    body {
        font-family: RubikReg;
        font-size: x-large;
    }

    .logincanvas {
        width: 100%;
        height: 90%;
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .login {
        margin: auto;
        display: flex;
        justify-content: center;
        align-items: center;
        width: 450px;
        height: 300px;
        background-color: whitesmoke;
        border-radius: 10px;
    }
</style>

</html>