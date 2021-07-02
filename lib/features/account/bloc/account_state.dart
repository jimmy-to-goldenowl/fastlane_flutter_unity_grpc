part of 'account_cubit.dart';

class AccountState extends Equatable {
  const AccountState({
    this.name = const Name.pure(),
    this.phone = const Phone.pure(),
    this.status = FormzStatus.pure,
    this.message,
  });

  final Name name;
  final Phone phone;
  final FormzStatus status;
  final String? message;

  @override
  List<Object> get props => [name, phone, status];

  AccountState copyWith({
    Name? name,
    Phone? phone,
    FormzStatus? status,
    String? message,
    LUser? user,
  }) {
    return AccountState(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
