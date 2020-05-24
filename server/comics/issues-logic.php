<?php
/* 
A domain RESTful web services class
*/
Class PagesLogic {

  public function getAll($pageid, $seriesid, $issueid, $storylineid, $storyarcid, $storyLineNameSearchCriteria) {


    $ini = parse_ini_file('../app-config.ini');

    $mysqli = new mysqli(
      $ini['db_server'], 
      $ini['db_user'], 
      $ini['db_password'], 
      $ini['db_name']
    );

    $issues = [];
    $query = "SELECT
                series.SeriesID,
                issues.IssueID, 
                issues.IssueNumber, 
                issues.FilePath
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

    $query = $query." 
    GROUP BY
      series.SeriesID,
      issues.IssueID, 
      issues.IssueNumber, 
      issues.FilePath
    ORDER BY 
      issues.IssueNumber,
      issues.FilePath
      LIMIT 100";

    // echo $query;

    if ($result = $mysqli->query($query)) {

      $i = 0;
      while($row = mysqli_fetch_assoc($result)) {
        $issues[$i]['issueId'] = $row['IssueID'];
        $issues[$i]['seriesId'] = $row['SeriesID'];
        $issues[$i]['issueNumber'] = $row['IssueNumber'];
        $issues[$i]['filePath'] = $row['FilePath'];

        $i++;
      }
        
      $result->close();
      $mysqli->close();

      echo json_encode($issues);
    } else {
      http_response_code(404);
    }
  }    
}
?>


      