import 'package:flutter/material.dart';
import 'package:hms_patient/app_helpers/network/api_error.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Hospital Snackbar Theme Tokens
// ─────────────────────────────────────────────────────────────────────────────

abstract class _SnackbarTheme {
  // Background — deep clinical tones
  static const Color successBg   = Color(0xFF0A6B4B); // surgical green
  static const Color errorBg     = Color(0xFFC0392B); // alert red
  static const Color warningBg   = Color(0xFFB7770D); // caution amber
  static const Color infoBg      = Color(0xFF1565C0); // medical blue
  static const Color networkBg   = Color(0xFF37474F); // offline slate

  // Left accent strip
  static const Color successStrip = Color(0xFF34D399);
  static const Color errorStrip   = Color(0xFFFF6B6B);
  static const Color warningStrip = Color(0xFFFFD166);
  static const Color infoStrip    = Color(0xFF64B5F6);
  static const Color networkStrip = Color(0xFF90A4AE);

  // Icon colors
  static const Color iconLight = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary   = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xCCFFFFFF); // 80% white

  static const Duration duration        = Duration(seconds: 4);
  static const Duration longDuration    = Duration(seconds: 6);
  static const double  borderRadius     = 12.0;
  static const double  stripWidth       = 4.0;
}

enum SnackbarType { success, error, warning, info, network }
class Snackbar {
  Snackbar._();

