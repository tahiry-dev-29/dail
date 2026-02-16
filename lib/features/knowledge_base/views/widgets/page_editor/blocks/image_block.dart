import 'dart:io';

import 'package:daily_os/core/di/injection_container.dart';
import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/block_entity.dart';
import 'package:daily_os/features/knowledge_base/views/bloc/block_view_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageBlock extends StatelessWidget {
  final BlockEntity block;

  const ImageBlock({super.key, required this.block});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final blockVM = sl<BlockViewModel>();
    final url = block.content['url'] as String?;
    final caption = block.content['caption'] as String?;

    Future<void> pickImage() async {
      final picker = ImagePicker();
      final xFile = await picker.pickImage(source: ImageSource.gallery);

      if (xFile != null) {
        blockVM.updateBlock(
          block.copyWith(content: {...block.content, 'url': xFile.path}),
        );
      }
    }

    if (url == null || url.isEmpty) {
      return GestureDetector(
        onTap: pickImage,
        child: GlassCard(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.add_photo_alternate_outlined,
                  size: 40,
                  color: colors.textSecondary,
                ),
                const SizedBox(height: 8),
                Text(
                  'Add an image',
                  style: TextStyle(color: colors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildImage(url, colors),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                onPressed: pickImage,
                icon: const Icon(Icons.edit, size: 16),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black54,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(32, 32),
                ),
              ),
            ),
          ],
        ),
        if (caption != null || true)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextFormField(
              initialValue: caption,
              decoration: InputDecoration(
                hintText: 'Write a caption...',
                hintStyle: TextStyle(
                  color: colors.textSecondary.withValues(alpha: 0.5),
                  fontSize: 13,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: TextStyle(color: colors.textSecondary, fontSize: 13),
              onChanged: (value) {
                blockVM.updateBlock(
                  block.copyWith(content: {...block.content, 'caption': value}),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildImage(String url, AdaptiveColors colors) {
    final isLocal = !url.startsWith('http');
    if (isLocal) {
      return Image.file(
        File(url),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildError(colors),
      );
    }
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _buildError(colors),
    );
  }

  Widget _buildError(AdaptiveColors colors) {
    return Container(
      height: 200,
      color: colors.surfaceElevated,
      child: Center(
        child: Text(
          'Failed to load image',
          style: TextStyle(color: colors.textSecondary),
        ),
      ),
    );
  }
}
