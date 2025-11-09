import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/bloc/auth/auth_bloc.dart';
import 'package:expense_tracker/bloc/auth/auth_event.dart';
import 'package:expense_tracker/bloc/auth/auth_state.dart';
import 'package:expense_tracker/pages/dashboard_page.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  bool _obscure = true;

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
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
              const SnackBar(
                content: Text("Verifying credentials..."),
                duration: Duration(milliseconds: 800),
                backgroundColor: Colors.redAccent,
              ),
            );
          } else if (state is AuthAuthenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => DashboardPage(user: state.user),
              ),
            );
          } else if (state is AuthError) {
            print(state.message);
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
              final cardWidth =
                  desktop
                      ? constraints.maxWidth * 0.35
                      : (tablet
                          ? constraints.maxWidth * 0.55
                          : constraints.maxWidth * 0.90);
              final padding = desktop ? 38.0 : (tablet ? 28.0 : 20.0);
              final titleSize = desktop ? 34.0 : (tablet ? 28.0 : 24.0);
              final subtitleSize = desktop ? 18.0 : (tablet ? 16.0 : 14.0);
              final fieldSpacing = size.height * 0.018;
              final btnHeight = size.height * 0.062;

              return Stack(
                children: [
                  // Gradient Background
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),

                  // Glassmorphic Card
                  Center(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(26),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: Container(
                            width: cardWidth,
                            padding: EdgeInsets.symmetric(
                              horizontal: padding,
                              vertical: padding * 1.1,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(26),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.20),
                              ),
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(
                                      widthPercent(cardWidth, 0.08),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.28),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Icon(
                                      Icons.account_balance_wallet_rounded,
                                      size: widthPercent(cardWidth, 0.18),
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: fieldSpacing * 1.4),

                                  Text(
                                    "Welcome Back 👋",
                                    style: TextStyle(
                                      fontSize: titleSize,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    "Login to continue",
                                    style: TextStyle(
                                      fontSize: subtitleSize,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                  SizedBox(height: fieldSpacing * 1.4),

                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: _emailCtrl,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                          decoration: _inputDecoration(
                                            "Email",
                                            Icons.email_outlined,
                                          ),
                                          validator:
                                              (v) =>
                                                  v!.trim().isEmpty
                                                      ? "Enter email"
                                                      : null,
                                        ),
                                        SizedBox(height: fieldSpacing),
                                        TextFormField(
                                          controller: _passwordCtrl,
                                          obscureText: _obscure,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                          decoration: _inputDecoration(
                                            "Password",
                                            Icons.lock_outline,
                                          ).copyWith(
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                _obscure
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color: Colors.white70,
                                              ),
                                              onPressed:
                                                  () => setState(
                                                    () => _obscure = !_obscure,
                                                  ),
                                            ),
                                          ),
                                          validator:
                                              (v) =>
                                                  v!.isEmpty
                                                      ? "Enter password"
                                                      : null,
                                        ),
                                        SizedBox(height: fieldSpacing * 1.5),

                                        SizedBox(
                                          width: double.infinity,
                                          height: btnHeight,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            onPressed:
                                                state is AuthLoading
                                                    ? null
                                                    : () {
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        context
                                                            .read<AuthBloc>()
                                                            .add(
                                                              AuthLoginRequested(
                                                                _emailCtrl.text
                                                                    .trim(),
                                                                _passwordCtrl
                                                                    .text
                                                                    .trim(),
                                                              ),
                                                            );
                                                      }
                                                    },
                                            child:
                                                state is AuthLoading
                                                    ? const CircularProgressIndicator(
                                                      color: Colors.black,
                                                    )
                                                    : const Text(
                                                      "Login",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                          ),
                                        ),
                                        SizedBox(height: fieldSpacing * 1.2),

                                        GestureDetector(
                                          onTap:
                                              () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (_) => const SignupPage(),
                                                ),
                                              ),
                                          child: Text(
                                            "Don't have an account? Sign Up",
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(
                                                0.95,
                                              ),
                                            ),
                                          ),
                                        ),
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
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.12)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white, width: 1),
      ),
    );
  }
}
