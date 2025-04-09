import 'package:flutter/material.dart';
import 'package:health_care_app/core/utils/app_bar.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _enableNotifications = true;
  bool _sound = true;
  bool _vibrate = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context: context, title: "Notifications settings"),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(children: [
          ListTile(
            title: const Text('Enable Notifications'),
            trailing: Switch(
              value: _enableNotifications, // This should be a state variable
              onChanged: (bool value) {
                setState(() {
                  if (_enableNotifications) {
                    _enableNotifications = false;
                  } else {
                    _enableNotifications = true;
                  }
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Sound'),
            trailing: Switch(
              value: _sound, // This should be a state variable
              onChanged: (bool value) {
                setState(() {
                  _sound = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Vibrate'),
            trailing: Switch(
              value: _vibrate, // This should be a state variable
              onChanged: (bool value) {
                setState(() {
                  _vibrate = value;
                });
              },
            ),
          ),
        ]),
      )),
    );
  }
}
