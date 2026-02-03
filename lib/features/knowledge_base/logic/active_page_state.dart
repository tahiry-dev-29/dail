import 'package:daily_os/features/knowledge_base/domain/entities/page_entity.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// Current active page ID
final activePageIdSignal = signal<String?>(null);

/// State of the active page
final activePageSignal = signal<AsyncState<PageEntity?>>(AsyncLoading());
