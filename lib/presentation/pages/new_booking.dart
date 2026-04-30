import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hms_patient/app_helpers/network/snackbar_helper.dart';
import 'package:hms_patient/app_helpers/widgets/custom_app_bar.dart';
import 'package:hms_patient/app_helpers/theme/app_colors.dart';
import 'package:hms_patient/app_helpers/theme/app_spacings.dart';
import 'package:hms_patient/app_helpers/theme/app_typography.dart';
import 'package:hms_patient/app_helpers/network/app_url.dart';
import 'package:hms_patient/presentation/bloc/newBooking/new_booking_bloc.dart';
import 'package:hms_patient/app_helpers/models/doctor_availability_response_model.dart' as availability;
import 'package:hms_patient/app_helpers/models/doctors_avaliablity_model.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int selectedDeptIndex = 0;
  int? selectedDoctorIndex;
  int? selectedDateIndex;
  int? selectedTimeIndex;
  final ScrollController _scrollController = ScrollController();

  final List<String> departments = [
    "All",
    "Cardiology",
    "Neurology",
    "Orthopedics",
    "General Medicine",
    "eye",
  ];

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
      context.read<NewBookingBloc>().add(const FetchDoctors(isRefresh: false));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 900;

    return BlocProvider<NewBookingBloc>(
      create: (context) => NewBookingBloc()..add(const FetchDoctors()),
      lazy: false,
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.onPrimary,
            appBar: CustomAppBar(
              title: "New Booking",
              showBackButton: false,
              centerTitle: false,
            ),
            body: BlocConsumer<NewBookingBloc, NewBookingState>(
              listener: (context, state) {
                if (state is FetchDoctorsFailure) {
                  Snackbar.fromApiError(context, state.error);
                }
                if (state is CreateAppointmentFailure) {
                  Snackbar.fromApiError(context, state.error);
                }
                if (state is CreateAppointmentSuccess) {
                  _showConfirmationDialog(state.appointmentID);
                }
              },
              builder: (context, state) {
                if (state is NewBookingLoading || state is NewBookingInitial) {
                  return const Center(child: CircularProgressIndicator());
                }

                List<DoctorDetails> doctors = [];
                Pagination pagination = Pagination();
                availability.AvailabilityData? selectedDoctorAvailability;
                bool isFetchingAvailability = false;
                bool isCreatingAppointment = state is CreateAppointmentLoading;

                if (state is FetchDoctorsSuccess) {
                  doctors = state.doctors;
                  pagination = state.pagination;
                  selectedDoctorAvailability = state.selectedDoctorAvailability;
                  isFetchingAvailability = state.isFetchingAvailability;
                } else if (state is CreateAppointmentLoading) {
                  doctors = state.doctors;
                  pagination = state.pagination;
                  selectedDoctorAvailability = state.selectedDoctorAvailability;
                } else if (state is CreateAppointmentSuccess) {
                  doctors = state.doctors;
                  pagination = state.pagination;
                  selectedDoctorAvailability = state.selectedDoctorAvailability;
                } else if (state is CreateAppointmentFailure) {
                  doctors = state.doctors;
                  pagination = state.pagination;
                  selectedDoctorAvailability = state.selectedDoctorAvailability;
                }

                if (doctors.isNotEmpty) {
                  final doctorsToShow = _getFilteredDoctors(doctors);
                  final hasReachedMax = pagination.totalPages != null &&
                      int.tryParse(pagination.page ?? '1')! >= pagination.totalPages!;

                  return Stack(
                    children: [
                      Padding(
                        padding: AppSpacing.all(context, AppPaddingTokens.padding5x),
                        child: isTablet
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: leftSection(context, doctorsToShow, hasReachedMax),
                                  ),
                                  AppSpacing.w32(context),
                                  Expanded(
                                    flex: 5,
                                    child: rightSection(context, doctorsToShow, state, selectedDoctorAvailability, isFetchingAvailability),
                                  ),
                                ],
                              )
                            : SingleChildScrollView(
                                controller: _scrollController,
                                child: Column(
                                  children: [
                                    leftSection(context, doctorsToShow, hasReachedMax),
                                    AppSpacing.h32(context),
                                    rightSection(context, doctorsToShow, state, selectedDoctorAvailability, isFetchingAvailability),
                                  ],
                                ),
                              ),
                      ),
                      if (isCreatingAppointment)
                        Container(
                          color: Colors.black26,
                          child: const Center(child: CircularProgressIndicator()),
                        ),
                    ],
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          );
        }
      ),
    );
  }

  List<DoctorDetails> _getFilteredDoctors(List<DoctorDetails> doctors) {
    if (selectedDeptIndex == 0) return doctors;
    final dept = departments[selectedDeptIndex];
    return doctors.where((doc) => doc.primarySpecialization == dept).toList();
  }

  Widget leftSection(BuildContext context, List<DoctorDetails> doctors, bool hasReachedMax) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Step 1: Select Department",
          style: AppTypography.titleLarge.bold.withColor(AppColors.grey900),
        ),
        AppSpacing.h16(context),
        SizedBox(
          height: 50.r(context),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: departments.length,
            itemBuilder: (context, index) {
              final isSelected = selectedDeptIndex == index;
              return Padding(
                padding: AppSpacing.only(
                  context: context,
                  right: AppSpacingTokens.spacing3x,
                ),
                child: ChoiceChip(
                  label: Text(departments[index]),
                  selected: isSelected,
                  onSelected: (val) {
                    setState(() {
                      selectedDeptIndex = index;
                      selectedDoctorIndex = null;
                      selectedDateIndex = null;
                      selectedTimeIndex = null;
                    });
                  },
                  selectedColor: AppColors.primary,
                  backgroundColor: Colors.white,
                  labelStyle: AppTypography.bodyMedium.copyWith(
                    color: isSelected ? Colors.white : AppColors.grey600,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppBorderRadiusTokens.circular8x,
                    side: BorderSide(
                      color: isSelected ? Colors.transparent : AppColors.grey300,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        AppSpacing.h32(context),
        Text(
          "Step 2: Choose Doctor",
          style: AppTypography.titleLarge.bold.withColor(AppColors.grey900),
        ),
        AppSpacing.h16(context),
        TextField(
          onChanged: (val) {
            // Implement search if needed
          },
          decoration: InputDecoration(
            hintText: "Search by doctor",
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: AppBorderRadiusTokens.circular3x,
              borderSide: const BorderSide(color: AppColors.grey200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppBorderRadiusTokens.circular3x,
              borderSide: const BorderSide(color: AppColors.grey200),
            ),
          ),
        ),
        AppSpacing.h20(context),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: hasReachedMax ? doctors.length : doctors.length + 1,
          itemBuilder: (context, index) {
            if (index >= doctors.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            final doc = doctors[index];
            final isSelected = selectedDoctorIndex == index;
            final imageUrl = doc.documents?.photo?.isNotEmpty == true
                ? "${ApiUrls.baseUrl}/${doc.documents!.photo!.first.replaceAll('\\', '/')}"
                : "https://via.placeholder.com/150";

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedDoctorIndex = index;
                  selectedDateIndex = null;
                  selectedTimeIndex = null;
                });
                context.read<NewBookingBloc>().add(SelectDoctor(doc.id!));
              },
              child: Container(
                margin: AppSpacing.only(
                  context: context,
                  bottom: AppSpacingTokens.spacing4x,
                ),
                padding: AppSpacing.all(context, AppPaddingTokens.padding4x),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppBorderRadiusTokens.circular4x,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow: const [AppColors.shellCardShadow],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35.r(context),
                      backgroundImage: NetworkImage(imageUrl),
                    ),
                    AppSpacing.w16(context),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${doc.firstName ?? ""} ${doc.lastName ?? ""}",
                              style: AppTypography.bodyLarge.bold),
                          Text(
                            doc.primarySpecialization ?? "General",
                            style: AppTypography.bodySmall.withColor(AppColors.grey600),
                          ),
                          Text(
                            doc.hospitalId?.hospitalName ?? "Main Wing",
                            style: AppTypography.labelSmall.withColor(AppColors.grey400),
                          ),
                          AppSpacing.h8(context),
                          Row(
                            children: [
                              const Icon(Icons.star, color: AppColors.goldenColor, size: 16),
                              Text(" 4.8 (100)",
                                  style: AppTypography.labelSmall.withColor(AppColors.textPrimary)),
                              const Spacer(),
                              Text(
                                "₹ ${doc.consultationFee ?? 0}",
                                style: AppTypography.bodyMedium.bold.withColor(AppColors.primary),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget rightSection(
    BuildContext context,
    List<DoctorDetails> doctors,
    NewBookingState state,
    availability.AvailabilityData? selectedDoctorAvailability,
    bool isFetchingAvailability,
  ) {
    if (selectedDoctorIndex == null || selectedDoctorIndex! >= doctors.length) {
      return _buildPlaceholder(context);
    }

    final doc = doctors[selectedDoctorIndex!];
    final imageUrl = doc.documents?.photo?.isNotEmpty == true
        ? "${ApiUrls.baseUrl}/${doc.documents!.photo!.first.replaceAll('\\', '/')}"
        : "https://via.placeholder.com/150";

    if (isFetchingAvailability) {
      return const Center(child: CircularProgressIndicator());
    }

    final availabilityData = selectedDoctorAvailability;
    if (availabilityData == null) {
      return _buildPlaceholder(context, message: "Could not load doctor's availability.");
    }

    final availableDates = availabilityData.availableDays ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Step 3: Book Appointment",
          style: AppTypography.titleLarge.bold.withColor(AppColors.grey900),
        ),
        AppSpacing.h16(context),
        Container(
          padding: AppSpacing.all(context, AppPaddingTokens.padding5x),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppBorderRadiusTokens.circular4x,
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: AppBorderRadiusTokens.circular3x,
                    child: Image.network(
                      imageUrl,
                      width: 80.r(context),
                      height: 80.r(context),
                      fit: BoxFit.cover,
                    ),
                  ),
                  AppSpacing.w16(context),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${doc.firstName ?? ""} ${doc.lastName ?? ""}",
                            style: AppTypography.headlineSmall.bold),
                        Text(
                          doc.qualification ?? "MBBS",
                          style: AppTypography.bodySmall.withColor(AppColors.grey600),
                        ),
                        Text(
                          doc.primarySpecialization ?? "General",
                          style: AppTypography.bodySmall.medium.withColor(AppColors.primary),
                        ),
                        Text(
                          "₹ ${doc.consultationFee ?? 0}",
                          style: AppTypography.headlineSmall.bold.withColor(AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              AppSpacing.h16(context),
              Text(
                "Experienced doctor with ${doc.totalExperience ?? 0} years experience providing quality healthcare services.",
                style: AppTypography.bodySmall.withColor(AppColors.grey600).copyWith(height: 1.5),
              ),
            ],
          ),
        ),
        AppSpacing.h32(context),
        Text(
          "Step 4: Select Date",
          style: AppTypography.titleLarge.bold.withColor(AppColors.grey900),
        ),
        AppSpacing.h16(context),
        availableDates.isEmpty
            ? const Text("No dates available")
            : SizedBox(
                height: 80.r(context),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: availableDates.length,
                  itemBuilder: (context, index) {
                    final date = availableDates[index];
                    final isSelected = selectedDateIndex == index;
                    return GestureDetector(
                      onTap: () => setState(() {
                        selectedDateIndex = index;
                        selectedTimeIndex = null;
                      }),
                      child: Container(
                        width: 70.r(context),
                        margin: AppSpacing.only(
                          context: context,
                          right: AppSpacingTokens.spacing3x,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.secondary : Colors.white,
                          borderRadius: AppBorderRadiusTokens.circular3x,
                          border: Border.all(
                            color: isSelected ? Colors.transparent : AppColors.grey200,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              date.day ?? "N/A",
                              style: AppTypography.labelSmall.copyWith(
                                color: isSelected ? Colors.white70 : AppColors.grey500,
                              ),
                            ),
                            Text(
                              date.date?.toString() ?? "N/A",
                              style: AppTypography.headlineSmall.bold.copyWith(
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
        AppSpacing.h32(context),
        Text(
          "Step 5: Select Time Slot",
          style: AppTypography.titleLarge.bold.withColor(AppColors.grey900),
        ),
        AppSpacing.h16(context),
        selectedDateIndex == null
            ? const Text("Please select a date first")
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2.2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: availableDates[selectedDateIndex!].availableSlots?.length ?? 0,
                itemBuilder: (context, index) {
                  final timeSlot = availableDates[selectedDateIndex!].availableSlots![index];
                  final isSelected = selectedTimeIndex == index;

                  return GestureDetector(
                    onTap: () => setState(() => selectedTimeIndex = index),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.secondary : const Color(0xFFE8F5E9),
                        borderRadius: AppBorderRadiusTokens.circular2x,
                      ),
                      child: Text(
                        timeSlot,
                        style: AppTypography.bodySmall.bold.copyWith(
                          color: isSelected ? Colors.white : const Color(0xFF2E7D32),
                        ),
                      ),
                    ),
                  );
                },
              ),
        AppSpacing.h40(context),
        SizedBox(
          width: double.infinity,
          height: 56.r(context),
          child: ElevatedButton(
            onPressed: selectedTimeIndex == null ? null : () => _confirmBooking(context, doc, availabilityData),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.grey300,
              shape: RoundedRectangleBorder(
                borderRadius: AppBorderRadiusTokens.circular3x,
              ),
              elevation: 0,
            ),
            child: Text(
              "Confirm Appointment",
              style: AppTypography.titleLarge.bold.withColor(Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder(BuildContext context, {String? message}) {
    return Container(
      padding: AppSpacing.all(context, AppPaddingTokens.padding10x),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppBorderRadiusTokens.circular4x,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_search, size: 64.r(context), color: AppColors.grey400),
            AppSpacing.h16(context),
            Text(
              message ?? "Please select a doctor to continue booking",
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.withColor(AppColors.grey500),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmBooking(BuildContext context, DoctorDetails doc, availability.AvailabilityData availabilityData) {
    final selectedDate = availabilityData.availableDays![selectedDateIndex!];
    final selectedTime = selectedDate.availableSlots![selectedTimeIndex!];

    context.read<NewBookingBloc>().add(CreateAppointment(
          doctor: doc.id!,
          time: selectedTime,
          bookingType: "Online",
          consultantMode: "Audio-call",
          department: "OPD", // or some logic to pick OPD/IPD/EMERGENCY
          doctorFee: doc.consultationFee ?? 0,
          opdDate: selectedDate.fullDate!,
        ));
  }

  void _showConfirmationDialog(String appointmentID) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 500.r(context),
          padding: AppSpacing.symmetric(context: context, vertical: 60, horizontal: 40),
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: AppBorderRadiusTokens.circular6x,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 120.r(context),
                height: 120.r(context),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: AppColors.secondary,
                  size: 80.r(context),
                ),
              ),
              AppSpacing.h40(context),
              Text(
                "Your Appointment\nwas confirmed.",
                textAlign: TextAlign.center,
                style: AppTypography.displaySmall.bold.withColor(Colors.white),
              ),
              AppSpacing.h20(context),
              Text(
                "Appointment ID: $appointmentID",
                style: AppTypography.titleLarge.regular.withColor(Colors.white),
              ),
            ],
          ),
        ),
      ),
    ).then((_) {
       // Optionally navigate back or refresh
    });
  }
}
