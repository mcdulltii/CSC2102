import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class CustomTextField extends StatefulWidget {
  final String textHint;
  final Icon inputIcon;
  final bool isReadyOnly;
  final TextEditingController? controller;
  final Color borderColor;
  final bool isPassword;

  const CustomTextField({
    required this.isReadyOnly,
    required this.textHint,
    this.borderColor = Colors.white,
    this.controller,
    this.isPassword = false,
    this.inputIcon = const Icon(
      Icons.location_on,
      color: AppTheme.hintTextColor,
    ), // Default icon is location
    super.key,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;

  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: widget.borderColor),
        borderRadius: BorderRadius.circular(18.0),
        color: Colors.white,
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          widget.inputIcon,
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: SizedBox(
              height: 50,
              child: TextField(
                obscureText: widget.isPassword && !isVisible,
                controller: _controller,
                readOnly: widget.isReadyOnly,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: widget.textHint,
                ),
              ),
            ),
          ),
          widget.isPassword
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      isVisible = !isVisible;
                    });
                  },
                  child: Icon(
                    isVisible ? Icons.visibility_off : Icons.visibility,
                    color: AppTheme.hintTextColor,
                  ),
                )
              : const SizedBox(
                  width: 0,
                ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }
}
