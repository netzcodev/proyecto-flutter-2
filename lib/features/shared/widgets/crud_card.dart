import 'package:cars_app/features/people/domain/domain.dart';
import 'package:flutter/material.dart';

class CrudCard<T> extends StatelessWidget {
  final T entity;
  final Icon icon;

  const CrudCard({
    super.key,
    required this.entity,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        icon,
        const SizedBox(width: 40),
        Text(
          entity.toString(),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.delete_outline_outlined,
          ),
        ),
      ],
    );
  }
}