  static void fromApiError(
      BuildContext context,
      ApiError error, {
        String? actionLabel,
        VoidCallback? onAction,
      }) {
    final type    = _typeFromError(error);
    final title   = _titleFromError(error);
    final message = error.userMessage;

    _show(
      context,
      type: type,
      title: title,
      message: message,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  // ── Convenience constructors ───────────────────────────────────────────────

  static void success(
      BuildContext context, {
        required String message,
        String title = 'Success',
        String? actionLabel,
        VoidCallback? onAction,
      }) =>
      _show(
        context,
        type: SnackbarType.success,
        title: title,
        message: message,
        actionLabel: actionLabel,
        onAction: onAction,
      );

  static void error(
      BuildContext context, {
        required String message,
        String title = 'Error',
        String? actionLabel,
        VoidCallback? onAction,
      }) =>
      _show(
        context,
        type: SnackbarType.error,
        title: title,
        message: message,
        actionLabel: actionLabel,
        onAction: onAction,
        duration: _SnackbarTheme.longDuration,
      );

  static void warning(
      BuildContext context, {
        required String message,
        String title = 'Warning',
        String? actionLabel,
        VoidCallback? onAction,
      }) =>
      _show(
        context,
        type: SnackbarType.warning,
        title: title,
        message: message,
        actionLabel: actionLabel,
        onAction: onAction,
      );

  static void info(
      BuildContext context, {
        required String message,
        String title = 'Info',
        String? actionLabel,
        VoidCallback? onAction,
      }) =>
      _show(
        context,
        type: SnackbarType.info,
        title: title,
        message: message,
        actionLabel: actionLabel,
        onAction: onAction,
      );

  static void network(BuildContext context) => _show(
    context,
    type: SnackbarType.network,
    title: 'No Connection',
    message: 'Please check your internet and try again.',
    duration: _SnackbarTheme.longDuration,
  );

  static void showSuccess(BuildContext context, String message) => success(context, message: message);
  static void showError(BuildContext context, String message) => error(context, message: message);

  static void showLoading(BuildContext context, {String message = 'Please wait...'}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(minutes: 5), // Keep until hidden
        backgroundColor: _SnackbarTheme.infoBg,
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
            const SizedBox(width: 16),
            Text(message, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  // ── Internal ───────────────────────────────────────────────────────────────

  static void _show(
      BuildContext context, {
        required SnackbarType type,
        required String title,
        required String message,
        String? actionLabel,
        VoidCallback? onAction,
        Duration? duration,
      }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: duration ?? _SnackbarTheme.duration,
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: EdgeInsets.zero,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        content: _SnackbarContent(
          type: type,
          title: title,
          message: message,
          actionLabel: actionLabel,
          onAction: onAction,
          onDismiss: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );
  }

  // ── Error → Type mapping ───────────────────────────────────────────────────

  static SnackbarType _typeFromError(ApiError error) => switch (error.type) {
    ApiErrorType.network                          => SnackbarType.network,
    ApiErrorType.timeout                          => SnackbarType.network,
    ApiErrorType.unauthorized                     => SnackbarType.warning,
    ApiErrorType.forbidden                        => SnackbarType.warning,
    ApiErrorType.validation                       => SnackbarType.warning,
    ApiErrorType.notFound                         => SnackbarType.info,
    ApiErrorType.server                           => SnackbarType.error,
    ApiErrorType.cancelled                        => SnackbarType.info,
    ApiErrorType.parseError || ApiErrorType.unknown => SnackbarType.error,
  };

  static String _titleFromError(ApiError error) => switch (error.type) {
    ApiErrorType.network      => 'No Connection',
    ApiErrorType.timeout      => 'Request Timeout',
    ApiErrorType.unauthorized => 'Session Expired',
    ApiErrorType.forbidden    => 'Access Denied',
    ApiErrorType.validation   => 'Invalid Input',
    ApiErrorType.notFound     => 'Not Found',
    ApiErrorType.server       => 'Server Error',
    ApiErrorType.cancelled    => 'Cancelled',
    ApiErrorType.parseError   => 'Response Error',
    ApiErrorType.unknown      => 'Something Went Wrong',
  };
}

// ─────────────────────────────────────────────────────────────────────────────
// _SnackbarContent — The actual UI widget
// ─────────────────────────────────────────────────────────────────────────────

class _SnackbarContent extends StatelessWidget {
  final SnackbarType type;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback onDismiss;

  const _SnackbarContent({
    required this.type,
    required this.title,
    required this.message,
    required this.onDismiss,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final bg    = _bg(type);
    final strip = _strip(type);
    final icon  = _icon(type);

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(_SnackbarTheme.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:  0.18),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_SnackbarTheme.borderRadius),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Colored left strip ───────────────────────────
              Container(
                width: _SnackbarTheme.stripWidth,
                color: strip,
              ),

              // ── Icon ────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                child: Icon(icon, color: _SnackbarTheme.iconLight, size: 22),
              ),

              // ── Text content ─────────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: _SnackbarTheme.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        message,
                        style: const TextStyle(
                          color: _SnackbarTheme.textSecondary,
                          fontSize: 12.5,
                          height: 1.4,
                        ),
                      ),
                      if (actionLabel != null) ...[
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            onAction?.call();
                            onDismiss();
                          },
                          child: Text(
                            actionLabel!.toUpperCase(),
                            style: TextStyle(
                              color: _strip(type),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // ── Dismiss button ───────────────────────────────
              IconButton(
                onPressed: onDismiss,
                icon: const Icon(Icons.close_rounded, size: 16),
                color: _SnackbarTheme.textSecondary,
                padding: const EdgeInsets.fromLTRB(0, 8, 12, 8),
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Theme helpers ──────────────────────────────────────────────────────────

  Color _bg(SnackbarType t) => switch (t) {
    SnackbarType.success => _SnackbarTheme.successBg,
    SnackbarType.error   => _SnackbarTheme.errorBg,
    SnackbarType.warning => _SnackbarTheme.warningBg,
    SnackbarType.info    => _SnackbarTheme.infoBg,
    SnackbarType.network => _SnackbarTheme.networkBg,
  };

  Color _strip(SnackbarType t) => switch (t) {
    SnackbarType.success => _SnackbarTheme.successStrip,
    SnackbarType.error   => _SnackbarTheme.errorStrip,
    SnackbarType.warning => _SnackbarTheme.warningStrip,
    SnackbarType.info    => _SnackbarTheme.infoStrip,
    SnackbarType.network => _SnackbarTheme.networkStrip,
  };

  IconData _icon(SnackbarType t) => switch (t) {
    SnackbarType.success => Icons.check_circle_outline_rounded,
    SnackbarType.error   => Icons.error_outline_rounded,
    SnackbarType.warning => Icons.warning_amber_rounded,
    SnackbarType.info    => Icons.info_outline_rounded,
    SnackbarType.network => Icons.wifi_off_rounded,
  };
}