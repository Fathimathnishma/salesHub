class AppError {
  final String message;
  final String type;

  AppError({required this.message, required this.type});

  factory AppError.handle(dynamic error) {
    final err = error.toString();

    if (err.contains("SocketException")) {
      return AppError(type: "NO_INTERNET", message: "No internet connection");
    } else if (err.contains("401")) {
      return AppError(
        type: "UNAUTHORIZED",
        message: "Invalid email or password",
      );
    } else if (err.contains("500")) {
      return AppError(
        type: "SERVER_ERROR",
        message: "Server error, try again later",
      );
    } else {
      return AppError(type: "UNKNOWN", message: "Something went wrong");
    }
  }
}
