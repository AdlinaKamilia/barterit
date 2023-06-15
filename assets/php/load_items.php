<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");
if(isset($_POST['userid'])){
	$userid = $_POST['userid'];
	$sqlloadcatches = "SELECT * FROM `tbl_items` WHERE user_id = '$userid'";
}else if(isset($_POST['search'])){
	$search = $_POST['search'];
	$sqlloadcatches = "SELECT * FROM `tbl_items` WHERE catch_name LIKE '%$search%'";
}
else{
	$sqlloadcatches = "SELECT * FROM `tbl_items`";
}
$result = $conn->query($sqlloadcatches);
if ($result->num_rows > 0) {
    $items["items"] = array();
	
while ($row = $result->fetch_assoc()) {
        $itemlist = array();
        $itemlist['item_id'] = $row['item_id'];
        $itemlist['user_id'] = $row['user_id'];
        $itemlist['item_name'] = $row['item_name'];
        $itemlist['item_description'] = $row['item_description'];
        $itemlist['item_price'] = $row['item_price'];
        $itemlist['item_quantity'] = $row['item_quantity'];
        $itemlist['item_type'] = $row['item_type'];
        $itemlist['latitude'] = $row['latitude'];
        $itemlist['longitude'] = $row['longitude'];
        $itemlist['state'] = $row['state'];
        $itemlist['locality'] = $row['locality'];
		$itemlist['date'] = $row['date'];
        array_push($items["items"],$itemlist);
    }
    $response = array('status' => 'success', 'data' => $items);
    sendJsonResponse($response);
}else{
     $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}