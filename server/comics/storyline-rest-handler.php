<?php
require_once("rest-handler-base.php");
require_once("storyline-logic.php");
		
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

		$requestContentType = $_SERVER['HTTP_ACCEPT'];
    // echo "here"."<br>";
    // echo $requestContentType."<br>";
    // echo $statusCode."<br>";
    // return;

		// $this ->setHttpHeaders($requestContentType, $statusCode);
				
		// if(strpos($requestContentType,'application/json') !== false){
			$response = $this->encodeJson($rawData);
			echo $response;
	// 	} else if(strpos($requestContentType,'text/html') !== false){
	// 		$response = $this->encodeHtml($rawData);
	// 		echo $response;
	// 	} else if(strpos($requestContentType,'application/xml') !== false){
	// 		$response = $this->encodeXml($rawData);
	// 		echo $response;
	// 	}
	}
	
	// public function encodeHtml($responseData) {
	
	// 	$htmlResponse = "<table border='1'>";
	// 	foreach($responseData as $key=>$value) {
  //     // $htmlResponse .= "<tr><td>". $key. "</td><td>". $value. "</td></tr>";
  //     $htmlResponse .= "<tr><td>Hello</td></tr>";
	// 	}
	// 	$htmlResponse .= "</table>";
	// 	return $htmlResponse;		
	// }
	
	public function encodeJson($responseData) {
		$jsonResponse = json_encode($responseData);
		return $jsonResponse;		
	}
  
  /*
  public function encodeXml($responseData) {
		// creating object of SimpleXMLElement
		$xml = new SimpleXMLElement('<?xml version="1.0"?><mobile></mobile>');
		foreach($responseData as $key=>$value) {
			$xml->addChild($key, $value);
		}
		return $xml->asXML();
	}
	*/
	// public function getMobile($id) {

	// 	$mobile = new Mobile();
	// 	$rawData = $mobile->getMobile($id);

	// 	if(empty($rawData)) {
	// 		$statusCode = 404;
	// 		$rawData = array('error' => 'No mobiles found!');		
	// 	} else {
	// 		$statusCode = 200;
	// 	}

	// 	$requestContentType = $_SERVER['HTTP_ACCEPT'];
	// 	$this ->setHttpHeaders($requestContentType, $statusCode);
				
	// 	if(strpos($requestContentType,'application/json') !== false){
	// 		$response = $this->encodeJson($rawData);
	// 		echo $response;
	// 	} else if(strpos($requestContentType,'text/html') !== false){
	// 		$response = $this->encodeHtml($rawData);
	// 		echo $response;
	// 	} else if(strpos($requestContentType,'application/xml') !== false){
	// 		$response = $this->encodeXml($rawData);
	// 		echo $response;
	// 	}
	// }
}
?>