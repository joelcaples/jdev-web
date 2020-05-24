<?php
/* 
A domain Class to demonstrate RESTful web services
*/
Class StoryLineLogic {

  public function getAll($pageid, $seriesid, $issueid, $storyarcid, $storylineid, $storyLineNameSearchCriteria) {

    // $pageid=isset($_GET["pageid"]) ? $_GET["pageid"] : "";
    // $seriesid=isset($_GET["seriesid"]) ? $_GET["seriesid"] : "";
    // $issueid=isset($_GET["issueid"]) ? $_GET["issueid"] : "";
    // $storyarcid=isset($_GET["storyarcid"]) ? $_GET["storyarcid"] : "";
    // $storylineid=isset($_GET["storylineid"]) ? $_GET["storylineid"] : "";
    // $storyLineNameSearchCriteria=isset($_GET["name"]) ? $_GET["name"] : "";
    
    $ini = parse_ini_file('../app-config.ini');
  
    $mysqli = new mysqli(
      $ini['db_server'], 
      $ini['db_user'], 
      $ini['db_password'], 
      $ini['db_name']
    );
  
    $storylines = [];
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
  
    if($storyLineNameSearchCriteria != "") {
      $query = $query." AND storyLines.StoryLineName LIKE %".$storylineid."%"; 
    }
    
    $query = $query." 
    GROUP BY
      storylines.StoryLineID,
      storylines.StoryLineName
    ORDER BY storylines.StoryLineName";
    // LIMIT 200";
  
  // echo $query;
  
    if ($result = $mysqli->query($query)) {
  
      $i = 0;
      while($row = mysqli_fetch_assoc($result)) {
        $storylines[$i]['storyLineId'] = $row['StoryLineID'];
        $storylines[$i]['storyLineName'] = $row['StoryLineName'];
        $i++;
      }
        
      $result->close();
      $mysqli->close();
  
      // echo json_encode($storylines);
      return $storylines;
    } else {
      http_response_code(404);
    }
        


  }

	// private $mobiles = array(
	// 	1 => 'Apple iPhone 6S',  
	// 	2 => 'Samsung Galaxy S6',  
	// 	3 => 'Apple iPhone 6S Plus',  			
	// 	4 => 'LG G4',  			
	// 	5 => 'Samsung Galaxy S6 edge',  
	// 	6 => 'OnePlus 2');
		
	// /*
	// 	you should hookup the DAO here
	// */
	// public function getAllMobile(){
	// 	return $this->mobiles;
	// }
	
	// public function getMobile($id){
		
	// 	$mobile = array($id => ($this->mobiles[$id]) ? $this->mobiles[$id] : $this->mobiles[1]);
	// 	return $mobile;
	// }	
}
?>