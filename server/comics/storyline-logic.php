<?php
/* 
A domain RESTful web services class
*/
Class StoryLineLogic {

  public function getAll($pageid, $seriesid, $issueid, $storylineid, $storyarcid, $storyLineNameSearchCriteria) {

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
  
    if ($result = $mysqli->query($query)) {
  
      $i = 0;
      while($row = mysqli_fetch_assoc($result)) {
        $storylines[$i]['storyLineId'] = $row['StoryLineID'];
        $storylines[$i]['storyLineName'] = $row['StoryLineName'];
        $i++;
      }
        
      $result->close();
      $mysqli->close();
  
      return $storylines;
    } else {
      http_response_code(404);
    }        
  }	
}
?>