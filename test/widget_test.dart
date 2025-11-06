import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:video_chat_app/main.dart';

void main() {
  testWidgets('Video chat app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const VideoChatApp());

    // Verify that the app starts with the join screen
    expect(find.text('Agora Video Chat'), findsOneWidget);
    expect(find.text('Join a Video Call'), findsOneWidget);
    expect(find.text('Enter a channel name to start or join a video call'), findsOneWidget);
    
    // Verify the channel name input field exists
    expect(find.byType(TextField), findsOneWidget);
    
    // Verify the join button exists
    expect(find.text('Join'), findsOneWidget);
  });
}