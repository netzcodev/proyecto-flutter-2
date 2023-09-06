import 'package:cars_app/features/people/people.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final personProvider = StateNotifierProvider.autoDispose
    .family<PersonNotifier, PersonState, int>((ref, personId) {
  final peopleRepository = ref.watch(peopleRepositoryProvider);
  return PersonNotifier(
    peopleRepository: peopleRepository,
    personId: personId,
  );
});

class PersonNotifier extends StateNotifier<PersonState> {
  final PeopleRepository peopleRepository;

  PersonNotifier({
    required this.peopleRepository,
    required int personId,
  }) : super(PersonState(id: personId)) {
    loadPerson();
  }

  Future<void> loadPerson() async {
    try {
      final person = await peopleRepository.getPeopleById(state.id);

      state = state.copyWith(
        isLoading: false,
        people: person,
      );
    } catch (e) {
      print(e);
    }
  }
}

class PersonState {
  final int id;
  final People? people;
  final bool isLoading;
  final bool isSaving;

  PersonState({
    required this.id,
    this.people,
    this.isLoading = true,
    this.isSaving = false,
  });

  PersonState copyWith({
    int? id,
    People? people,
    bool? isLoading,
    bool? isSaving,
  }) =>
      PersonState(
        id: id ?? this.id,
        people: people ?? this.people,
        isLoading: isLoading ?? this.isLoading,
        isSaving: isSaving ?? this.isSaving,
      );
}
