import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

class UserQuery extends StatelessWidget {
  final String text;

  const UserQuery({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(15),
          decoration: const BoxDecoration(
            color: AppTheme.sentTextColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 280,
            ),
            child: Text(
              text,
              style: const TextStyle(color: Colors.black, fontSize: 14),
              overflow: TextOverflow
                  .clip, // or use TextOverflow.ellipsis for ellipsis
            ),
          ),
        ),
      ],
    );
  }
}
