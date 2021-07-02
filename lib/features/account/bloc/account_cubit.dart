import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:loveblocks/features/account/models/name.dart';
import 'package:loveblocks/features/account/models/phone.dart';
import 'package:loveblocks/models/user.dart';
import 'package:loveblocks/services/firestore_service.dart';
part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit(this.uid)
      : super(AccountState(
          name: Name.dirty(''),
          phone: Phone.dirty(''),
        ));
  final String uid;
  final FirestoreService _firestoreService = FirestoreService.instance;

  Future submit() async {
    if (!state.status.isValidated) {
      return;
    }
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    final user = LUser(id: uid, phoneNumber: state.phone.value, displayName: state.name.value);
    final result = await _firestoreService.addOrUpdateUser(user);
    if (result.isSuccess) {
      emit(state.copyWith(status: FormzStatus.submissionSuccess, user: result.data));
    } else {
      emit(state.copyWith(status: FormzStatus.submissionFailure, message: result.error));
    }
  }

  void nameChanged(String value) {
    final name = Name.dirty(value);
    emit(state.copyWith(name: name, status: Formz.validate([name, state.name])));
  }

  void phoneChanged(String value) {
    final phone = Phone.dirty(value);
    emit(state.copyWith(phone: phone, status: Formz.validate([phone, state.phone])));
  }
}
