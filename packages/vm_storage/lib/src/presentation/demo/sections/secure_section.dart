import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

import '../secure_demo_cubit.dart';

/// Secure token store/read demo, reading `SecureDemoState`.
class SecureSection extends StatefulWidget {
  const SecureSection({super.key});

  @override
  State<SecureSection> createState() => _SecureSectionState();
}

class _SecureSectionState extends State<SecureSection> {
  final _tokenController = TextEditingController();

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.vmTokens;
    final cubit = context.read<SecureDemoCubit>();
    return BlocBuilder<SecureDemoCubit, SecureDemoState>(
      builder: (context, state) {
        return ListView(
          padding: EdgeInsets.all(tokens.spacing.md),
          children: [
            VmCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Access token',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(height: tokens.spacing.xs),
                  VmTextField(
                    controller: _tokenController,
                    label: 'access_token',
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: tokens.spacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: VmButton(
                          label: 'Save',
                          onPressed: () =>
                              cubit.saveToken(_tokenController.text),
                        ),
                      ),
                      SizedBox(width: tokens.spacing.sm),
                      Expanded(
                        child: VmButton(
                          label: 'Clear',
                          variant: VmButtonVariant.secondary,
                          onPressed: cubit.clearToken,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: tokens.spacing.md),
            if (state.token == null)
              const VmEmptyView(message: 'No secure token stored yet.')
            else
              VmListItem(
                title: const Text('access_token'),
                subtitle: Text(state.token!),
              ),
            if (state.errorMessage != null) ...[
              SizedBox(height: tokens.spacing.sm),
              VmErrorView(message: state.errorMessage!),
            ],
          ],
        );
      },
    );
  }
}
