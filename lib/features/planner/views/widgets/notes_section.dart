import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/planner/views/widgets/note_tile.dart';
import 'package:daily_os/features/planner/views/widgets/section_helpers.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

final _isNotesExpanded = signal(true);

/// Sliver section displaying notes for the current folder.
class NotesSection extends StatelessWidget {
  final AsyncState<List<PageEntity>> notesState;
  final void Function(String noteId) onNoteTap;
  final void Function(String noteId)? onFavorite;

  const NotesSection({
    super.key,
    required this.notesState,
    required this.onNoteTap,
    this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final isExpanded = _isNotesExpanded.watch(context);

    return notesState.map(
      data: (notes) => SliverMainAxisGroup(
        slivers: [
          SliverToBoxAdapter(
            child: SectionHeader(
              icon: Icons.description_outlined,
              title: 'NOTES',
              trailing: CountBadge(count: notes.length),
              isExpanded: isExpanded,
              onToggle: () => _isNotesExpanded.value = !_isNotesExpanded.value,
            ),
          ),
          if (isExpanded) ...[
            if (notes.isEmpty)
              const SliverToBoxAdapter(
                child: EmptySection(message: 'Aucune note dans ce dossier'),
              )
            else
              SliverList.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return NoteTile(
                    key: ValueKey(note.id),
                    note: note,
                    onTap: () => onNoteTap(note.id),
                    onFavorite: onFavorite != null
                        ? () => onFavorite!(note.id)
                        : null,
                  );
                },
              ),
          ],
        ],
      ),
      loading: () => const SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => SliverToBoxAdapter(child: Text('Error: $e')),
    );
  }
}
