import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleCalendarScreen extends StatefulWidget {
  const GoogleCalendarScreen({super.key});

  @override
  _GoogleCalendarScreenState createState() => _GoogleCalendarScreenState();
}

class _GoogleCalendarScreenState extends State<GoogleCalendarScreen> {
  late AuthClient _authClient;
  late CalendarApi _calendarApi;
  bool _isSignedIn = false;
  List<Event> _events = [];

  @override
  void initState() {
    super.initState();
    _signInWithGoogle();
  }

  // Sign in with Google
  Future<void> _signInWithGoogle() async {
    try {
      var client = http.Client();
      var credentials = await _getCredentials();
      _authClient = authenticatedClient(client, credentials as AccessCredentials);
      _calendarApi = CalendarApi(_authClient);
      setState(() {
        _isSignedIn = true;
      });
      _fetchEvents();
    } catch (e) {
      print("Error signing in with Google: $e");
    }
  }

  // Get the OAuth 2.0 credentials from credentials.json
  Future<AutoRefreshingAuthClient> _getCredentials() async {
    final jsonData = await DefaultAssetBundle.of(context).loadString("assets/credentials.json");
    final Map<String, dynamic> credentialsJson = json.decode(jsonData);
    
    final clientId = ClientId(
      credentialsJson['installed']['client_id'],
      credentialsJson['installed']['client_secret'],
    );
    
    // Get access credentials using the correct method
    return await clientViaUserConsent(clientId, [CalendarApi.calendarScope], _prompt);
  }

  // Prompt user to give consent for Google Calendar access
  Future<void> _prompt(String url) async {
    // Implement a method to prompt user for consent
    print("Please visit the URL to authorize: $url");
  }

  // Fetch calendar events
  Future<void> _fetchEvents() async {
    try {
      var events = await _calendarApi.events.list('primary');
      setState(() {
        _events = events.items ?? [];
      });
    } catch (e) {
      print("Error fetching calendar events: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Google Calendar")),
      body: _isSignedIn
          ? ListView.builder(
              itemCount: _events.length,
              itemBuilder: (context, index) {
                final event = _events[index];
                return ListTile(
                  title: Text(event.summary ?? "No Title"),
                  subtitle: Text(event.start?.dateTime?.toString() ?? "No Date"),
                );
              },
            )
          : Center(
              child: ElevatedButton(
                onPressed: _signInWithGoogle,
                child: const Text("Sign in to Google"),
              ),
            ),
    );
  }
}
