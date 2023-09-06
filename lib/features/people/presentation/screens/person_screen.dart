import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonScreen extends ConsumerStatefulWidget {
  final int peopleId;

  const PersonScreen({
    super.key,
    required this.peopleId,
  });

  @override
  PersonScreenState createState() => PersonScreenState();
}

class PersonScreenState extends ConsumerState<PersonScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Persona'),
      ),
      body: Center(
        child: Text('${widget.peopleId}'),
      ),
    );
  }
}
