import 'dart:io';

import 'package:daily_os/design_system/molecules/cards/glass_card.dart';
import 'package:daily_os/design_system/theme/app_theme.dart';
import 'package:daily_os/features/knowledge_base/domain/entities/block_entity.dart';
import 'package:daily_os/features/knowledge_base/logic/blocks_controller.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageBlock extends StatelessWidget {
  final BlockEntity block;

  const ImageBlock({super.key, required this.block});

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final xFile = await picker.pickImage(source: ImageSource.gallery);

    if (xFile != null) {
      // For local app, path works. For web/cloud, need upload.
      // Assuming local-first for now.
      BlockController.updateBlock(
        block.copyWith(content: {...block.content, 'url': xFile.path}),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final url = block.content['url'] as String?;
    final caption = block.content['caption'] as String?;

    if (url == null || url.isEmpty) {
      return GestureDetector(
        onTap: _pickImage,
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
      crossAxisAlignment: .start,
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
                onPressed: _pickImage,
                icon: const Icon(Icons.edit, size: 16),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black54,
                  foregroundColor: Colors.white,
                  padding: .zero,
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
                border: .none,
                isDense: true,
                contentPadding: .zero,
              ),
              style: TextStyle(color: colors.textSecondary, fontSize: 13),
              onChanged: (value) {
                BlockController.updateBlock(
                  block.copyWith(content: {...block.content, 'caption': value}),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildImage(String url, AdaptiveColors colors) {
    // Check if it's a local file or network
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
      errorBuilder: (_, _, _) => _buildError(colors),
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
