import 'package:cars_app/features/shared/shared.dart';
import 'package:cars_app/features/vehicles/vehicles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

class VehiclesScreen extends StatelessWidget {
  const VehiclesScreen({super.key});

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

  @override
  Widget build(BuildContext context) {
    final vehicleState = ref.watch(vehiclesProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: AlignedGridView.count(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        crossAxisCount: 1,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        itemCount: vehicleState.vehicles.length,
        itemBuilder: (context, index) {
          final vehicle = vehicleState.vehicles[index];
          return GestureDetector(
            child: _VehicleCard(
              plate: vehicle.plate,
            ),
            onTap: () => context.push('/vehicles/${vehicle.id}'),
          );
        },
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  final String plate;

  const _VehicleCard({required this.plate});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300, // Ancho de la tarjeta
      height: 150, // Alto de la tarjeta
      decoration: BoxDecoration(
        color: Colors.yellow, // Fondo amarillo
        border: Border.all(
          color: Colors.black, // Borde negro
          width: 2.0, // Ancho del borde
        ),
      ),
      child: Center(
        child: Text(
          plate,
          // ignore: prefer_const_constructors
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
