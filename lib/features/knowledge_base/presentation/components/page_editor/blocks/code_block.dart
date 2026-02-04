import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/block_entity.dart';
import 'package:daily_os/features/knowledge_base/presentation/state/block_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';

class CodeBlock extends HookWidget {
  final BlockEntity block;

  const CodeBlock({super.key, required this.block});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final blockVM = sl<BlockViewModel>();
    final code = block.content['code'] as String? ?? '';
    final language = block.content['language'] as String? ?? 'dart';
    final isEditing = useState(false);
    final focusNode = useFocusNode();

    useEffect(() {
      focusNode.addListener(() {
        isEditing.value = focusNode.hasFocus;
      });
      return null;
    }, [focusNode]);

    return Container(
      decoration: BoxDecoration(
        color: colors.isDark
            ? const Color(0xFF282C34)
            : const Color(0xFFF6F8FA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.border),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                language,
                style: TextStyle(color: colors.textSecondary, fontSize: 12),
              ),
              Icon(Icons.copy, size: 14, color: colors.textSecondary),
            ],
          ),
          const SizedBox(height: 8),

          if (isEditing.value)
            TextFormField(
              focusNode: focusNode,
              initialValue: code,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: GoogleFonts.firaCode(
                color: colors.textPrimary,
                fontSize: 14,
                height: 1.5,
              ),
              maxLines: null,
              onChanged: (value) {
                blockVM.updateBlock(
                  block.copyWith(content: {...block.content, 'code': value}),
                );
              },
            )
          else
            GestureDetector(
              onTap: () {
                isEditing.value = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  focusNode.requestFocus();
                });
              },
              child: HighlightView(
                code.isEmpty ? '// Type code here...' : code,
                language: language,
                theme: colors.isDark ? atomOneDarkTheme : githubTheme,
                padding: EdgeInsets.zero,
                textStyle: GoogleFonts.firaCode(fontSize: 14, height: 1.5),
              ),
            ),
        ],
      ),
    );
  }
}
