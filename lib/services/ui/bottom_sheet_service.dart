import 'package:flutter/material.dart';
import 'package:icar_instagram_ui/widgets/spare_parts/edit_post_bottom_sheet.dart';
import 'package:icar_instagram_ui/models/spare_parts_post.dart';

class BottomSheetService {
  static Future<void> showEditPostBottomSheet({
    required BuildContext context,
    required SparePartsPost post,
    required Function(SparePartsPost) onSave,
    required Function() onDelete,
  }) async {
    try {
      print('Attempting to show bottom sheet for post: ${post.id}');
      
      if (context.mounted) {
        await showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          isDismissible: true,
          enableDrag: true,
          backgroundColor: Colors.transparent,
          barrierColor: Colors.black54,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (BuildContext context) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: EditPostBottomSheet(
                  post: post,
                  onSave: onSave,
                  onDelete: onDelete,
                ),
              ),
            );
          },
        );
        print('Bottom sheet closed');
      } else {
        print('Context is not mounted, cannot show bottom sheet');
      }
    } catch (e, stackTrace) {
      print('Error showing bottom sheet: $e');
      print('Stack trace: $stackTrace');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to open editor')),
        );
      }
    }
  }
}
