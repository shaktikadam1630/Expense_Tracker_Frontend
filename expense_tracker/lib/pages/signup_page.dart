import 'dart:ui';
import 'package:expense_tracker/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/auth/auth_state.dart';


class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _confirmPassCtrl = TextEditingController();

  bool _obscure = true;
  bool _obscureConfirm = true;

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  bool isTablet(BoxConstraints c) => c.maxWidth >= 600;
  bool isDesktop(BoxConstraints c) => c.maxWidth >= 900;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Creating account..."),
              backgroundColor: Colors.redAccent,),
               
            );
          } else if (state is singup ) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Signup Successful!"),
                backgroundColor: Colors.green,
              ),
            );
            Future.delayed(const Duration(milliseconds: 600), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            });
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        builder: (context, state) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final size = MediaQuery.of(context).size;
              final tablet = isTablet(constraints);
              final desktop = isDesktop(constraints);

              final cardWidth = desktop ? constraints.maxWidth * 0.35 : (tablet ? constraints.maxWidth * 0.55 : constraints.maxWidth * 0.90);
              final padding = desktop ? 38.0 : (tablet ? 28.0 : 20.0);

              final titleSize = desktop ? 34.0 : (tablet ? 28.0 : 24.0);
              final subtitleSize = desktop ? 18.0 : (tablet ? 16.0 : 14.0);

              final fieldSpacing = size.height * 0.018;
              final btnHeight = size.height * 0.062;

              return Stack(
                children: [
                  // Background Gradient
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF2575FC), Color(0xFF6A11CB)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),

                  // Center Content
                  Center(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(26),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: Container(
                            width: cardWidth,
                            padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding * 1.1),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(26),
                              border: Border.all(color: Colors.white.withOpacity(0.20)),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(widthPercent(cardWidth, 0.08)),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.28),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(Icons.person_add_alt_1, size: widthPercent(cardWidth, 0.18), color: Colors.white),
                                  ),

                                  SizedBox(height: fieldSpacing * 1.4),

                                  Text(
                                    "Create Account",
                                    style: TextStyle(fontSize: titleSize, color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    "Sign up to get started",
                                    style: TextStyle(fontSize: subtitleSize, color: Colors.white.withOpacity(0.9)),
                                  ),
                                  SizedBox(height: fieldSpacing * 1.4),

                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        // Name
                                        TextFormField(
                                          controller: _nameCtrl,
                                          style: const TextStyle(color: Colors.white),
                                          decoration: _inputDecoration("Full Name", Icons.person),
                                          validator: (v) => v!.trim().isEmpty ? "Enter name" : null,
                                        ),
                                        SizedBox(height: fieldSpacing),

                                        // Email
                                        TextFormField(
                                          controller: _emailCtrl,
                                          style: const TextStyle(color: Colors.white),
                                          decoration: _inputDecoration("Email", Icons.email_outlined),
                                          validator: (v) => v!.trim().isEmpty ? "Enter email" : null,
                                        ),
                                        SizedBox(height: fieldSpacing),

                                        // Password
                                        TextFormField(
                                          controller: _passwordCtrl,
                                          obscureText: _obscure,
                                          style: const TextStyle(color: Colors.white),
                                          decoration: _inputDecoration("Password", Icons.lock_outline).copyWith(
                                            suffixIcon: IconButton(
                                              icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off, color: Colors.white70),
                                              onPressed: () => setState(() => _obscure = !_obscure),
                                            ),
                                          ),
                                          validator: (v) => v!.isEmpty ? "Enter password" : null,
                                        ),
                                        SizedBox(height: fieldSpacing),

                                        // Confirm Password
                                        TextFormField(
                                          controller: _confirmPassCtrl,
                                          obscureText: _obscureConfirm,
                                          style: const TextStyle(color: Colors.white),
                                          decoration: _inputDecoration("Confirm Password", Icons.lock_reset).copyWith(
                                            suffixIcon: IconButton(
                                              icon: Icon(_obscureConfirm ? Icons.visibility : Icons.visibility_off, color: Colors.white70),
                                              onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                                            ),
                                          ),
                                          validator: (v) {
                                            if (v!.isEmpty) return "Confirm your password";
                                            if (v != _passwordCtrl.text) return "Passwords do not match";
                                            return null;
                                          },
                                        ),

                                        SizedBox(height: fieldSpacing * 1.5),

                                        SizedBox(
                                          width: double.infinity,
                                          height: btnHeight,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                            ),
                                            onPressed: state is AuthLoading
                                                ? null
                                                : () {
                                                    if (_formKey.currentState!.validate()) {
                                                      context.read<AuthBloc>().add(
                                                            AuthSignupRequested(
                                                              _nameCtrl.text.trim(),
                                                              _emailCtrl.text.trim(),
                                                              _passwordCtrl.text.trim(),
                                                            ),
                                                          );
                                                    }
                                                  },
                                            child: state is AuthLoading
                                                ? const CircularProgressIndicator(color: Colors.black)
                                                : const Text("Sign Up", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                          ),
                                        ),

                                        SizedBox(height: fieldSpacing * 1.2),

                                        GestureDetector(
                                          onTap: () => Navigator.pop(context),
                                          child: Text(
                                            "Already have an account? Login",
                                            style: TextStyle(color: Colors.white.withOpacity(0.95)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  double widthPercent(double width, double percent) => width * percent;

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white70),
      filled: true,
      fillColor: Colors.white.withOpacity(0.06),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.white.withOpacity(0.12))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.white, width: 1)),
    );
  }
}
