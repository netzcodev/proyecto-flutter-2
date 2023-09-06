import 'package:cars_app/features/people/domain/domain.dart';
import 'package:cars_app/features/people/presentation/providers/providers.dart';
import 'package:cars_app/features/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

class PeopleScreen extends StatelessWidget {
  const PeopleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scafoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scafoldKey),
      appBar: AppBar(
        title: const Text('Personas'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: const _PeopleView(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('persona'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class _PeopleView extends ConsumerStatefulWidget {
  const _PeopleView();

  @override
  _PeopleViewState createState() => _PeopleViewState();
}

class _PeopleViewState extends ConsumerState {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if ((scrollController.position.pixels + 400) >=
          scrollController.position.maxScrollExtent) {
        ref.read(peopleProvider.notifier).loadNextPage();
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
    final peopleState = ref.watch(peopleProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: AlignedGridView.count(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        crossAxisCount: 1,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        itemCount: peopleState.people.length,
        itemBuilder: (context, index) {
          final person = peopleState.people[index];
          return GestureDetector(
            child: CrudCard<People>(
              entity: person,
              icon: const Icon(Icons.person_outline),
            ),
            onTap: () => context.push('/people/${person.id}'),
          );
        },
      ),
    );
  }
}
