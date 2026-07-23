import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vm_storyboard/vm_storyboard.dart';

import '../document_demo_cubit.dart';

/// Structured-collection demo (Documents tab): add notes with an optional
/// TTL, delete (soft or physical per `DocumentDemoState.softDeleteEnabled`),
/// and purge tombstones.
class DocumentSection extends StatefulWidget {
  const DocumentSection({super.key});

  @override
  State<DocumentSection> createState() => _DocumentSectionState();
}

class _DocumentSectionState extends State<DocumentSection> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.vmTokens;
    final cubit = context.read<DocumentDemoCubit>();
    return BlocBuilder<DocumentDemoCubit, DocumentDemoState>(
      builder: (context, state) {
        return ListView(
          padding: EdgeInsets.all(tokens.spacing.md),
          children: [
            VmCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'New note',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(height: tokens.spacing.xs),
                  VmTextField(
                    controller: _textController,
                    label: 'text',
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: tokens.spacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: VmButton(
                          label: 'Add',
                          onPressed: () {
                            cubit.addNote(_textController.text);
                            _textController.clear();
                          },
                        ),
                      ),
                      SizedBox(width: tokens.spacing.sm),
                      Expanded(
                        child: VmButton(
                          label: 'Add (2s TTL)',
                          variant: VmButtonVariant.secondary,
                          onPressed: () {
                            cubit.addNote(
                              _textController.text,
                              ttl: const Duration(seconds: 2),
                            );
                            _textController.clear();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: tokens.spacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Notes', style: Theme.of(context).textTheme.titleSmall),
                if (state.softDeleteEnabled)
                  VmButton(
                    label: 'Purge tombstones',
                    variant: VmButtonVariant.text,
                    onPressed: cubit.purgeTombstones,
                  ),
              ],
            ),
            if (state.notes.isEmpty)
              VmEmptyView(
                message: state.softDeleteEnabled
                    ? 'No live notes. Soft-delete is on: deleted notes stay '
                          'as tombstones until purged.'
                    : 'No notes yet.',
              )
            else
              for (final note in state.notes)
                VmListItem(
                  title: Text(note.text),
                  subtitle: Text('key: ${note.id}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => cubit.deleteNote(note.id),
                  ),
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
