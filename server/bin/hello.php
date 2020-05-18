BEGIN
<?php 

// read products
function read(){
  
    $stmt = "Hello PHP";
  
    return $stmt;
}
?>

<!--?php phpinfo(); ?-->

<?php echo read(); ?>

<?php
$mysqli = new mysqli("localhost", "endles38_dbuser", "*dT91EWA", "endles38_comics");

$query = "SELECT * FROM `series` WHERE 1";
if ($result = $mysqli->query($query)) {
printf("<h3>Here</h3>");
    while ($row = $result->fetch_row()) {
        printf("%s <br />\n", $row[0]);
    }
    $result->close();
}

$mysqli->close();

?>

END