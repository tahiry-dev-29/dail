import 'package:daily_os/features/knowledge_base/domain/entities/block_entity.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// State for blocks of the currently active page
final blocksSignal = signal<AsyncState<List<BlockEntity>>>(AsyncLoading());
