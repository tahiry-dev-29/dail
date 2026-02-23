import 'package:signals_flutter/signals_flutter.dart';

/// Centralized UI state signals for the Knowledge Base Sidebar.
/// These states persist across rebuilds but reset if the app restarts.

final isTagsExpandedSignal = signal(false);
final isFoldersExpandedSignal = signal(true);
final isFavoritesExpandedSignal = signal(true);

final Map<String, Signal<bool>> _favFolderExpandStates = {};

/// Returns or creates a specific expand/collapse signal for a given folder in the Favorites section.
Signal<bool> getFavFolderExpandedSignal(String folderId) {
  return _favFolderExpandStates.putIfAbsent(folderId, () => signal(true));
}
