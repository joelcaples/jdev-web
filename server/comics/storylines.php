
<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: PUT, GET, POST, DELETE");
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");

// // include database and object files
// include_once '../config/core.php';
// include_once '../config/database.php';
// include_once '../objects/product.php';

$pageid=isset($_GET["pageid"]) ? $_GET["pageid"] : "";
$seriesid=isset($_GET["seriesid"]) ? $_GET["seriesid"] : "";
$issueid=isset($_GET["issueid"]) ? $_GET["issueid"] : "";
$storyarcid=isset($_GET["storyarcid"]) ? $_GET["storyarcid"] : "";
$storylineid=isset($_GET["storylineid"]) ? $_GET["storylineid"] : "";

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
      storylines.StoryLineID,
      storylines.StoryLineName
    FROM series 
      INNER JOIN issues 
      INNER JOIN pages 
      INNER JOIN pagestoryarcs 
      INNER JOIN storyArcs 
      INNER JOIN storylines 
      ON storyArcs.StoryLineID = storylines.StoryLineID 
      ON pageStoryArcs.StoryArcID = storyarcs.StoryArcID 
      ON pages.PageId = pageStoryArcs.PageId 
      ON issues.IssueID = pages.IssueID 
      ON series.SeriesID = issues.SeriesID 
    WHERE 1";

  if($pageid != "") {
    $query = $query." AND pagestoryarcs.PageID = ".$pageid; 
  }
          
  if($seriesid != "") {
    $query = $query." AND series.SeriesID = ".$seriesid; 
  }

  if($issueid != "") {
    $query = $query." AND issues.IssueID = ".$issueid;
  }

  if($storyarcid != "") {
    $query = $query." AND storyArcs.StoryArcID = ".$storyarcid; 
  }

  if($storylineid != "") {
    $query = $query." AND storyLines.StoryLineID = ".$storylineid; 
  }

  $query = $query." GROUP BY
  storylines.StoryLineID,
  storylines.StoryLineName
ORDER BY storylines.StoryLineName
LIMIT 200";

// echo $query;

  if ($result = $mysqli->query($query)) {

    $i = 0;
    while($row = mysqli_fetch_assoc($result)) {
      $pages[$i]['storyLineId'] = $row['StoryLineID'];
      $pages[$i]['storyLineName'] = $row['StoryLineName'];
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
