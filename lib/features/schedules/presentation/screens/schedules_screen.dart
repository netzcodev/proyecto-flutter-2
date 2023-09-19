import 'package:cars_app/features/shared/shared.dart';
import 'package:flutter/material.dart';

class SchedulesScreen extends StatelessWidget {
  const SchedulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        title: const Text('Citas'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: const _SchedulesView(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Cita'),
        icon: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}

class _SchedulesView extends StatelessWidget {
  const _SchedulesView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Eres genial!'));
  }
}
