<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: PUT, GET, POST, DELETE");
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");

require_once("rest-handler-base.php");
require_once("issues-logic.php");

$pageid=isset($_GET["pageid"]) ? $_GET["pageid"] : "";
$seriesid=isset($_GET["seriesid"]) ? $_GET["seriesid"] : "";
$issueid=isset($_GET["issueid"]) ? $_GET["issueid"] : "";
$storylineid=isset($_GET["storylineid"]) ? $_GET["storylineid"] : "";
$storyarcid=isset($_GET["storyarcid"]) ? $_GET["storyarcid"] : "";
$issueNameSearchCriteria=isset($_GET["name"]) ? $_GET["name"] : "";

class IssueRestHandler extends RestHandlerBase {

	function getAll($pageid, $seriesid, $issueid, $storylineid, $storyarcid) {	
    
		$issueLogic = new IssuesLogic();
		$rawData = $issueLogic->getAll($pageid, $seriesid, $issueid, $storylineid, $storyarcid);

		// if(empty($rawData)) {
		// 	$response = [];
		// }


		// if(empty($rawData)) {
		// 	$statusCode = 404;
		// 	$rawData = array();//array('error' => 'No matches found');		
		// }
		// } else {
			$statusCode = 200;
		// }

		$response = $this->encodeJson($rawData);
		// echo "here 2.5<br>";
		echo $response;
		// echo "here 2.75<br>";

	}
	
	public function encodeJson($responseData) {
		$jsonResponse = json_encode($responseData);
		return $jsonResponse;		
	}

}
$issueRestHandler = new IssueRestHandler();
$issueRestHandler->getAll($pageid, $seriesid, $issueid, $storylineid, $storyarcid);
?>
