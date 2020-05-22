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
      storyarcs.StoryArcID, 
      storyarcs.StoryArcName, 
      storyarcs.IsUnnamed, 
      storyarcs.LastQuickPickDate,
      storylines.StoryLineID,
      storyarcs.LastQuickPickDate,
      storyarcs.CreationDate, 
      storyarcs.ModificationDate
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
    WHERE storyArcs.StoryArcName<>''";

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
	storyarcs.StoryArcID, 
	storyarcs.StoryArcName, 
	storyarcs.IsUnnamed, 
  storylines.StoryLineID,
	storyarcs.LastQuickPickDate,
	storyarcs.CreationDate, 
	storyarcs.ModificationDate
ORDER BY issues.IssueNumber, pages.PageNumber, storyarcs.StoryArcName, storylines.StoryLineName 
LIMIT 200";

// echo $query;

  if ($result = $mysqli->query($query)) {

    $i = 0;
    while($row = mysqli_fetch_assoc($result)) {
      // $pages[$i]['pageStoryArcId'] = $row['PageStoryArcID'];
      // $pages[$i]['pageId'] = $row['PageID'];
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
