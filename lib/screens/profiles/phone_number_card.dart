import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icar_instagram_ui/constants/app_colors.dart';
import 'package:icar_instagram_ui/providers/additional_phones_provider.dart';
import 'package:icar_instagram_ui/providers/phone_number_provider.dart';

class PhoneNumberCard extends ConsumerStatefulWidget {
  const PhoneNumberCard({Key? key}) : super(key: key);

  @override
  ConsumerState<PhoneNumberCard> createState() => _PhoneNumberCardState();
}

class _PhoneNumberCardState extends ConsumerState<PhoneNumberCard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPhones();
    });
  }

  Future<void> _loadPhones() async {
    try {
      await ref.read(additionalPhonesProvider.notifier).loadPhones('');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load phone numbers: $e')),
        );
      }
    }
  }

  Future<void> _showAddPhoneDialog(BuildContext context, WidgetRef ref) {
    final phoneController = TextEditingController();
    bool isLoading = false;

    return showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Phone Number'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: CircularProgressIndicator(),
                    )
                  else
                    TextField(
                      controller: phoneController,
                      enabled: !isLoading,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        hintText: 'Enter phone number',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          final phoneNumber = phoneController.text.trim();
                          if (phoneNumber.isEmpty) return;

                          setState(() => isLoading = true);

                          try {
                            await ref
                                .read(phoneNumberProvider.notifier)
                                .addPhoneNumber(phoneNumber);

                            await _loadPhones();

                            if (context.mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Phone number added successfully')),
                              );
                            }
                          } catch (e) {
                            setState(() => isLoading = false);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Failed to add phone number: $e')),
                              );
                            }
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showDeleteConfirmationDialog(
    BuildContext context,
    WidgetRef ref,
    String phoneId,
    String phoneNumber,
  ) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Phone Number'),
          content: Text('Are you sure you want to delete $phoneNumber?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await ref
                      .read(additionalPhonesProvider.notifier)
                      .deletePhone('', phoneId);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Phone number deleted successfully')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Failed to delete phone number: $e')),
                    );
                  }
                }
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final phonesAsync = ref.watch(additionalPhonesProvider);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        phonesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Text('Error: $error'),
          data: (phones) {
            if (phones.isEmpty) {
              return const SizedBox.shrink();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ...phones.map(
                  (phone) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        const SizedBox(width: 4),
                        Icon(Icons.phone, size: 20,),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            phone.phoneNumber,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline, size: 22, color: Colors.red),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => _showDeleteConfirmationDialog(
                            context,
                            ref,
                            phone.id,
                            phone.phoneNumber,
                          ),
                        ),
                      ],
                    ),
                  ),
                ).toList(),
              ],
            );
          },
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
          onPressed: () => _showAddPhoneDialog(context, ref),
          icon: const Icon(Icons.add, size: 20),
          label: const Text('Add Another Number'),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.loginbg, // ✅ Green background
            foregroundColor: Colors.white, // Optional: white text/icon
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        ),
      ],
    );
  }
}
