<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: PUT, GET, POST, DELETE");
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");

$ini = parse_ini_file('../app-config.ini');

$mysqli = new mysqli(
    $ini['db_server'], 
    $ini['db_user'], 
    $ini['db_password'], 
    $ini['db_name']
);

$series = [];
$query = "SELECT SeriesID, SeriesName FROM series WHERE 1";
if ($result = $mysqli->query($query)) {

  $i = 0;
  while($row = mysqli_fetch_assoc($result))
  {
    $series[$i]['seriesID'] = $row['SeriesID'];
    $series[$i]['seriesName'] = $row['SeriesName'];
    $i++;
  }

  $result->close();
  $mysqli->close();

  echo json_encode($series);
} else {
  http_response_code(404);
}

?>