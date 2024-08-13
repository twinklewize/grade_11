import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Network Info',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Network Info'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: const NetworkInfoWidget(),
    );
  }
}

class NetworkInfoWidget extends StatefulWidget {
  const NetworkInfoWidget({super.key});

  @override
  State<NetworkInfoWidget> createState() => _NetworkInfoWidgetState();
}

class _NetworkInfoWidgetState extends State<NetworkInfoWidget> {
  final eventChannel = const EventChannel('com.example.networkInfo/status');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: eventChannel.receiveBroadcastStream(),
      builder: (_, snapshot) {
        return Center(child: Text(snapshot.data.toString()));
      },
    );
  }
}
