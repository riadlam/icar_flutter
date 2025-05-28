import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A customizable loading widget with text support
class LoadingWidget extends StatelessWidget {
  final String loadingText;
  final double size;
  final Color? color;
  final double textSize;
  final EdgeInsetsGeometry? margin;
  final bool showText;

  const LoadingWidget({
    Key? key,
    this.loadingText = 'Loading...',
    this.size = 40.0,
    this.color,
    this.textSize = 14.0,
    this.margin,
    this.showText = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: size,
              height: size,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  color ?? Theme.of(context).primaryColor,
                ),
                strokeWidth: 3.0,
              ),
            ),
            if (showText && loadingText.isNotEmpty) ...{
              const SizedBox(height: 12),
              Text(
                loadingText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: textSize.sp,
                  color: color ?? Theme.of(context).hintColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            },
          ],
        ),
      ),
    );
  }
}

/// A full-screen loading overlay with optional message and background
class FullScreenLoading extends StatelessWidget {
  final String message;
  final bool withScaffold;
  final Color? backgroundColor;
  final Color? textColor;
  final double indicatorSize;
  final double textSize;

  const FullScreenLoading({
    Key? key,
    this.message = 'Loading...',
    this.withScaffold = false,
    this.backgroundColor,
    this.textColor,
    this.indicatorSize = 40.0,
    this.textSize = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: indicatorSize,
            height: indicatorSize,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
              strokeWidth: 3.0,
            ),
          ),
          if (message.isNotEmpty) ...{
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: textColor ?? theme.textTheme.titleMedium?.color,
                  fontSize: textSize.sp,
                ),
              ),
            ),
          },
        ],
      ),
    );

    return withScaffold
        ? Scaffold(
            backgroundColor: 
                backgroundColor ?? theme.scaffoldBackgroundColor,
            body: content,
          )
        : Container(
            color: backgroundColor ?? Colors.black54,
            child: content,
          );
  }
}

/// Shows a modal loading dialog
Future<void> showLoadingDialog({
  required BuildContext context,
  String message = 'Loading...',
  bool barrierDismissible = false,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => barrierDismissible,
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).dialogBackgroundColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
