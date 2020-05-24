<?php
/* 
A domain RESTful web services class
*/
Class SearchLogic {

  public function getAll($seriesid, $issueid, $storylineid, $storyarcid) {

    $ini = parse_ini_file('../app-config.ini');

    $mysqli = new mysqli(
      $ini['db_server'], 
      $ini['db_user'], 
      $ini['db_password'], 
      $ini['db_name']
    );

    $results = [];
    $query = "
      SELECT
        series.SeriesID, series.SeriesName,
        storyarcs.StoryArcID, storyarcs.StoryArcName, storyarcs.IsUnnamed, 
        storyarcs.LastQuickPickDate, 
        storylines.StoryLineID,storylines.StoryLineName,
        MIN(issues.IssueNumber) As firstIssueNumber,
        MAX(issues.IssueNumber) As lastIssueNumber,
        COUNT(pages.PageID) AS pageCount
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
        series.SeriesID, series.SeriesName,
        storyarcs.StoryArcID, storyarcs.StoryArcName, storyarcs.IsUnnamed, 
        storyarcs.LastQuickPickDate, 
        storylines.StoryLineID,storylines.StoryLineName
      ORDER BY 
        series.seriesName,
        issues.issueNumber,
        storylines.StoryLineName,
        storyarcs.StoryArcName";

//  echo $query;

    if ($result = $mysqli->query($query)) {

      $i = 0;
      while($row = mysqli_fetch_assoc($result)) {
        $results[$i]['seriesId'] = $row['SeriesID'];
        $results[$i]['seriesName'] = $row['SeriesName'];

        $results[$i]['firstIssueNumber'] = $row['firstIssueNumber'];
        $results[$i]['lastIssueNumber'] = $row['lastIssueNumber'];
        $results[$i]['pageCount'] = $row['pageCount'];

        $results[$i]['storyArcId'] = $row['StoryArcID'];
        $results[$i]['storyArcName'] = $row['StoryArcName'];
        $results[$i]['isUnnamed'] = $row['IsUnnamed'];
        $results[$i]['lastQuickPickDate'] = $row['LastQuickPickDate'];

        $results[$i]['storyLineId'] = $row['StoryLineID'];
        $results[$i]['storyLineName'] = $row['StoryLineName'];

        $i++;
      }
        
      $result->close();
      $mysqli->close();

      return $results;
    } else {
      http_response_code(404);
    }
  }    
}
?>
