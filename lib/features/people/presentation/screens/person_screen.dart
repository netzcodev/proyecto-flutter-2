import 'package:cars_app/features/people/people.dart';
import 'package:cars_app/features/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonScreen extends ConsumerWidget {
  final int peopleId;
  const PersonScreen({
    super.key,
    required this.peopleId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personState = ref.watch(personProvider(peopleId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Persona'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.supervised_user_circle_outlined),
          )
        ],
      ),
      body: personState.isLoading
          ? const FullScreenLoader()
          : _PersonView(person: personState.people!),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.save_outlined),
      ),
    );
  }
}

class _PersonView extends StatelessWidget {
  final People person;

  const _PersonView({required this.person});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return ListView(
      children: [
        const SizedBox(
          height: 250,
          width: 600,
          // child: _ImageGallery(images: person.images),
        ),
        const SizedBox(height: 10),
        // Center(child: Text(person.title, style: textStyles.titleSmall)),
        const SizedBox(height: 10),
        _PersonInformation(person: person),
      ],
    );
  }
}

class _PersonInformation extends ConsumerWidget {
  final People person;
  const _PersonInformation({required this.person});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Generales'),
          const SizedBox(height: 15),
          CustomFormField(
            isTopField: true,
            label: 'Nombre',
            initialValue: '${person.name} ${person.lastName}',
          ),
          CustomFormField(
            label: 'Documento',
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
            initialValue: person.document.toString(),
          ),
          CustomFormField(
            isBottomField: true,
            label: 'Teléfono',
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
            initialValue: person.phone,
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}

class _ImageGallery extends StatelessWidget {
  final List<String> images;
  const _ImageGallery({required this.images});

  @override
  Widget build(BuildContext context) {
    return PageView(
      scrollDirection: Axis.horizontal,
      controller: PageController(viewportFraction: 0.7),
      children: images.isEmpty
          ? [
              ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: Image.asset('assets/images/no-image.jpg',
                      fit: BoxFit.cover))
            ]
          : images.map((e) {
              return ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Image.network(
                  e,
                  fit: BoxFit.cover,
                ),
              );
            }).toList(),
    );
  }
}
