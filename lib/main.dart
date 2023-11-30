import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:pwa_install/pwa_install.dart';

void main() {
  PWAInstall().setup(installCallback: () {
    debugPrint('APP INSTALLED!');
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final routerDelegate = BeamerDelegate(
    locationBuilder: RoutesLocationBuilder(
      routes: {
        '/': (context, state, data) => const MyHomePage(
              title: 'AmigoLab PWA',
            ),
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'AmigoLab PWA',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routeInformationParser: BeamerParser(),
      routerDelegate: routerDelegate,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String? error;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the\nbutton this many times:',
              textAlign: TextAlign.center,
            ),
            AnimatedRotation(
              turns: _counter.toDouble(),
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 450),
              child: Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            if (PWAInstall().installPromptEnabled)
              ElevatedButton(
                  onPressed: () {
                    try {
                      PWAInstall().promptInstall_();
                    } catch (e) {
                      setState(() {
                        error = e.toString();
                      });
                      if (error != null) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(error!)));
                      }
                    }
                  },
                  child: const Text('Установить приложение')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
