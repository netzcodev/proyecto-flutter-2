import 'package:cars_app/features/people/people.dart';
import 'package:cars_app/features/permissions/domain/domain.dart';
import 'package:flutter/material.dart';

final Map<String, Color> colormap = {
  'admin': Colors.green.shade900,
  'cliente': Colors.yellow.shade900,
  'mecanico': Colors.blue.shade900,
  'gerente': Colors.purple.shade900
};

class CrudCard<T> extends StatelessWidget {
  final T entity;
  final IconData icon;
  final PermissionPartial options;
  final String role;
  final void Function(int?)? onDeleteCallback;

  const CrudCard({
    super.key,
    required this.entity,
    required this.icon,
    required this.options,
    required this.role,
    this.onDeleteCallback,
  });

  @override
  Widget build(BuildContext context) {
    Color? color;
    People? bagEntity;

    bagEntity = entity as People;
    color = colormap[bagEntity.role];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(color!.value),
          width: 4,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Icon(
            icon,
            color: color,
          ),
          const SizedBox(width: 40),
          Text(
            entity.toString(),
            style: TextStyle(
              color: color,
            ),
          ),
          const Spacer(),
          if (options.remove == 1)
            IconButton(
              onPressed: () {
                onDeleteCallback!(bagEntity!.id);
              },
              icon: const Icon(
                Icons.delete_outline_outlined,
              ),
              color: color,
            ),
        ],
      ),
    );
  }
}
