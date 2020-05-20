<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: PUT, GET, POST, DELETE");
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");

// // include database and object files
// include_once '../config/core.php';
// include_once '../config/database.php';
// include_once '../objects/product.php';

$id=isset($_GET["id"]) ? $_GET["id"] : "";

//function get(){  

  $ini = parse_ini_file('../app-config.ini');

  $mysqli = new mysqli(
    $ini['db_server'], 
    $ini['db_user'], 
    $ini['db_password'], 
    $ini['db_name']
  );

  $issues = [];
  $query = "SELECT IssueID, SeriesID, IssueNumber, FilePath FROM issues WHERE SeriesID=".$id; 

  if ($result = $mysqli->query($query)) {

    $i = 0;
    while($row = mysqli_fetch_assoc($result)) {
      $series[$i]['issueId'] = $row['IssueID'];
      $series[$i]['seriesId'] = $row['SeriesID'];
      $series[$i]['issueNumber'] = $row['IssueNumber'];
      $series[$i]['filePath'] = $row['FilePath'];
      $i++;
    }
      
    $result->close();
    $mysqli->close();

    echo json_encode($series);
  } else {
    http_response_code(404);
  }
    
//}
?>
