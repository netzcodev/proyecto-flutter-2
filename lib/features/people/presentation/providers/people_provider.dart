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
      offset: state.offset + 10,
      people: [...state.people, ...people],
    );
  }
}

class PeopleState {
  final bool isLastPage;
  final int limit;
  final int offset;
  final bool isLoading;
  final List<People> people;

  PeopleState({
    this.isLastPage = false,
    this.limit = 10,
    this.offset = 0,
    this.isLoading = false,
    this.people = const [],
  });

  PeopleState copyWith({
    bool? isLastPage,
    int? limit,
    int? offset,
    bool? isLoading,
    List<People>? people,
  }) =>
      PeopleState(
        isLastPage: isLastPage ?? this.isLastPage,
        limit: limit ?? this.limit,
        offset: offset ?? this.offset,
        isLoading: isLoading ?? this.isLoading,
        people: people ?? this.people,
      );
}
