import 'package:cars_app/features/services/presentation/providers/providers.dart';
import 'package:cars_app/features/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  @override
  Widget build(BuildContext context) {
    final scafoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scafoldKey),
      appBar: AppBar(
        title: const Text('Vehiculos'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: const _ServicesView(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/vehicles/0');
        },
        label: const Text('vehiculo'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class _ServicesView extends ConsumerStatefulWidget {
  const _ServicesView();

  @override
  _ServicesViewState createState() => _ServicesViewState();
}

class _ServicesViewState extends ConsumerState {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if ((scrollController.position.pixels + 400) >=
          scrollController.position.maxScrollExtent) {
        ref.read(servicesProvider.notifier).loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Vehiculo Eliminado')));
  }

  @override
  Widget build(BuildContext context) {
    final serviceState = ref.watch(servicesProvider);

    return Column(
      children: serviceState.services.isEmpty
          ? []
          : serviceState.services.map((entry) {
              final day = DateTime.now();
              final serivces = serviceState.services;
              return Expanded(
                child: Column(
                  children: [
                    Text(
                      '${day.day}/${day.month}/${day.year}', // Mostrar la fecha del día
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    ListView.builder(
                      itemCount: serivces.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final service = serivces[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ListTile(
                            onTap: () => context.push('/services/:id'),
                            title: Text(
                              '${service.name} - ${service.duration}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            subtitle:
                                Text('Próximo Servicio: ${service.comingDate}'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
    );
  }
}
