import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hms_patient/app_helpers/assets/app_assets.dart';
import 'package:hms_patient/app_helpers/models/paitent_bookings_models.dart';
import 'package:hms_patient/app_helpers/network/api_base_helper.dart';
import 'package:hms_patient/app_helpers/network/snackbar_helper.dart';
import 'package:hms_patient/app_helpers/network/token_storage.dart';
import 'package:hms_patient/app_helpers/theme/app_colors.dart';
import 'package:hms_patient/app_helpers/theme/app_spacings.dart';
import 'package:hms_patient/app_helpers/theme/app_typography.dart';
import 'package:hms_patient/app_helpers/widgets/custom_app_bar.dart';
import 'package:hms_patient/presentation/bloc/my_bookings/my_booking_bloc.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../../app_helpers/network/app_url.dart';

class MyBooking extends StatefulWidget {
  const MyBooking({super.key});

  @override
  State<MyBooking> createState() => _MyBookingState();
}

class _MyBookingState extends State<MyBooking>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final MyBookingBloc _bloc;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _bloc = MyBookingBloc(api: context.read<ApiBaseHelper>());

    // Fetch bookings immediately on open.
    _bloc.add(const MyBookingFetch());

    // Fetch invoices lazily on first switch to Tab 1.
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    // Guard: fires on every animation tick — only act on settled tab.
    if (_tabController.indexIsChanging) return;

    if (_tabController.index == 1) {
      final inv = _bloc.state.invoices;
      if (inv is InvoiceSubInitial || inv is InvoiceSubFailure) {
        _bloc.add(const PatientInvoicesFetch());
      }
    }
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_onTabChanged)
      ..dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: CustomAppBar(
          leadingWidth: AppSpacing.value(context, 50),
          leading: Padding(
            padding: AppSpacing.only(
              context: context,
              left: 12.0,
              top: 8.0,
              bottom: 8.0,
            ),
            child: AppAssets.appIcon,
          ),
          titleWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Patient Dashboard',
                style: AppTypography.headlineSmall.semiBold
                    .withColor(AppColors.onPrimary)
                    .responsive(context),
              ),
              AppSpacing.h4(context),
              Text(
                'Monitor and manage all your hospital visits',
                style: AppTypography.labelMedium
                    .withColor(AppColors.onPrimary)
                    .responsive(context),
              ),
            ],
          ),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            unselectedLabelStyle: AppTypography.bodyMedium.bold
                .withColor(AppColors.onPrimary.withValues(alpha: 0.7))
                .responsive(context),
            labelStyle: AppTypography.bodyMedium.bold
                .withColor(AppColors.onPrimary)
                .responsive(context),
            tabs: const [
              Tab(text: 'Booking Details'),
              Tab(text: 'Invoice / Payment'),
            ],
            indicatorColor: AppColors.onPrimary,
          ),
        ),
        body: BlocListener<MyBookingBloc, MyBookingState>(
          // Only listen when a failure sub-state is newly emitted.
          listenWhen: (prev, curr) =>
              (curr.bookings is BookingSubFailure &&
                  prev.bookings != curr.bookings) ||
              (curr.invoices is InvoiceSubFailure &&
                  prev.invoices != curr.invoices),
          listener: (context, state) {
            if (state.bookings is BookingSubFailure) {
              Snackbar.fromApiError(
                context,
                (state.bookings as BookingSubFailure).error,
              );
            }
            if (state.invoices is InvoiceSubFailure) {
              Snackbar.fromApiError(
                context,
                (state.invoices as InvoiceSubFailure).error,
              );
            }
          },
          child: TabBarView(
            controller: _tabController,
            children: const [_BookingsTab(), _InvoicesTab()],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 1 — Bookings
// BlocSelector watches only state.bookings — invoice changes never rebuild this.
// ─────────────────────────────────────────────────────────────────────────────

class _BookingsTab extends StatelessWidget {
  const _BookingsTab();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MyBookingBloc, MyBookingState, BookingSubState>(
      selector: (state) => state.bookings,
      builder: (context, bookings) => switch (bookings) {
        BookingSubLoading() => const Center(child: CircularProgressIndicator()),
        BookingSubSuccess(:final data) when data.isEmpty => const Center(
          child: Text('No bookings found'),
        ),
        BookingSubSuccess(:final data) => ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: data.length,
          itemBuilder: (_, i) => DocumentCard(data: data[i]),
        ),
        BookingSubFailure() => _ErrorRetry(
          message: 'Failed to load bookings',
          onRetry: () =>
              context.read<MyBookingBloc>().add(const MyBookingFetch()),
        ),
        BookingSubInitial() => const SizedBox.shrink(),
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tab 2 — Invoices
// BlocSelector watches only state.invoices — booking changes never rebuild this.
// ─────────────────────────────────────────────────────────────────────────────

class _InvoicesTab extends StatelessWidget {
  const _InvoicesTab();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MyBookingBloc, MyBookingState, InvoiceSubState>(
      selector: (state) => state.invoices,
      builder: (context, invoices) => switch (invoices) {
        InvoiceSubLoading() => const Center(child: CircularProgressIndicator()),
        InvoiceSubSuccess(:final data) when data.isEmpty => const Center(
          child: Text('No invoices found'),
        ),
        InvoiceSubSuccess(:final data) => ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: data.length,
          itemBuilder: (_, i) => DocumentCard(data: data[i]),
        ),
        InvoiceSubFailure() => _ErrorRetry(
          message: 'Failed to load invoices',
          onRetry: () =>
              context.read<MyBookingBloc>().add(const PatientInvoicesFetch()),
        ),
        InvoiceSubInitial() => const Center(
          child: Text('Switch to this tab to load invoices'),
        ),
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared error retry widget
// ─────────────────────────────────────────────────────────────────────────────

class _ErrorRetry extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorRetry({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DocumentCard (unchanged from original)
// ─────────────────────────────────────────────────────────────────────────────

class DocumentCard extends StatelessWidget {
  final BookDetails data;
  const DocumentCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final status = data.status?.toLowerCase() ?? 'pending';
    final isConfirmed = status == 'confirmed';

    final statusColor = isConfirmed
        ? const Color(0xFF065F46)
        : const Color(0xFF92400E);
    final statusBg = isConfirmed
        ? const Color(0xFFD1FAE5)
        : const Color(0xFFFEF3C7);
    final statusBorder = isConfirmed
        ? const Color(0xFF6EE7B7)
        : const Color(0xFFFCD34D);
    final dotColor = isConfirmed
        ? const Color(0xFF10B981)
        : const Color(0xFFF59E0B);
    final headerBg = isConfirmed
        ? const Color(0xFFEAF3FB)
        : const Color(0xFFF9FAFB);
    final iconBg = isConfirmed
        ? const Color(0xFF185FA5)
        : const Color(0xFF888780);

    return Container(
      margin: AppSpacing.only(
        context: context,
        bottom: AppSpacing.value(context, AppSizeTokens.size3x),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppBorderRadiusTokens.circular5x,
        border: Border.all(color: AppColors.grey200, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              color: headerBg,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSizeTokens.size5x),
              ),
              border: Border(
                bottom: BorderSide(color: AppColors.grey200, width: 0.5),
              ),
            ),
            padding: AppSpacing.all(
              context,
              AppSpacing.value(context, AppSizeTokens.size3x),
            ),
            child: Row(
              children: [
                Container(
                  padding: AppSpacing.all(
                    context,
                    AppSpacing.value(context, AppSizeTokens.size2x),
                  ),
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.calendar_today_rounded,
                    color: AppColors.onPrimary,
                    size: AppSpacing.value(context, AppSizeTokens.size5x),
                  ),
                ),
                AppSpacing.w8(context),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BOOKING ID',
                        style: AppTypography.labelSmall.bold
                            .responsive(context)
                            .copyWith(color: iconBg, letterSpacing: 0.8),
                      ),
                      AppSpacing.h(context, 3),
                      Text(
                        data.id
                                ?.substring(
                                  data.id!.length >= 8
                                      ? data.id!.length - 8
                                      : 0,
                                )
                                .toUpperCase() ??
                            'N/A',
                        style: AppTypography.bodyLarge.semiBold.responsive(
                          context,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: AppSpacing.symmetric(
                    context: context,
                    horizontal: AppSpacing.value(context, AppSizeTokens.size2x),
                    vertical: AppSpacing.value(context, AppSizeTokens.size1x),
                  ),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: AppBorderRadiusTokens.circular5x,
                    border: Border.all(color: statusBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.circle,
                        color: dotColor,
                        size: AppSizeTokens.size2x,
                      ),
                      AppSpacing.w4(context),
                      Text(
                        data.status?.toUpperCase() ?? 'PENDING',
                        style: AppTypography.labelMedium
                            .responsive(context)
                            .semiBold
                            .withColor(statusColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Body
          Padding(
            padding: AppSpacing.all(context, AppPaddingTokens.padding3x),
            child: Column(
              children: [
                _InfoRow(
                  iconData: Icons.access_time_rounded,
                  iconColor: const Color(0xFF185FA5),
                  iconBg: const Color(0xFFE6F1FB),
                  label: 'OPD / IPD Admission Date',
                  value: data.opdDate != null
                      ? DateFormat('dd MMM yyyy').format(data.opdDate!)
                      : 'N/A',
                ),
                AppSpacing.h12(context),
                _InfoRow(
                  iconData: Icons.person_rounded,
                  iconColor: const Color(0xFF0F6E56),
                  iconBg: const Color(0xFFE1F5EE),
                  label: 'Consulting Doctor',
                  value:
                      'Dr. ${data.doctor?.firstName ?? ''} ${data.doctor?.lastName ?? ''}',
                  subtitle: data.time ?? '',
                ),
                AppSpacing.h12(context),
                _InfoRow(
                  iconData: Icons.local_hospital_rounded,
                  iconColor: const Color(0xFF534AB7),
                  iconBg: const Color(0xFFEEEDFE),
                  label: 'Department',
                  value: data.department ?? 'General',
                  subtitle: 'Main Wing',
                ),
              ],
            ),
          ),
          AppSpacing.divider(context, verticalSpace: 0.5),

          // Footer
          Padding(
            padding: AppSpacing.symmetric(
              context: context,
              horizontal: 15,
              vertical: 10,
            ),
            child: Row(
              children: [
                Text(
                  isConfirmed ? 'Last updated: today' : 'Awaiting confirmation',
                  style: AppTypography.labelMedium.responsive(context),
                ),
                const Spacer(),
                _ActionButton(
                  label: 'View',
                  icon: Icons.visibility_rounded,
                  outlined: true,
                  active: isConfirmed,
                  onTap: () => _showBookingDetails(context),
                ),
                AppSpacing.w4(context),
                _ActionButton(
                  label: 'Download',
                  icon: Icons.download_rounded,
                  outlined: false,
                  active: isConfirmed,
                  onTap: () => _downloadBooking(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showBookingDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Patient Booking Details',
              style: AppTypography.bodyLarge.bold.responsive(context),
            ),
            const SizedBox(height: 20),
            _DialogRow(
              label: 'Booking NO :',
              value:
                  data.id?.substring(data.id!.length - 8).toUpperCase() ??
                  'N/A',
            ),
            const SizedBox(height: 12),
            _DialogRow(
              label: 'TypeOPD/IPD Adm Date :',
              value: data.opdDate != null
                  ? DateFormat('M/d/yyyy').format(data.opdDate!)
                  : 'N/A',
            ),
            const SizedBox(height: 12),
            _DialogRow(label: 'Department :', value: data.department ?? 'IPD'),
            const SizedBox(height: 12),
            _DialogRow(
              label: 'Doctor :',
              value:
                  '${data.doctor?.firstName ?? ''} ${data.doctor?.lastName ?? ''}',
            ),
            const SizedBox(height: 12),
            _DialogRow(label: 'Status :', value: data.status ?? 'Scheduled'),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadBooking(BuildContext context) async {
    final bookingId = data.id;
    if (bookingId == null || bookingId.isEmpty) return;

    try {
      final tokenStorage = context.read<TokenStorage>();
      final token = await tokenStorage.getAccessToken();

      if (token == null || token.isEmpty) {
        if (context.mounted) {
          Snackbar.warning(
            context,
            title: 'Session Expired',
            message: 'Please log in again to download.',
          );
        }
        return;
      }

      final url = '${ApiUrls.baseUrl}/api/download/booking?id=$bookingId';
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/booking_$bookingId.pdf';

      if (context.mounted) {
        Snackbar.info(
          context,
          title: 'Downloading',
          message: 'Your booking report is being prepared…',
        );
      }

      await Dio().download(
        url,
        filePath,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          receiveTimeout: const Duration(minutes: 2),
        ),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        Snackbar.success(
          context,
          title: 'Download Complete',
          message: 'Booking report saved. Opening…',
        );
      }

      final result = await OpenFilex.open(filePath);

      if (result.type != ResultType.done && context.mounted) {
        Snackbar.warning(
          context,
          title: 'Cannot Open File',
          message: 'File saved but could not be opened: ${result.message}',
        );
      }
    } on DioException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        final message = switch (e.type) {
          DioExceptionType.connectionError => 'No internet connection.',
          DioExceptionType.receiveTimeout => 'Download timed out. Try again.',
          _ => e.response?.statusCode == 401
              ? 'Session expired. Please log in again.'
              : 'Download failed. Please try again.',
        };
        Snackbar.error(context, title: 'Download Failed', message: message);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        Snackbar.error(
          context,
          title: 'Download Failed',
          message: 'Something went wrong. Please try again.',
        );
      }
    }
  }
}
class _DialogRow extends StatelessWidget {
  final String label;
  final String value;
  const _DialogRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodyMedium.bold.responsive(context)),
        Text(value, style: AppTypography.bodyMedium.responsive(context)),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData iconData;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String value;
  final String? subtitle;

  const _InfoRow({
    required this.iconData,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.value,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: AppSpacing.all(context, 8),
          decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
          child: Icon(iconData, color: iconColor, size: 18),
        ),
        AppSpacing.w12(context),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.labelSmall
                    .responsive(context)
                    .withColor(AppColors.grey500),
              ),
              AppSpacing.h(context, 2),
              Text(
                value,
                style: AppTypography.bodyMedium.bold.responsive(context),
              ),
              if (subtitle != null && subtitle!.isNotEmpty)
                Text(
                  subtitle!,
                  style: AppTypography.labelSmall
                      .responsive(context)
                      .withColor(AppColors.grey400),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool outlined;
  final bool active;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.outlined,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active
        ? (outlined ? const Color(0xFF185FA5) : Colors.white)
        : AppColors.grey400;
    final bg = outlined
        ? Colors.white
        : (active ? const Color(0xFF185FA5) : AppColors.grey200);
    final border = outlined
        ? (active ? const Color(0xFF185FA5) : AppColors.grey300)
        : Colors.transparent;

    return InkWell(
      onTap: active ? onTap : null,
      child: Container(
        padding: AppSpacing.symmetric(
          context: context,
          horizontal: 12,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: border),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: color),
            AppSpacing.w4(context),
            Text(
              label,
              style: AppTypography.labelMedium.bold
                  .withColor(color)
                  .responsive(context),
            ),
          ],
        ),
      ),
    );
  }
}
