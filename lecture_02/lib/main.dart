import 'package:flutter/material.dart';
import 'dart:convert'; // Required for jsonEncode/jsonDecode
import 'package:http/http.dart' as http; // Required for http requests

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login App',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const LoginPage(),
    );
  }
}

// Login Page
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline, size: 80, color: Colors.indigo),
                const SizedBox(height: 20),
                const Text('Welcome Back!',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (value) => (value == null || !value.contains('@')) ? 'Enter a valid email' : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: passwordController,
                        obscureText: !isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                            onPressed: () => setState(() => isPasswordVisible = !isPasswordVisible),
                          ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        validator: (value) => (value == null || value.isEmpty) ? 'Enter your password' : null,
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            String url = 'http://localhost/flutter_test/login.php'; // Adjust if not running on web
                            Map<String, String> headers = {'Content-Type': 'application/json'};
                            Map<String, dynamic> body = {'email': emailController.text, 'password': passwordController.text};

                            try {
                              final response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body)).timeout(const Duration(seconds: 10));
                              if (!mounted) return;

                              if (response.statusCode == 200) {
                                final responseData = jsonDecode(response.body);
                                if (responseData['success'] == true) {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardPage(email: emailController.text)));
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseData['message'] ?? 'Login successful!')));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseData['message'] ?? 'Login failed.')));
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Server error: ${response.statusCode}')));
                              }
                            } catch (e) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                            }
                          }
                        },
                        child: const Text('Login', style: TextStyle(fontSize: 16)),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupPage())),
                        child: const Text("New here? Signup", style: TextStyle(color: Colors.indigo, decoration: TextDecoration.underline)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Dashboard Page
class DashboardPage extends StatelessWidget {
  final String email;
  const DashboardPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard'), backgroundColor: Colors.indigo),
      body: Center(child: Text('Welcome, $email', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
    );
  }
}

// Signup Page
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Signup')),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_add, size: 80, color: Colors.indigo),
              const SizedBox(height: 10),
              const Text('Create Account', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(controller: firstNameController, decoration: InputDecoration(labelText: 'First Name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), validator: (value) => (value == null || value.isEmpty) ? 'Enter first name' : null),
                    const SizedBox(height: 20),
                    TextFormField(controller: lastNameController, decoration: InputDecoration(labelText: 'Last Name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), validator: (value) => (value == null || value.isEmpty) ? 'Enter last name' : null),
                    const SizedBox(height: 20),
                    TextFormField(controller: emailController, decoration: InputDecoration(labelText: 'Email Address', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), validator: (value) => (value == null || !value.contains('@')) ? 'Enter a valid email' : null),
                    const SizedBox(height: 20),
                    TextFormField(controller: passwordController, obscureText: true, decoration: InputDecoration(labelText: 'Password', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), validator: (value) => (value == null || value.length < 6) ? 'Password too short' : null),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String url = 'http://localhost/flutter_test/signup.php'; // Adjust if not running on web
                          Map<String, String> headers = {'Content-Type': 'application/json'};
                          Map<String, dynamic> body = {'first_name': firstNameController.text, 'last_name': lastNameController.text, 'email': emailController.text, 'password': passwordController.text};
                          
                          try {
                            final response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body)).timeout(const Duration(seconds: 10));
                            if (!mounted) return;

                            if (response.statusCode == 200) {
                              final responseData = jsonDecode(response.body);
                              if (responseData['success'] == true) {
                                Navigator.pop(context); 
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseData['message'] ?? 'Signup successful!')));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(responseData['message'] ?? 'Signup failed.')));
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Server error: ${response.statusCode}')));
                            }
                          } catch (e) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                          }
                        }
                      },
                      child: const Text('Signup', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}