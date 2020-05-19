<?php 
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: PUT, GET, POST, DELETE");
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");


$results = '
{  
    "key":"pair"
}';

echo $results;

// $ini = parse_ini_file('app-config.ini');

// $mysqli = new mysqli(
//     $ini['db_server'], 
//     $ini['db_user'], 
//     $ini['db_password'], 
//     $ini['db_name']
// );

// $query = "SELECT * FROM `series` WHERE 1";
// if ($result = $mysqli->query($query)) {
// printf("<h3>Here</h3>");
//     while ($row = $result->fetch_row()) {
//         printf("%s <br />\n", $row[0]);
//     }
//     $result->close();
// }

// $mysqli->close();

// php phpinfo();

?>
