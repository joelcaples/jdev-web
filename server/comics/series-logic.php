<?php
/* 
A domain RESTful web services class
*/
Class SeriesLogic {

  public function getAll($pageid, $seriesid, $issueid, $storyarcid, $storylineid, $storyLineNameSearchCriteria) {

    $ini = parse_ini_file('../app-config.ini');
  
    $mysqli = new mysqli(
      $ini['db_server'], 
      $ini['db_user'], 
      $ini['db_password'], 
      $ini['db_name']
    );

    $series = [];
    $query = "SELECT SeriesID, SeriesName 
      FROM series
      LIMIT 200";

    if ($result = $mysqli->query($query)) {

      $i = 0;
      while($row = mysqli_fetch_assoc($result))
      {
        $series[$i]['seriesId'] = $row['SeriesID'];
        $series[$i]['seriesName'] = $row['SeriesName'];
        $i++;
      }

      $result->close();
      $mysqli->close();

      return $series;
    } else {
      http_response_code(404);
    }
  }
}    

?>