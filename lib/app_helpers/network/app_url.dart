class ApiUrls {
  ApiUrls._();

  // ── Base ────────────────────────────────────────────────────
  static const String baseUrl = 'https://backend.jigrohms.com';

  // ── Auth ────────────────────────────────────────────────────
  static const String auth = '/api/auth/';
  static const String login = '/api/auth/login';
  static const String logout = '/api/auth/logout';
  static const String forgotPassword = '/api/auth/forgot-password';
  static const String setPassword = '/api/auth/set-password';
  static const String refreshTokenEndpoint =
      '/api/auth/refresh-token'; // used by DioClient._runRefresh()
  static const String me = '/api/auth/me';

  // ── Patient — static paths ──────────────────────────────────
  static const String patients = '/api/patient'; // GET (list) + POST (add)

  // ── Patient — dynamic paths (require patientId) ─────────────
  static String patientById(String id) =>
      '/api/patient/$id'; // GET / PATCH basic / DELETE
  static String patientAddress(String id) =>
      '/api/patient/$id/address'; // PATCH
  static String patientIdentity(String id) =>
      '/api/patient/$id/identity'; // PATCH
  static String patientInsurance(String id) =>
      '/api/patient/$id/insurance'; // PATCH
  static String patientHealth(String id) => '/api/patient/$id/health'; // PATCH
  static String patientDocuments(String id) =>
      '/api/patient/$id/documents'; // PATCH (multipart)
  static String patientBookings = '/api/patientDashboard/get-patientBookings';
  static String paitentInvoice = '/api/patientDashboard/get-patientInvoice';
  static String labReports = '/api/patientDocuments/get-patientReportsDocument';
  static String uploadDocument = '/api/patientDocuments/upload';
  static String bookingDoctors = '/api/bookingDoctor';
  static String patientDashboard = '/api/patientDashboard';
}
