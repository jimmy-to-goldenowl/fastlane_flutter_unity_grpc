import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:loveblocks/features/account/bloc/account_cubit.dart';
import 'package:loveblocks/features/account/models/name.dart';
import 'package:loveblocks/features/account/models/phone.dart';
import 'package:loveblocks/src/bloc/app_bloc/app_bloc.dart';
import 'package:loveblocks/src/dialogs/toast_wrapper.dart';
import 'package:loveblocks/src/widgets/buttons/app_button.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AccountCubit(context.read<AppBloc>().state.uid),
      child: Scaffold(
        body: BlocListener<AccountCubit, AccountState>(
          listener: (context, state) {
            if (state.status == FormzStatus.submissionFailure) {
              Toast.show(state.message ?? 'Update Failure');
            } else if (state.status == FormzStatus.submissionSuccess) {
              Toast.show(state.message ?? 'Update Success');
              Navigator.of(context).pop();
            }
          },
          child: buildBody(context),
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: SubmitButton(),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          NameInput(),
          PhoneInput(),
        ],
      ),
    );
  }
}

class NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountCubit, AccountState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return TextFormField(
          key: const Key('account_name_textField'),
          initialValue: state.name.value,
          onChanged: (value) => context.read<AccountCubit>().nameChanged(value),
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            labelText: 'Display name',
            helperText: '',
            errorText: state.name.error?.messageOf(context),
          ),
        );
      },
    );
  }
}

class PhoneInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountCubit, AccountState>(
      buildWhen: (previous, current) => previous.phone != current.phone,
      builder: (context, state) {
        return TextFormField(
          key: const Key('account_phone_textField'),
          initialValue: state.phone.value,
          onChanged: (value) => context.read<AccountCubit>().phoneChanged(value),
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Phone number',
            helperText: '',
            errorText: state.phone.error?.messageOf(context),
          ),
        );
      },
    );
  }
}

class SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountCubit, AccountState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.status.isValidated != current.status.isValidated,
      builder: (context, state) {
        return AppButton(
          key: const Key('account_submitButton'),
          onPressed: state.status.isValidated ? () => context.read<AccountCubit>().submit() : null,
          enabled: true,
          busy: state.status == FormzStatus.submissionInProgress,
          title: 'Submit',
        );
      },
    );
  }
}
