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

    $pages = [];
    $query = "SELECT PageID, IssueID, PageNumber, 
                PageFileName, PageType, CreationDate, 
                ModificationDate, FileID 
              FROM pages 
              WHERE IssueID=".$id." LIMIT 200"; 

    if ($result = $mysqli->query($query)) {

      $i = 0;
      while($row = mysqli_fetch_assoc($result)) {
        $pages[$i]['pageId'] = $row['PageID'];
        $pages[$i]['issueId'] = $row['IssueID'];
        $pages[$i]['pageNumber'] = $row['PageNumber'];
        $pages[$i]['pageFileName'] = $row['PageFileName'];
        $pages[$i]['pageType'] = $row['PageType'];
        $pages[$i]['creationDate'] = $row['CreationDate'];
        $pages[$i]['modificationDate'] = $row['ModificationDate'];
        $pages[$i]['fileId'] = $row['FileID'];
        $i++;
      }
        
      $result->close();
      $mysqli->close();

      return $pages;
    } else {
      http_response_code(404);
    }
  }
}    
?>
