import 'package:cars_app/features/people/domain/domain.dart';
import 'package:cars_app/features/people/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final peopleProvider =
    StateNotifierProvider<PeopleNotifier, PeopleState>((ref) {
  final peopleRepository = ref.watch(peopleRepositoryProvider);
  return PeopleNotifier(peopleRepository: peopleRepository);
});

class PeopleNotifier extends StateNotifier<PeopleState> {
  final PeopleRepository peopleRepository;

  PeopleNotifier({
    required this.peopleRepository,
  }) : super(PeopleState()) {
    loadNextPage();
  }

  Future<bool> createOrUpdatePeople(Map<String, dynamic> peopleLike) async {
    try {
      final person = await peopleRepository.createUpdatePeople(peopleLike);
      final isPersonInList =
          state.people.any((element) => element.id == person.id);

      if (!isPersonInList) {
        state = state.copyWith(people: [...state.people, person]);
        return true;
      }

      state = state.copyWith(
        people: state.people
            .map((element) => (element.id == person.id) ? person : element)
            .toList(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deletePeople(int id) async {
    try {
      final person = await peopleRepository.deletePeople(id);
      final isPersonInList =
          state.people.any((element) => element.id == int.parse(person['id']));

      if (isPersonInList) {
        state.people
            .removeWhere((element) => element.id == int.parse(person['id']));
        state = state.copyWith(people: List<People>.from(state.people));
        return true;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  Future loadNextPage() async {
    if (state.isLoading || state.isLastPage) return;

    state = state.copyWith(
      isLoading: true,
    );

    final people = await peopleRepository.getPeopleByPage(
      limit: state.limit,
      offset: state.offset,
    );

    if (people.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        isLastPage: true,
      );
      return;
    }

    state = state.copyWith(
      isLastPage: false,
      isLoading: false,
      isFirstLoad: false,
      offset: state.offset + 10,
      people: [...state.people, ...people],
    );
  }

  Future firstLoad() async {
    if (state.isLoading || state.isLastPage || !state.isFirstLoad) return;

    state = state.copyWith(
      isLoading: true,
    );

    final people = await peopleRepository.getPeopleByPage(
      limit: state.limit,
      offset: state.offset,
    );

    if (people.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        isLastPage: true,
      );
      return;
    }

    state = state.copyWith(
      isLastPage: false,
      isLoading: false,
      offset: state.offset + 10,
      people: [...state.people, ...people],
    );
  }

  Future loadNextEmployeesPage() async {
    if (state.isLoading || state.isLastPage) return;

    state = state.copyWith(
      isLoading: true,
    );

    final people = await peopleRepository.getEmployeesByPage(
      limit: state.limit,
      offset: state.offset,
    );

    if (people.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        isLastPage: true,
      );
      return;
    }

    state = state.copyWith(
      isLastPage: false,
      isLoading: false,
      offset: state.offset + 10,
      people: [...state.people, ...people],
    );
  }

  Future loadNextCustomersPage() async {
    if (state.isLoading || state.isLastPage) return;

    state = state.copyWith(
      isLoading: true,
    );

    final people = await peopleRepository.getCustomersByPage(
      limit: state.limit,
      offset: state.offset,
    );

    if (people.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        isLastPage: true,
      );
      return;
    }

    state = state.copyWith(
      isLastPage: false,
      isLoading: false,
      offset: state.offset + 10,
      people: [...state.people, ...people],
    );
  }
}

class PeopleState {
  final bool isLastPage;
  final bool isFirstLoad;
  final int limit;
  final int offset;
  final bool isLoading;
  final List<People> people;

  PeopleState({
    this.isLastPage = false,
    this.isFirstLoad = true,
    this.limit = 10,
    this.offset = 0,
    this.isLoading = false,
    this.people = const [],
  });

  PeopleState copyWith({
    bool? isLastPage,
    bool? isFirstLoad,
    int? limit,
    int? offset,
    bool? isLoading,
    List<People>? people,
  }) =>
      PeopleState(
        isLastPage: isLastPage ?? this.isLastPage,
        isFirstLoad: isFirstLoad ?? this.isFirstLoad,
        limit: limit ?? this.limit,
        offset: offset ?? this.offset,
        isLoading: isLoading ?? this.isLoading,
        people: people ?? this.people,
      );
}
