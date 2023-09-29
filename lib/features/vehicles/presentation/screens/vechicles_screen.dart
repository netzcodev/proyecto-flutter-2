import 'package:cars_app/features/auth/presentation/providers/providers.dart';
import 'package:cars_app/features/shared/shared.dart';
import 'package:cars_app/features/vehicles/vehicles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

class VehiclesScreen extends ConsumerWidget {
  const VehiclesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scafoldKey = GlobalKey<ScaffoldState>();
    final userRole = ref.read(authProvider).user!.role;

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scafoldKey),
      appBar: AppBar(
        title: const Text('Vehiculos'),
        actions: [
          if (userRole == 'cliente')
            IconButton(
              onPressed: () {
                context.push('/notifications');
              },
              icon: const Icon(Icons.notifications_none_outlined),
            )
        ],
      ),
      body: const _VehiclesView(),
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

class _VehiclesView extends ConsumerStatefulWidget {
  const _VehiclesView();

  @override
  _VehiclesViewState createState() => _VehiclesViewState();
}

class _VehiclesViewState extends ConsumerState {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if ((scrollController.position.pixels + 400) >=
          scrollController.position.maxScrollExtent) {
        ref.read(vehiclesProvider.notifier).loadNextPage();
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
    final vehicleState = ref.watch(vehiclesProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: AlignedGridView.count(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        itemCount: vehicleState.vehicles.length,
        itemBuilder: (context, index) {
          final vehicle = vehicleState.vehicles[index];
          return GestureDetector(
            child: _VehicleCard(
              vehicle: vehicle,
              onDeleteCallback: (value) {
                ref.watch(vehiclesProvider.notifier).deleteVehicle(value!).then(
                  (value) {
                    if (!value) return;
                    showSnackbar(context);
                  },
                );
              },
            ),
            onTap: () => context.push('/vehicles/${vehicle.id}'),
          );
        },
      ),
    );
  }
}

class _VehicleCard extends ConsumerWidget {
  final Vehicle vehicle;
  final void Function(int?)? onDeleteCallback;

  const _VehicleCard({
    required this.vehicle,
    this.onDeleteCallback,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissions = ref
        .watch(authProvider)
        .user!
        .menu!
        .firstWhere((element) => element.menuName == 'Vehicles');
    return Container(
      width: 300, // Ancho de la tarjeta
      height: 70, // Alto de la tarjeta
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius:
            const BorderRadius.all(Radius.circular(10)), // Fondo amarillo
        border: Border.all(
          style: BorderStyle.solid,
          color: Colors.black, // Borde negro
          width: 2.0, // Ancho del borde
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 15),
          Center(
            child: Text(
              vehicle.plate,
              // ignore: prefer_const_constructors
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(),
          if (permissions.remove == 1)
            IconButton(
              onPressed: () {
                onDeleteCallback!(vehicle.id);
              },
              icon: const Icon(Icons.delete_outline_outlined),
            )
        ],
      ),
    );
  }
}
