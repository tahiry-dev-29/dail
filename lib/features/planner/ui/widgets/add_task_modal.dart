import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../../../shared/widgets/glass_container.dart';
import '../../providers/task_provider.dart';
import '../../../../core/theme/adaptive_colors.dart';

class AddTaskModal extends ConsumerStatefulWidget {
  const AddTaskModal({super.key});

  @override
  ConsumerState<AddTaskModal> createState() => _AddTaskModalState();
}

class _AddTaskModalState extends ConsumerState<AddTaskModal> {
  final _nameController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime? _selectedDeadline;
  bool _isFavorite = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null && mounted) {
        setState(() {
          _selectedDeadline = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _submit() {
    if (_nameController.text.trim().isEmpty) return;

    final timeStr =
        '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}';

    ref
        .read(taskProvider.notifier)
        .addTask(
          name: _nameController.text.trim(),
          time: timeStr,
          date: DateTime.now(),
          deadline: _selectedDeadline,
          isFavorite: _isFavorite,
        );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textPrimary = colors.textPrimary;
    final textSecondary = colors.textSecondary;
    final accent = colors.accent;
    final surface = colors.isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.05);
    final hintColor = colors.textSecondary.withValues(alpha: 0.5);

    return GlassContainer(
      borderRadius: 24,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Nouvelle Tache',
            style: TextStyle(
              color: textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Task Name
          TextField(
            controller: _nameController,
            style: TextStyle(color: textPrimary),
            decoration: InputDecoration(
              hintText: 'Nom de la tache',
              hintStyle: TextStyle(color: hintColor),
              filled: true,
              fillColor: surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Time Picker
          GestureDetector(
            onTap: _pickTime,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(FontAwesomeIcons.clock, color: accent, size: 16),
                  const SizedBox(width: 12),
                  Text(
                    _selectedTime.format(context),
                    style: TextStyle(color: textPrimary),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Deadline Picker
          GestureDetector(
            onTap: _pickDeadline,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.calendarCheck,
                    color: accent.withValues(alpha: 0.7),
                    size: 16,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _selectedDeadline != null
                        ? DateFormat('dd MMM, HH:mm').format(_selectedDeadline!)
                        : 'Ajouter une deadline',
                    style: TextStyle(
                      color: _selectedDeadline != null
                          ? textPrimary
                          : textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Favorite Toggle
          GestureDetector(
            onTap: () => setState(() => _isFavorite = !_isFavorite),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    _isFavorite
                        ? FontAwesomeIcons.solidHeart
                        : FontAwesomeIcons.heart,
                    color: _isFavorite ? Colors.redAccent : textSecondary,
                    size: 16,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _isFavorite ? 'Coup de cœur !' : 'Coup de cœur ?',
                    style: TextStyle(
                      color: _isFavorite ? Colors.redAccent : textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Submit Button
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: accent,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Ajouter',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
