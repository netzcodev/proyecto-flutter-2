import 'package:cars_app/features/people/domain/domain.dart';
import 'package:cars_app/features/people/presentation/providers/providers.dart';
import 'package:cars_app/features/shared/shared.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

const userIdMap = {'admin': 1, 'cliente': 2, 'empleado': 3};

final personFormProvider = StateNotifierProvider.autoDispose
    .family<PersonFormNotifier, PersonFormState, People>((ref, person) {
  // final createUpdateCallback = ref.watch(peopleRepositoryProvider).createUpdatePeople;
  final createUpdateCallback =
      ref.watch(peopleProvider.notifier).createOrUpdatePeople;

  return PersonFormNotifier(
    person: person,
    onSubmitCallBack: createUpdateCallback,
  );
});

class PersonFormNotifier extends StateNotifier<PersonFormState> {
  final Future<bool> Function(Map<String, dynamic> personLike)?
      onSubmitCallBack;

  PersonFormNotifier({
    this.onSubmitCallBack,
    required People person,
  }) : super(
          PersonFormState(
            id: person.id,
            document: Document.dirty(person.document),
            phone: person.phone,
            email: Email.dirty(person.email),
            photo: person.photo,
            status: person.status,
            role: person.role,
            fullName: Name.dirty('${person.name} ${person.lastName}'),
          ),
        );

  Future<bool> onFormSubmit() async {
    _touchedEveryField();

    if (!state.isValidForm) return false;
    if (onSubmitCallBack == null) return false;

    final fullNameList = state.fullName.value.split(' ');
    final personLike = {
      'id': (state.id == 0) ? null : state.id,
      'document': state.document.value,
      'name': fullNameList[0],
      'lastName': fullNameList[1],
      'phone': state.phone,
      'email': state.email.value,
      'photo': state.photo,
      'status': state.status,
      'userId': userIdMap[state.role],
    };

    try {
      return await onSubmitCallBack!(personLike);
    } catch (e) {
      return false;
    }
  }

  void _touchedEveryField() {
    state = state.copyWith(
        isValidForm: Formz.validate([
      Document.dirty(state.document.value),
      Email.dirty(state.email.value),
      Name.dirty(state.fullName.value),
    ]));
  }

  void onDocumentChanged(int value) {
    state = state.copyWith(
      document: Document.dirty(value),
      isValidForm: Formz.validate([
        Document.dirty(value),
        Email.dirty(state.email.value),
        Name.dirty(state.fullName.value),
      ]),
    );
  }

  void onEmailChanged(String value) {
    state = state.copyWith(
      email: Email.dirty(value),
      isValidForm: Formz.validate([
        Document.dirty(state.document.value),
        Email.dirty(value),
        Name.dirty(state.fullName.value),
      ]),
    );
  }

  void onNameChanged(String value) {
    state = state.copyWith(
      fullName: Name.dirty(value),
      isValidForm: Formz.validate([
        Document.dirty(state.document.value),
        Email.dirty(state.email.value),
        Name.dirty(value),
      ]),
    );
  }

  void onPhoneChanged(String value) {
    state = state.copyWith(phone: value);
  }

  void onPhotoChanged(String value) {
    state = state.copyWith(photo: value);
  }

  void onStatusChanged(String value) {
    state = state.copyWith(status: value);
  }

  void onRoleChanged(String value) {
    state = state.copyWith(role: value);
  }
}

class PersonFormState {
  final bool isValidForm;
  final int? id;
  final Document document;
  final String phone;
  final Email email;
  final String photo;
  final String status;
  final String role;
  final Name fullName;

  PersonFormState(
      {this.isValidForm = false,
      this.id,
      this.document = const Document.dirty(0),
      this.phone = '',
      this.email = const Email.dirty(''),
      this.photo = '',
      this.status = 'A',
      this.role = '',
      this.fullName = const Name.dirty('')});

  PersonFormState copyWith({
    bool? isValidForm,
    int? id,
    Document? document,
    String? phone,
    Email? email,
    Password? password,
    String? photo,
    String? status,
    int? userId,
    String? role,
    Name? fullName,
  }) =>
      PersonFormState(
        isValidForm: isValidForm ?? this.isValidForm,
        id: id ?? this.id,
        document: document ?? this.document,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        photo: photo ?? this.photo,
        status: status ?? this.status,
        role: role ?? this.role,
        fullName: fullName ?? this.fullName,
      );
}
