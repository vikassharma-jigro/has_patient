import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hms_patient/app_helpers/network/api_base_helper.dart';
import 'package:hms_patient/app_helpers/network/app_url.dart';
import 'package:hms_patient/app_helpers/network/snackbar_helper.dart';
import 'package:hms_patient/app_helpers/network/token_storage.dart';
import 'package:hms_patient/app_helpers/theme/app_colors.dart';
import 'package:hms_patient/app_helpers/theme/app_spacings.dart';
import 'package:hms_patient/app_helpers/theme/app_typography.dart';
import 'package:hms_patient/app_helpers/widgets/app_button.dart';
import 'package:hms_patient/app_helpers/widgets/custom_app_bar.dart';
import 'package:hms_patient/app_helpers/widgets/custom_field.dart';
import 'package:hms_patient/presentation/bloc/labe_reports/lab_reports_bloc.dart';
import 'package:hms_patient/presentation/bloc/patient_dashboard/patient_dashboard_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class PatientDocumentsScreen extends StatefulWidget {
  const PatientDocumentsScreen({super.key});

  @override
  State<PatientDocumentsScreen> createState() => _PatientDocumentsScreenState();
}

class _PatientDocumentsScreenState extends State<PatientDocumentsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      final state = context.read<LabReportsBloc>().state;
      if (state is LabReportsSuccess) {
        final hasReachedMax = state.pagination.page != null &&
            state.pagination.pages != null &&
            state.pagination.page! >= state.pagination.pages!;

        if (!hasReachedMax) {
          context.read<LabReportsBloc>().add(const FetchLabReports(isRefresh: false));
        }
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _pickAndUpload(BuildContext context) async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      final filePath = result.files.single.path!;
      final fileName = result.files.single.name;

      if (!context.mounted) return;

      showDialog(
        context: context,
        builder: (dialogContext) {
          final nameController = TextEditingController(text: fileName);
          return AlertDialog(
            title: const Text('Upload Document'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomField(
                  hintText: '',
                  label: 'Document Name',
                  controller: nameController,
                ),
                AppSpacing.h16(context),
                Text('Selected File: $fileName', style: AppTypography.labelSmall),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final docName = nameController.text.trim();
                  if (docName.isNotEmpty) {
                    context.read<LabReportsBloc>().add(
                          UploadLabReport(
                            documentName: docName,
                            filePath: filePath,
                          ),
                        );
                    Navigator.pop(dialogContext);
                  } else {
                    Snackbar.warning(context, message: 'Please enter a document name');
                  }
                },
                child: const Text('Upload'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (context) => LabReportsBloc(api: ApiBaseHelper())
            ..add(const FetchLabReports(isRefresh: true)),
        ),
        BlocProvider(
          create: (context) => PatientDashboardBloc(api: ApiBaseHelper())
            ..add(const FetchPatientDashboard()),
        ),
      ],
      child: BlocConsumer<LabReportsBloc, LabReportsState>(
        listener: (context, state) {
          if (state is LabReportsFailure) {
            Snackbar.fromApiError(context, state.error);
          }
          if (state is UploadReportSuccess) {
            Snackbar.success(context, message: state.message);
          }
          if (state is UploadReportFailure) {
            Snackbar.fromApiError(context, state.error);
          }
        },
        builder: (context, state) {
          return Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: state is UploadReportLoading
                ? const FloatingActionButton(
                    onPressed: null,
                    backgroundColor: AppColors.primary,
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : AppButton(
                    margin: AppSpacing.all(context, AppPaddingTokens.padding2x),
                    icon: const Icon(Icons.upload_file),
                    onPressed: () => _pickAndUpload(context),
                    text: 'Upload Documents',
                  ),
            appBar: CustomAppBar(
              centerTitle: false,
              leading: Padding(
                padding: AppSpacing.only(
                  context: context,
                  left: 12.0,
                  top: 8.0,
                  bottom: 8.0,
                ),
                child: const CircleAvatar(
                  backgroundColor: AppColors.grey200,
                  child: Icon(Icons.person_rounded, color: AppColors.primary),
                ),
              ),
              backgroundColor: AppColors.onPrimary,
              leadingWidth: AppSpacing.value(context, 50),
              titleWidget: BlocBuilder<PatientDashboardBloc, PatientDashboardState>(
                builder: (context, dashState) {
                  if (dashState is PatientDashboardSuccess) {
                    final data = dashState.data;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.fullName,
                          style: AppTypography.headlineSmall.semiBold.responsive(context),
                        ),
                        AppSpacing.h4(context),
                        Text(
                          'P-ID :${data.userId ?? 'N/A'}',
                          style: AppTypography.labelLarge
                              .withColor(AppColors.primary)
                              .responsive(context),
                        ),
                      ],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Loading...',
                        style: AppTypography.headlineSmall.semiBold.responsive(context),
                      ),
                      AppSpacing.h4(context),
                      Text(
                        'P-ID :...',
                        style: AppTypography.labelLarge
                            .withColor(AppColors.primary)
                            .responsive(context),
                      ),
                    ],
                  );
                },
              ),
            ),
            body: Padding(
              padding: AppSpacing.all(context, AppPaddingTokens.padding2x),
              child: Column(
                children: [
                  CustomField(
                    hintText: 'Search Documents',
                    controller: TextEditingController(),
                  ),
                  AppSpacing.h16(context),
                  Expanded(
                    child: _buildBody(context, state),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, LabReportsState state) {
    if (state is LabReportsInitial || (state is LabReportsLoading)) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is LabReportsSuccess) {
      final documents = state.data;
      final hasReachedMax = state.pagination.page != null &&
          state.pagination.pages != null &&
          state.pagination.page! >= state.pagination.pages!;

      if (documents.isEmpty) {
        return const Center(child: Text('No documents found'));
      }

      return ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: hasReachedMax ? documents.length : documents.length + 1,
        itemBuilder: (context, index) {
          if (index >= documents.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            );
          }
          return DocumentListCard(data: documents[index]);
        },
      );
    }

    if (state is LabReportsFailure) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Error loading documents'),
            TextButton(
              onPressed: () => context.read<LabReportsBloc>().add(const FetchLabReports(isRefresh: true)),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    return const Center(child: Text('No documents available'));
  }
}

class DocumentListCard extends StatelessWidget {
  final dynamic data;

  const DocumentListCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final String docName = (data is Map) ? (data['documentName'] ?? 'Unnamed Document') : 'Unnamed Document';
    final String type = (data is Map) ? (data['type'] ?? 'Lab') : 'Lab';
    final String department = (data is Map) ? (data['department'] ?? 'General') : 'General';
    final String date = (data is Map) 
        ? (data['createdAt']?.toString().split(' ')[0] ?? 'N/A')
        : 'N/A';
    final String doctor = (data is Map) ? (data['doctorName'] ?? 'Staff') : 'Staff';

    return Container(
      margin: AppSpacing.only(
        context: context,
        bottom: AppSpacing.value(context, AppSizeTokens.size3x),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppBorderRadiusTokens.circular4x,
        border: Border.all(color: AppColors.grey200, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAECE7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.description_rounded,
                    color: Color(0xFFD85A30),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        docName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE6F1FB),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFFB5D4F4),
                              ),
                            ),
                            child: Text(
                              type,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0C447C),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            department,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 12,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          date,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                      Row(
                      children: [
                        _DocActionBtn(
                          icon: Icons.visibility_rounded,
                          filled: false,
                          onTap: () => _downloadAndOpen(context, data, open: true),
                        ),
                        const SizedBox(width: 6),
                        _DocActionBtn(
                          icon: Icons.download_rounded,
                          filled: true,
                          onTap: () => _downloadAndOpen(context, data),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 0.5,
            indent: 16,
            endIndent: 16,
            color: Colors.grey.shade200,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE1F5EE),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          _initials(doctor),
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F6E56),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                        children: [
                          const TextSpan(text: 'By '),
                          TextSpan(
                            text: doctor,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Text(
                  'PDF · 1 file',
                  style: TextStyle(fontSize: 11, color: Color(0xFFA1A1AA)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    if (name.isEmpty) return 'U';
    final parts = name.replaceAll('Dr.', '').trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}';
    }
    return parts[0][0];
  }

  Future<void> _downloadAndOpen(
    BuildContext context,
    dynamic data, {
    bool open = false,
  }) async {
    final String? docId = (data is Map) ? data['_id']?.toString() : null;
    final String docName =
        (data is Map) ? (data['documentName'] ?? 'document') : 'document';

    if (docId == null || docId.isEmpty) return;

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

      final url = '${ApiUrls.baseUrl}/api/download/report?id=$docId';
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$docName.pdf';

      if (context.mounted) {
        Snackbar.info(
          context,
          title: open ? 'Opening Document' : 'Downloading',
          message: 'Please wait...',
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
        if (!open) {
          Snackbar.success(
            context,
            title: 'Download Complete',
            message: 'Document saved successfully.',
          );
        }
      }

      if (open) {
        final result = await OpenFilex.open(filePath);
        if (result.type != ResultType.done && context.mounted) {
          Snackbar.warning(
            context,
            title: 'Cannot Open File',
            message: 'File saved but could not be opened: ${result.message}',
          );
        }
      }
    } on DioException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        final message =
            e.response?.statusCode == 401
                ? 'Session expired. Please log in again.'
                : 'Download failed. Please try again.';
        Snackbar.error(context, title: 'Error', message: message);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        Snackbar.error(context, title: 'Error', message: 'Something went wrong');
      }
    }
  }
}

class _DocActionBtn extends StatelessWidget {
  final IconData icon;
  final bool filled;
  final VoidCallback onTap;

  const _DocActionBtn({
    required this.icon,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: filled ? const Color(0xFF185FA5) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: filled ? Colors.transparent : Colors.grey.shade300,
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: filled ? Colors.white : Colors.grey.shade600,
        ),
      ),
    );
  }
}
