import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_life_organizer/Login%20&%20Sign%20Up/auth/sign_in_cuobit.dart';
import 'package:smart_life_organizer/Login%20&%20Sign%20Up/auth/sign_in_state.dart';
import 'package:smart_life_organizer/Login%20&%20Sign%20Up/login.dart';

class SignUpUI extends StatelessWidget {
  const SignUpUI({super.key});

  @override
  Widget build(BuildContext context) {
    // نلف الشاشة بـ BlocProvider لتوفر الـ Cubit للواجهة
    return BlocProvider(
      create: (context) => SignUpCubit(),
      child: const CreateAccountScreen(),
    );
  }
}

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // استخدام BlocConsumer للاستماع للحالات وتحديث الواجهة في نفس الوقت
      body: BlocConsumer<SignUpCubit, SignUpState>(
        listener: (context, state) {
          if (state is SignUpSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Account Created Successfully")),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginUI()),
            );
          }
          if (state is SignUpError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return SizedBox.expand(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF0E3B2E), Color(0xFF06281F)],
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 60),
                      Center(
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Icon(Icons.person_add,
                              color: Color(0xFF2EE07D), size: 60),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Center(
                        child: Text(
                          "Create Your Account",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 30),

                      buildField(
                        label: "FULL NAME",
                        controller: nameController,
                        hint: "John Doe",
                        icon: Icons.person_outline,
                        validator: (v) =>
                            v!.isEmpty ? "Name is required" : null,
                      ),
                      const SizedBox(height: 20),
                      buildField(
                        label: "EMAIL ADDRESS",
                        controller: emailController,
                        hint: "name@example.com",
                        icon: Icons.email_outlined,
                        validator: (v) => (v!.isEmpty || !v.contains("@"))
                            ? "Invalid email"
                            : null,
                      ),
                      const SizedBox(height: 20),
                      buildField(
                        label: "PASSWORD",
                        controller: passwordController,
                        hint: "••••••••",
                        icon: Icons.lock_outline,
                        obscure: true,
                        validator: (v) =>
                            v!.length < 6 ? "Min 6 characters" : null,
                      ),
                      const SizedBox(height: 30),

                      // زر التسجيل مع حالة التحميل
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2EE07D),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                          onPressed: state is SignUpLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<SignUpCubit>().register(
                                          nameController.text.trim(),
                                          emailController.text.trim(),
                                          passwordController.text.trim(),
                                        );
                                  }
                                },
                          child: state is SignUpLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.black)
                              : const Text(
                                  "Create Account",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),

                      const SizedBox(height: 25),
                      buildSocialSection(),
                      const SizedBox(height: 30),

                      Center(
                        child: InkWell(
                          onTap: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LoginUI())),
                          child: const Text.rich(
                            TextSpan(
                              text: "Already have an account? ",
                              style: TextStyle(color: Colors.white70),
                              children: [
                                TextSpan(
                                  text: "Log In",
                                  style: TextStyle(
                                      color: Color(0xFF2EE07D),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // --- Widgets مساعدة للحفاظ على نظافة الكود ---

  Widget buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscure,
            validator: validator,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white54),
              prefixIcon: Icon(icon, color: Colors.white70),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSocialSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: Colors.white.withOpacity(0.3))),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text("Or sign up with",
                  style: TextStyle(color: Colors.white70)),
            ),
            Expanded(child: Divider(color: Colors.white.withOpacity(0.3))),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
                child: socialButton(icon: Icons.g_mobiledata, text: "Google")),
            const SizedBox(width: 16),
            Expanded(child: socialButton(icon: Icons.apple, text: "Apple")),
          ],
        ),
      ],
    );
  }

  Widget socialButton({required IconData icon, required String text}) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Text(text,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
