<?php
// Enable error reporting for development (remove/disable for production)
error_reporting(E_ALL);
ini_set('display_errors', 1);

// CORS Headers - Allow requests from any origin (for development)
header("Access-Control-Allow-Origin: *"); 
// Allow specific methods
header("Access-Control-Allow-Methods: POST, GET, OPTIONS"); // OPTIONS is important for preflight
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
    // error_log("Database connection failed: " . $conn->connect_error);
    die(json_encode(['success' => false, 'message' => 'Database connection failed. Check server logs.']));
}

// Get POST data
$data = json_decode(file_get_contents('php://input'), true);

// Basic validation for presence of keys
if (!isset($data['email']) || !isset($data['password'])) {
    die(json_encode(['success' => false, 'message' => 'Email and password are required.']));
}

$email = $data['email'];
$password_from_user = $data['password']; // Renamed for clarity

// Check user credentials using prepared statements
$stmt = $conn->prepare("SELECT id, email, password FROM users WHERE email = ?");
if ($stmt === false) {
    // error_log("Failed to prepare statement: " . $conn->error);
    die(json_encode(['success' => false, 'message' => 'Server error preparing statement.']));
}

$stmt->bind_param("s", $email);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();
    // Verify the hashed password
    if (password_verify($password_from_user, $user['password'])) {
        // Login successful
        // You might want to start a session here or return a token
        echo json_encode(['success' => true, 'message' => 'Login successful', 'user_id' => $user['id']]); // Optionally return user_id or other non-sensitive info
    } else {
        echo json_encode(['success' => false, 'message' => 'Invalid email or password.']); // More generic message for security
    }
} else {
    echo json_encode(['success' => false, 'message' => 'Invalid email or password.']); // More generic message
}

$stmt->close();
$conn->close();
?>