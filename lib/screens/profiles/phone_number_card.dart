import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      ref.read(additionalPhonesProvider.notifier).loadPhones('1');
    });
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

                            await ref
                                .read(additionalPhonesProvider.notifier)
                                .loadPhones('1');

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
                      .deletePhone('1', phoneId);
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          phonesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Text('Error: $error'),
            data: (phones) {
              if (phones.isEmpty) {
                return const Text('');
              }
              return Column(
                children: phones
                    .map(
                      (phone) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.phone, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  phone.phoneNumber,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _showDeleteConfirmationDialog(
                                  context,
                                  ref,
                                  phone.id.toString(),
                                  phone.phoneNumber,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 20),
          Center(
            child: FilledButton(
              onPressed: () => _showAddPhoneDialog(context, ref),
              child: const Text('Add Phone Number'),
            ),
          ),
        ],
      ),
    );
  }
}
