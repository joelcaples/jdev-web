<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: PUT, GET, POST, DELETE");
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");

// // include database and object files
// include_once '../config/core.php';
// include_once '../config/database.php';
// include_once '../objects/product.php';

$pageid=isset($_GET["pageid"]) ? $_GET["pageid"] : "";

//function get(){  

  $ini = parse_ini_file('../app-config.ini');

  $mysqli = new mysqli(
    $ini['db_server'], 
    $ini['db_user'], 
    $ini['db_password'], 
    $ini['db_name']
  );

  $pages = [];
  $query = "SELECT 
              pagestoryarcs.PageStoryArcID, 
              pagestoryarcs.PageID, 
              pagestoryarcs.StoryArcID,
              storyarcs.StoryLineID, 
              storyarcs.StoryArcName, 
              storyarcs.IsUnnamed, 
              storyarcs.LastQuickPickDate, 
              storyarcs.CreationDate, 
              storyarcs.ModificationDate
            FROM pagestoryarcs 
            INNER JOIN storyArcs ON pageStoryArcs.StoryArcID = storyarcs.StoryArcID 
            WHERE pagestoryarcs.PageID=".$pageid; 

  if ($result = $mysqli->query($query)) {

    $i = 0;
    while($row = mysqli_fetch_assoc($result)) {
      $pages[$i]['pageStoryArcId'] = $row['PageStoryArcID'];
      $pages[$i]['pageId'] = $row['PageID'];
      $pages[$i]['storyArcId'] = $row['StoryArcID'];
      $pages[$i]['storyLineId'] = $row['StoryLineID'];
      $pages[$i]['storyArcName'] = $row['StoryArcName'];
      $pages[$i]['isUnnamed'] = $row['IsUnnamed'];
      $pages[$i]['lastQuickPickDate'] = $row['LastQuickPickDate'];
      $pages[$i]['creationDate'] = $row['CreationDate'];
      $pages[$i]['modificationDate'] = $row['ModificationDate'];
      $i++;
    }
      
    $result->close();
    $mysqli->close();

    echo json_encode($pages);
  } else {
    http_response_code(404);
  }
    
//}
?>
