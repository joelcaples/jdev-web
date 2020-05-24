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

    $pages = [];
    $query = "SELECT
                series.SeriesID, series.SeriesName,
                issues.IssueID, issues.IssueNumber, issues.FilePath,
                pages.PageID, pages.PageNumber, pages.PageType, Pages.PageFileName,
                storyarcs.StoryArcID, storyarcs.StoryArcName, storyarcs.IsUnnamed, 
                storyarcs.LastQuickPickDate, 
                storylines.StoryLineID,storylines.StoryLineName
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

    $query = $query." ORDER BY 
      series.seriesName,
      storylines.StoryLineName,
      issues.IssueNumber,
      storyarcs.StoryArcName,
      pages.PageNumber
      LIMIT 500";

  //echo $query;

    if ($result = $mysqli->query($query)) {

      $i = 0;
      while($row = mysqli_fetch_assoc($result)) {
        $pages[$i]['seriesId'] = $row['SeriesID'];
        $pages[$i]['seriesName'] = $row['SeriesName'];

        $pages[$i]['issueId'] = $row['IssueID'];
        $pages[$i]['issueNumber'] = $row['IssueNumber'];
        $pages[$i]['filePath'] = $row['FilePath'];

        $pages[$i]['pageId'] = $row['PageID'];
        $pages[$i]['pageNumber'] = $row['PageNumber'];
        $pages[$i]['pageType'] = $row['PageType'];
        $pages[$i]['pageFileName'] = $row['PageFileName'];

        $pages[$i]['storyArcId'] = $row['StoryArcID'];
        $pages[$i]['storyArcName'] = $row['StoryArcName'];
        $pages[$i]['isUnnamed'] = $row['IsUnnamed'];
        $pages[$i]['lastQuickPickDate'] = $row['LastQuickPickDate'];

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
  }    
}
?>
