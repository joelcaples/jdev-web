<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: PUT, GET, POST, DELETE");
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");

require_once("rest-handler-base.php");
require_once("storyline-logic.php");

$pageid=isset($_GET["pageid"]) ? $_GET["pageid"] : "";
$seriesid=isset($_GET["seriesid"]) ? $_GET["seriesid"] : "";
$issueid=isset($_GET["issueid"]) ? $_GET["issueid"] : "";
$storyarcid=isset($_GET["storyarcid"]) ? $_GET["storyarcid"] : "";
$storylineid=isset($_GET["storylineid"]) ? $_GET["storylineid"] : "";
$storyLineNameSearchCriteria=isset($_GET["name"]) ? $_GET["name"] : "";

class StoryLineRestHandler extends RestHandlerBase {

	function getAll($pageid, $seriesid, $issueid, $storyarcid, $storylineid, $storyLineNameSearchCriteria) {	
    
		$storyLineLogic = new StoryLineLogic();
		$rawData = $storyLineLogic->getAll($pageid, $seriesid, $issueid, $storyarcid, $storylineid, $storyLineNameSearchCriteria);

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

$storyLineRestHandler = new StoryLineRestHandler();
$storyLineRestHandler->getAll($pageid, $seriesid, $issueid, $storyarcid, $storylineid, $storyLineNameSearchCriteria);








// $view = "";
// if(isset($_GET["view"]))
// 	$view = $_GET["view"];
// /*
// controls the RESTful services
// URL mapping
// */
// switch($view){

// 	case "all":
// 		// to handle REST Url /mobile/list/
// 		$mobileRestHandler = new MobileRestHandler();
// 		$mobileRestHandler->getAllMobiles();
// 		break;
		
// 	case "single":
// 		// to handle REST Url /mobile/show/<id>/
// 		$mobileRestHandler = new MobileRestHandler();
// 		$mobileRestHandler->getMobile($_GET["id"]);
// 		break;

// 	case "" :
// 		//404 - not found;
// 		break;
// }
?>
