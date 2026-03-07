import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_life_organizer/Habits Tracker/ui/home_screen.dart';

class LoginUI extends StatefulWidget {
  const LoginUI({super.key});

  @override
  State<LoginUI> createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  // ================== منطق تسجيل الدخول ==================
  Future<void> loginUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    String? usersString = prefs.getString("users");

    if (usersString == null) {
      _showError("لا يوجد مستخدمين مسجلين. قم بإنشاء حساب أولاً.");
      setState(() => isLoading = false);
      return;
    }

    List users = jsonDecode(usersString);
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    Map<String, dynamic>? foundUser;

    // البحث عن المستخدم في القائمة المحفوظة
    for (var user in users) {
      if (user["email"] == email && user["password"] == password) {
        foundUser = user;
        break;
      }
    }

    if (foundUser != null) {
      // حفظ بيانات المستخدم الحالي لتعرض في صفحة الإعدادات
      await prefs.setString('current_user_name', foundUser["name"]);
      await prefs.setString('current_user_email', foundUser["email"]);

      // الانتقال للصفحة الرئيسية
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } else {
      _showError("Error In Your Enters");
    }

    setState(() => isLoading = false);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
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
                const SizedBox(height: 70),
                // اللوجو المربع
                Center(
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(Icons.bolt,
                        color: Color(0xFF2EE07D), size: 60),
                  ),
                ),
                const SizedBox(height: 30),
                const Center(
                  child: Text(
                    "Welcome Back",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 40),

                // حقل الإيميل
                buildField(
                  label: "EMAIL ADDRESS",
                  controller: emailController,
                  hint: "name@example.com",
                  icon: Icons.email_outlined,
                  validator: (v) => v!.isEmpty || !v.contains("@")
                      ? "your email not currect"
                      : null,
                ),
                const SizedBox(height: 20),

                // حقل الباسورد
                buildField(
                  label: "PASSWORD",
                  controller: passwordController,
                  hint: "••••••••",
                  icon: Icons.lock_outline,
                  obscure: true,
                  validator: (v) => v!.isEmpty ? "enter your password" : null,
                ),

                const SizedBox(height: 30),

                // زر تسجيل الدخول مع حالة التحميل
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2EE07D),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: isLoading ? null : loginUser,
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.black)
                        : const Text(
                            "Sign In",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                ),

                const SizedBox(height: 30),

                // قسم السوشيال ميديا
                buildSocialSection(),

                const SizedBox(height: 30),

                // رابط التسجيل
                Center(
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Text.rich(
                      TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(color: Colors.white70),
                        children: [
                          TextSpan(
                            text: "Sign Up",
                            style: TextStyle(
                                color: Color(0xFF2EE07D),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ميثود بناء الحقول
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

  // ميثود السوشيال ميديا
  Widget buildSocialSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: Colors.white.withOpacity(0.3))),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text("Or sign in with",
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
    return InkWell(
      onTap: () {
        // هنا يمكنك إضافة منطق Google Sign In الفعلي لاحقاً
      },
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 30),
            const SizedBox(width: 8),
            Text(text,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
