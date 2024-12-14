<?php
// Database connection
$servername = "localhost";
$username = "root"; // Replace with your database username
$password = ""; // Replace with your database password
$dbname = "flutter_app"; // Replace with your database name

$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Handling POST request
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $email = $_POST['email'];
    $password = $_POST['password'];

    // Check if the email exists and password matches
    $sql = "SELECT * FROM users WHERE email = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        
        // Verify password (assuming it's hashed in the database)
        if (password_verify($password, $row['password'])) {
            echo json_encode([
                "status" => "success",
                "message" => "Login successful!",
                "user" => [
                    "id" => $row['id'],
                    "email" => $row['email'],
                    "name" => $row['name']
                ]
            ]);
        } else {
            echo json_encode([
                "status" => "error",
                "message" => "Invalid password."
            ]);
        }
    } else {
        echo json_encode([
            "status" => "error",
            "message" => "User does not exist."
        ]);
    }

    $stmt->close();
}

$conn->close();
?>
