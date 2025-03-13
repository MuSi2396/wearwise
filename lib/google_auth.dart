import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

Future<AutoRefreshingAuthClient> authenticateWithGoogle() async {
  // Load the credentials from the assets folder
  final credentialsJson = await rootBundle.loadString('assets/credentials.json');
  final credentialsMap = jsonDecode(credentialsJson);

  // Convert the credentials into a ServiceAccountCredentials object
  final credentials = ServiceAccountCredentials.fromJson(credentialsMap);

  // Define the required scopes for Google Calendar API access
  final scopes = [CalendarApi.calendarScope];

  // Authenticate using the credentials and request an authenticated client
  return await clientViaServiceAccount(credentials, scopes);
}
