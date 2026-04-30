class Doctor {
  final String name;
  final String qualifications;
  final String speciality;
  final String department;
  final String hospital;
  final String rating;
  final String reviews;
  final String price;
  final String description;
  final String image;

  Doctor({
    required this.name,
    required this.qualifications,
    required this.speciality,
    required this.department,
    required this.hospital,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.description,
    required this.image,
  });
}

class TimeSlot {
  final String time;
  final bool available;

  TimeSlot({required this.time, required this.available});
}

class BookingDate {
  final String day;
  final String date;

  BookingDate({required this.day, required this.date});
}
