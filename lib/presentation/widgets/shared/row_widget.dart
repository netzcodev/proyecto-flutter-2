import 'package:flutter/material.dart';

class TableRecord extends StatelessWidget {
  const TableRecord({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(width: 10),
          Icon(Icons.remember_me_outlined),
          SizedBox(width: 15),
          Text('Martin Martinez'),
          Spacer(),
          Positioned(
            right: 0,
            top: 0,
            child: Icon(Icons.delete_forever_outlined),
          ),
        ],
      ),
    );
  }
}
