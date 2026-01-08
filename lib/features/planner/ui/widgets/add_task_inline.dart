import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../../providers/task_provider.dart';
import '../../../calendar/providers/calendar_provider.dart';

// Signal to control visibility of add task input
final isAddTaskVisible = signal(false);

class AddTaskInline extends ConsumerStatefulWidget {
  const AddTaskInline({super.key});

  @override
  ConsumerState<AddTaskInline> createState() => _AddTaskInlineState();
}

class _AddTaskInlineState extends ConsumerState<AddTaskInline> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  TimeOfDay? _selectedTime;
  DateTime? _selectedDeadline;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    // Listen to focus changes to collapse when unfocused
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && _controller.text.isEmpty) {
      // Collapse if unfocused and empty
      isAddTaskVisible.value = false;
      setState(() {
        _selectedTime = null;
        _selectedDeadline = null;
        _isFavorite = false;
      });
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null && mounted) {
      setState(() => _selectedTime = time);
    }
  }

  Future<void> _pickDeadline() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null && mounted) {
        setState(() {
          _selectedDeadline = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _saveTask() {
    final name = _controller.text.trim();
    if (name.isEmpty) return;

    final selectedDate = calendarState.selectedDate.value;
    final timeStr = _selectedTime != null
        ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
        : '00:00';

    ref
        .read(taskProvider.notifier)
        .addTask(
          name: name,
          time: timeStr,
          date: selectedDate,
          deadline: _selectedDeadline,
          isFavorite: _isFavorite,
        );

    // Reset and hide
    _controller.clear();
    setState(() {
      _selectedTime = null;
      _selectedDeadline = null;
      _isFavorite = false;
    });
    _focusNode.unfocus();
    isAddTaskVisible.value = false;
  }

  @override
  Widget build(BuildContext context) {
    final isVisible = isAddTaskVisible.watch(context);

    if (!isVisible) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Input Row
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Nouvelle Tâche',
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onSubmitted: (_) => _saveTask(),
                ),
              ),
              GestureDetector(
                onTap: _saveTask,
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),

          // Icons Row
          const SizedBox(height: 12),
          Row(
            children: [
              // Details (placeholder)
              _buildIconButton(
                icon: FontAwesomeIcons.bars,
                isActive: false,
                onTap: () {},
              ),
              const SizedBox(width: 16),
              // Time
              _buildIconButton(
                icon: FontAwesomeIcons.clock,
                isActive: _selectedTime != null,
                label: _selectedTime != null
                    ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
                    : null,
                onTap: _pickTime,
              ),
              const SizedBox(width: 16),
              // Deadline
              _buildIconButton(
                icon: FontAwesomeIcons.calendarCheck,
                isActive: _selectedDeadline != null,
                label: _selectedDeadline != null
                    ? DateFormat('dd/MM').format(_selectedDeadline!)
                    : null,
                onTap: _pickDeadline,
              ),
              const SizedBox(width: 16),
              // Favorite
              _buildIconButton(
                icon: _isFavorite
                    ? FontAwesomeIcons.solidStar
                    : FontAwesomeIcons.star,
                isActive: _isFavorite,
                activeColor: Colors.amber,
                onTap: () => setState(() => _isFavorite = !_isFavorite),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
    String? label,
    Color? activeColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: isActive
                ? (activeColor ?? Colors.blueAccent)
                : Colors.white38,
          ),
          if (label != null) ...[
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: activeColor ?? Colors.blueAccent,
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
