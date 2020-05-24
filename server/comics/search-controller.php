<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: PUT, GET, POST, DELETE");
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");

require_once("rest-handler-base.php");
require_once("search-logic.php");

// $pageid=isset($_GET["pageid"]) ? $_GET["pageid"] : "";
$seriesid=isset($_GET["seriesid"]) ? $_GET["seriesid"] : "";
$issueid=isset($_GET["issueid"]) ? $_GET["issueid"] : "";
$storylineid=isset($_GET["storylineid"]) ? $_GET["storylineid"] : "";
$storyarcid=isset($_GET["storyarcid"]) ? $_GET["storyarcid"] : "";

class SearchRestHandler extends RestHandlerBase {

	function getAll($seriesid, $issueid, $storylineid, $storyarcid) {	
    
		$searchLogic = new SearchLogic();
		$rawData = $searchLogic->getAll($seriesid, $issueid, $storylineid, $storyarcid);

		if(empty($rawData)) {
			$statusCode = 404;
			$rawData = array('error' => 'No matches found');		
		} else {
			$statusCode = 200;
		}

    $response = $this->encodeJson($rawData);
    echo $response;
	}
	
	public function encodeJson($responseData) {
		$jsonResponse = json_encode($responseData);
		return $jsonResponse;		
	}

}

$searchRestHandler = new SearchRestHandler();
$searchRestHandler->getAll($seriesid, $issueid, $storylineid, $storyarcid);
?>
