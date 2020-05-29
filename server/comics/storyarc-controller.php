<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: PUT, GET, POST, DELETE");
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");

require_once("rest-handler-base.php");
require_once("storyarcs-logic.php");

$pageid=isset($_GET["pageid"]) ? $_GET["pageid"] : "";
$seriesid=isset($_GET["seriesid"]) ? $_GET["seriesid"] : "";
$issueid=isset($_GET["issueid"]) ? $_GET["issueid"] : "";
$storylineid=isset($_GET["storylineid"]) ? $_GET["storylineid"] : "";
$storyarcid=isset($_GET["storyarcid"]) ? $_GET["storyarcid"] : "";
$storyArcNameSearchCriteria=isset($_GET["name"]) ? $_GET["name"] : "";

class StoryArcRestHandler extends RestHandlerBase {

	function getAll($pageid, $seriesid, $issueid, $storylineid, $storyarcid, $storyArcNameSearchCriteria) {	
    
		$storyArcLogic = new StoryArcLogic();
		$rawData = $storyArcLogic->getAll($pageid, $seriesid, $issueid,  $storylineid, $storyarcid, $storyArcNameSearchCriteria);

		// if(empty($rawData)) {
		// 	$statusCode = 404;
		// 	$rawData = array('error' => 'No matches found');		
		// } else {
			$statusCode = 200;
		// }

    $response = $this->encodeJson($rawData);
    echo $response;
	}
	
	public function encodeJson($responseData) {
		$jsonResponse = json_encode($responseData);
		return $jsonResponse;		
	}

}

$storyArcRestHandler = new StoryArcRestHandler();
$storyArcRestHandler->getAll($pageid, $seriesid, $issueid, $storyarcid, $storylineid, $storyArcNameSearchCriteria);
?>
