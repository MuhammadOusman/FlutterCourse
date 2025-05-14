<?php
// Enable error reporting for development (remove/disable for production)
error_reporting(E_ALL);
ini_set('display_errors', 1);

// CORS Headers - Allow requests from any origin (for development)
header("Access-Control-Allow-Origin: *"); 
// Allow specific methods
header("Access-Control-Allow-Methods: POST, GET, OPTIONS"); 
// Allow specific headers
header("Access-Control-Allow-Headers: Content-Type, Authorization"); 

// If it's an OPTIONS request (preflight request), send OK and exit
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit;
}

// Set content type to JSON for all other responses
header('Content-Type: application/json');

// Database connection
$conn = new mysqli('localhost', 'root', '', 'flutter_test');
if ($conn->connect_error) {
    // It's good practice to log the actual error for server-side debugging
    // error_log("Database connection failed: " . $conn->connect_error);
    die(json_encode(['success' => false, 'message' => 'Database connection failed. Please check server logs.']));
}

// Get POST data
$data = json_decode(file_get_contents('php://input'), true);

// Basic validation for presence of keys
if (
    !isset($data['first_name']) || 
    !isset($data['last_name']) || 
    !isset($data['email']) || 
    !isset($data['password'])
) {
    die(json_encode(['success' => false, 'message' => 'Missing required fields.']));
}

$firstName = $data['first_name'];
$lastName = $data['last_name'];
$email = $data['email'];
// It's better to validate the password strength/length here
$password = password_hash($data['password'], PASSWORD_BCRYPT);

// Insert user into the database using prepared statements to prevent SQL injection
$stmt = $conn->prepare("INSERT INTO users (first_name, last_name, email, password) VALUES (?, ?, ?, ?)");

// Check if statement was prepared successfully
if ($stmt === false) {
    // error_log("Failed to prepare statement: " . $conn->error);
    die(json_encode(['success' => false, 'message' => 'Server error preparing statement.']));
}

// Bind parameters: ssss means four string parameters
$stmt->bind_param("ssss", $firstName, $lastName, $email, $password);

if ($stmt->execute()) {
    echo json_encode(['success' => true, 'message' => 'Signup successful']);
} else {
    // Check for duplicate entry specifically for email (MySQL error code 1062)
    if ($conn->errno == 1062) {
        echo json_encode(['success' => false, 'message' => 'Email already exists.']);
    } else {
        // Log the actual error for server-side debugging
        // error_log("Failed to execute statement: " . $stmt->error);
        echo json_encode(['success' => false, 'message' => 'Signup failed. Please try again. Error: ' . $stmt->error]);
    }
}

$stmt->close();
$conn->close();
?>