import 'package:flutter/material.dart';

class TypeBar extends StatelessWidget {
  final TextEditingController editingController;
  final Function submitCallback;

  const TypeBar(
      {super.key,
      required this.editingController,
      required this.submitCallback});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, bottom: 30),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Shadow color with opacity
            spreadRadius: 0, // Spread radius
            blurRadius: 10, // Blur radius
            offset: const Offset(
                0, 4), // changes position of shadow, x-axis and y-axis
          ),
        ],
      ),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: editingController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 1,
              decoration: const InputDecoration(
                fillColor: Colors.white,
                hintText: "Send a message",
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => submitCallback(),
          ),
        ],
      ),
    );
  }
}
