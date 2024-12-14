<?php
header("Content-Type: application/json");

$servername = "localhost";
$username = "root"; // Default username
$password = ""; // Default password
$dbname = "flutter_app"; // Ensure this database exists

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(["success" => false, "message" => "Connection failed: " . $conn->connect_error]));
}

$data = json_decode(file_get_contents("php://input"), true);

$email = $data['email'];
$name = isset($data['name']) ? $data['name'] : null;
$password = isset($data['password']) ? password_hash($data['password'], PASSWORD_DEFAULT) : null;
$googleSignIn = isset($data['google_sign_in']) ? $data['google_sign_in'] : false;

if ($googleSignIn) {
    // Handle Google Sign-In
    $checkQuery = "SELECT * FROM users WHERE email='$email'";
    $result = $conn->query($checkQuery);
    if ($result->num_rows > 0) {
        echo json_encode(["success" => true, "message" => "Welcome back, $email"]);
    } else {
        $insertQuery = "INSERT INTO users (name, email) VALUES ('$name', '$email')";
        if ($conn->query($insertQuery)) {
            echo json_encode(["success" => true, "message" => "Google account registered successfully"]);
        } else {
            echo json_encode(["success" => false, "message" => "Error: " . $conn->error]);
        }
    }
} else {
    // Handle Manual Sign-Up
    $phoneNumber = $data['phone_number'];
    $gender = $data['gender'];

    $insertQuery = "INSERT INTO users (name, email, phone_number, gender, password) 
                    VALUES ('$name', '$email', '$phoneNumber', '$gender', '$password')";

    if ($conn->query($insertQuery)) {
        echo json_encode(["success" => true, "message" => "User registered successfully"]);
    } else {
        echo json_encode(["success" => false, "message" => "Error: " . $conn->error]);
    }
}

$conn->close();
?>
