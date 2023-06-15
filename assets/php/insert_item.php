<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$userId = $_POST['userId'];
$itemName = $_POST['itemName'];
$itemDescription = $_POST['itemDescription'];
$itemPrice = $_POST['itemPrice'];
$itemQuantity = $_POST['itemQuantity'];
$itemType = $_POST['itemType'];
$latitude = $_POST['lat'];
$longitude = $_POST['long'];
$state = $_POST['state'];
$locality = $_POST['loc'];

$sqlinsert = "INSERT INTO `tbl_items`( `user_id`, `item_name`, `item_description`, `item_price`, `item_quantity`, `item_type`, `latitude`, `longitude`, `state`, `locality`) VALUES ('$userId','$itemName','$itemDescription','$itemPrice','$itemQuantity','$itemType','$latitude','$longitude','$state','$locality')";

if ($conn->query($sqlinsert) === TRUE) {
    $item_id = mysqli_insert_id($conn);

    $images = json_decode($_POST['images']); 

    foreach ($images as $index => $image) {
        $decoded_string = base64_decode($image);
        $path = '../assets/items/' . $item_id . '_' . ($index + 1) . '.png';
        file_put_contents($path, $decoded_string);
    }

    $response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>