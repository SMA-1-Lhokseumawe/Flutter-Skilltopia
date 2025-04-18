import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'lupaPassword.dart';
import 'package:skilltopia/Beranda/beranda.dart';
import 'package:skilltopia/repository.dart'; // Import repository untuk login
import 'package:skilltopia/models.dart';

class loginPage extends StatefulWidget {
  const loginPage({Key? key}) : super(key: key);

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final UserRepository _repository = UserRepository();

  bool _isObscure = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    // Basic validation
    if (username.isEmpty || password.isEmpty) {
      _showErrorMessage('Username and password cannot be empty');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      print("username: $username, Password: $password"); // Logging request
      final response = await _repository.loginUser(username, password);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        print("Response Status: ${response.status}");
        print("Response Message: ${response.message}");

        if (response.status) {
          
          final uuid = response.uuid ?? '';
          final accessToken = response.accessToken ?? '';

          Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 300),
              child: Beranda(
                uuid: uuid,
                accessToken: accessToken,
              ),
            ),
          );
        } else {
          _showErrorMessage(response.message);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        print("Error: $e");  // Logging error message
        _showErrorMessage('Login failed: ${e.toString()}');
      }
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background curved shapes
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Color(0xFF27DEBF).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Color(0xFF27DEBF).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Header Section with Join with Us!
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 10, bottom: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'JOIN WITH US!',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF27DEBF),
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Sign in with your username',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // App Logo & Name
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(75),
                              child: Container(
                                color: Color(0xFF27DEBF).withOpacity(0.1),
                                padding: EdgeInsets.all(15),
                                child: Image.asset(
                                  'assets/gambarlogin.png',
                                  height: 120,
                                  width: 120,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'SKILLTOPIA',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 26,
                                letterSpacing: 1.8,
                                color: Color(0xFF27DEBF),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Bank Soal Digital untuk Evaluasi Siswa',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 30),

                      // Username Field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 5,
                          ),
                          child: TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Username',
                              hintStyle: TextStyle(color: Colors.grey),
                              icon: Icon(
                                Icons.account_circle_outlined,
                                color: Color(0xFF27DEBF),
                              ),
                            ),
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),

                      // Password Field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 5,
                          ),
                          child: TextField(
                            controller: _passwordController,
                            obscureText: _isObscure,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Password',
                              hintStyle: TextStyle(color: Colors.grey),
                              icon: Icon(
                                Icons.lock_outline,
                                color: Color(0xFF27DEBF),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscure
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Color(0xFF27DEBF),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                              ),
                            ),
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                      ),

                      SizedBox(height: 15),

                      // Forgot Password Link
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LupaPassword(),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Color(0xFF27DEBF),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 30),

                      // Login Button with teal color
                      GestureDetector(
                        onTap: _isLoading ? null : _login, // Call _login method when button is tapped
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Color(0xFF27DEBF),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF27DEBF).withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: _isLoading
                                ? SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    'LOGIN',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}