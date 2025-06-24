import 'package:flutter/material.dart';

class PassField extends StatefulWidget {
  const PassField({
    super.key,
    required this.passwordController,
  });
  final TextEditingController passwordController;

  @override
  State<PassField> createState() => PassFieldState();
}

class PassFieldState extends State<PassField> {
  bool _passwordVisible = false; // حالة إظهار/إخفاء كلمة المرور

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        cursorColor: Color(0xff2a918e),
        controller: widget.passwordController,
        decoration: InputDecoration(
          labelText: 'كلمة المرور',
          labelStyle: TextStyle(
            fontFamily: 'ElMessiri',
            color: Color(0xff2a918e),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Color(0xff2fbfac),
              width: 1.5,
            ),
          ),
          prefixIcon: Icon(
            Icons.lock,
            color: Colors.redAccent,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: Color(0xff2a918e),
            ),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          ),
        ),
        obscureText: !_passwordVisible,
        validator: (value) {
          if (value!.isEmpty) return 'يرجى إدخال كلمة المرور';
          if (value.length < 6) {
            return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
          }

          return null;
        },
      ),
    );
  }
}
