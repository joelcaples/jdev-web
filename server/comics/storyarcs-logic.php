<?php
/* 
A domain RESTful web services class
*/
Class StoryArcLogic {

  public function getAll($pageid, $seriesid, $issueid, $storylineid, $storyarcid, $storyArcNameSearchCriteria) {

    $ini = parse_ini_file('../app-config.ini');

    $mysqli = new mysqli(
      $ini['db_server'], 
      $ini['db_user'], 
      $ini['db_password'], 
      $ini['db_name']
    );

    $storyarcs = [];
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
        $storyarcs[$i]['storyArcId'] = $row['StoryArcID'];
        $storyarcs[$i]['storyLineId'] = $row['StoryLineID'];
        $storyarcs[$i]['storyArcName'] = $row['StoryArcName'];
        $storyarcs[$i]['isUnnamed'] = $row['IsUnnamed'];
        $storyarcs[$i]['lastQuickPickDate'] = $row['LastQuickPickDate'];
        $storyarcs[$i]['creationDate'] = $row['CreationDate'];
        $storyarcs[$i]['modificationDate'] = $row['ModificationDate'];
        $i++;
      }
        
      $result->close();
      $mysqli->close();

      return $storyarcs;
    } else {
      http_response_code(404);
    }
  }
}    
?>
