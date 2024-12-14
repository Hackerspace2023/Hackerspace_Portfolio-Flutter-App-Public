<?php
// Enable error reporting for debugging (remove this in production)
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// Database configuration
$servername = "localhost";  // Change this to your database server
$username = "root";         // Your database username
$password = "";             // Your database password
$dbname = "flutter_app";  // Replace with your database name

// Connect to the database
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die(json_encode([
        "success" => false,
        "message" => "Database connection failed: " . $conn->connect_error
    ]));
}

// Get the input data from the request
$input = file_get_contents("php://input");
$data = json_decode($input, true);

// Validate required fields
if (!isset($data['email']) || empty($data['email'])) {
    echo json_encode([
        "success" => false,
        "message" => "Email is required."
    ]);
    exit;
}

// Extract data from the request
$email = $conn->real_escape_string($data['email']);
$name = isset($data['name']) ? $conn->real_escape_string($data['name']) : null;
$phone_number = isset($data['phone_number']) ? $conn->real_escape_string($data['phone_number']) : null;
$gender = isset($data['gender']) ? $conn->real_escape_string($data['gender']) : null;

// Construct the SQL query for updating the user
$sql = "UPDATE users SET ";
$fieldsToUpdate = [];

if ($name !== null) {
    $fieldsToUpdate[] = "name = '$name'";
}
if ($phone_number !== null) {
    $fieldsToUpdate[] = "phone_number = '$phone_number'";
}
if ($gender !== null) {
    $fieldsToUpdate[] = "gender = '$gender'";
}

if (empty($fieldsToUpdate)) {
    echo json_encode([
        "success" => false,
        "message" => "No fields to update."
    ]);
    exit;
}

$sql .= implode(", ", $fieldsToUpdate);
$sql .= " WHERE email = '$email'";

// Execute the query
if ($conn->query($sql) === TRUE) {
    echo json_encode([
        "success" => true,
        "message" => "User details updated successfully."
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Error updating user: " . $conn->error
    ]);
}

// Close the connection
$conn->close();
?>
