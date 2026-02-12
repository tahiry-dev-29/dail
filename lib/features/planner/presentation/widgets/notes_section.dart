import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:daily_os/features/planner/presentation/widgets/note_tile.dart';
import 'package:daily_os/features/planner/presentation/widgets/section_helpers.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// Sliver section displaying notes for the current folder.
class NotesSection extends StatelessWidget {
  final AsyncState<List<PageEntity>> notesState;
  final void Function(String noteId) onNoteTap;

  const NotesSection({
    super.key,
    required this.notesState,
    required this.onNoteTap,
  });

  @override
  Widget build(BuildContext context) {
    return notesState.map(
      data: (notes) => SliverMainAxisGroup(
        slivers: [
          SliverToBoxAdapter(
            child: SectionHeader(
              icon: Icons.description_outlined,
              title: 'NOTES',
              trailing: CountBadge(count: notes.length),
            ),
          ),
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
                );
              },
            ),
        ],
      ),
      loading: () => const SliverToBoxAdapter(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => SliverToBoxAdapter(child: Text('Error: $e')),
    );
  }
}
