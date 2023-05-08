import 'package:flutter/material.dart';

enum ErrorCode {
  unidentified,
  noInternet,
  noAccount,
  accountAlreadyExists,
  invalidCode,
  wrongPassword,
  requestTimeout,
  noHub,
  budgetAlreadyDefined,
  billNotDownload,
  failLogin,
}

class Messenger {
  static void showError(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.redAccent,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showErrorWithCode(BuildContext context, ErrorCode code) {
    showError(context, _getMessageFromCode(context, code));
  }

  static void showSuccess(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showLoading(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.white.withOpacity(0.5),
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              Text(
                'Please wait...',
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ],
          );
        });
  }

  static void closeLoading(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  static String _getMessageFromCode(BuildContext context, ErrorCode code) {
    switch (code) {
      case ErrorCode.unidentified:
        return 'An unknown error occurred';
      case ErrorCode.noInternet:
        return 'No internet connection';

      case ErrorCode.requestTimeout:
        return 'The request has timed out';
      case ErrorCode.noHub:
        return 'Hub not found';
      default:
        return 'An error occurred';
    }
  }
}
