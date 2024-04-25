import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CounterHomePage extends StatefulWidget {
  const CounterHomePage({super.key});

  @override
  State<CounterHomePage> createState() => _CounterHomePageState();
}

class _CounterHomePageState extends State<CounterHomePage> {
  int _counter = 0;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _loadCounter(); // Load the saved counter value on app launch
  }

  Future<void> _loadCounter() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = prefs.getInt('counter') ??
          0; // Use default value (0) if no saved value
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      prefs.setInt('counter', _counter); // Save the updated counter
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 0) _counter--;
      prefs.setInt('counter', _counter); // Save the updated counter
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
      prefs.setInt('counter', _counter); // Save the reset counter
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Tasbeeh',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 150,
            ),
            Text(
              'Count: $_counter',
              style: const TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 120.0),
            ElevatedButton(
              style: const ButtonStyle(
                side: MaterialStatePropertyAll(
                  BorderSide(
                    color: Color(0xff01301C),
                  ),
                ),
              ),
              onPressed: _resetCounter,
              child: const Text('Reset Count'),
            ),
            const SizedBox(
              height: 50,
            ),
            Column(
              children: [
                SizedBox(
                  height: 300,
                  child: Stack(
                    children: [
                      IconButton(
                        style: ButtonStyle(
                          overlayColor: MaterialStatePropertyAll(
                              Colors.white.withOpacity(0.5)),
                          shape: const MaterialStatePropertyAll(
                            CircleBorder(),
                          ),
                          backgroundColor: const MaterialStatePropertyAll(
                            Color(0xff01301C),
                          ),
                        ),
                        onPressed: _incrementCounter,
                        icon: const Icon(
                          Icons.keyboard_arrow_up_outlined,
                          size: 180,
                          color: Color(0xff00EA86),
                        ),
                      ),
                      Positioned(
                        bottom: 50,
                        left: 0,
                        right: 0,
                        child: IconButton(
                          style: ButtonStyle(
                            overlayColor: MaterialStatePropertyAll(
                                Colors.white.withOpacity(0.5)),
                            shape: const MaterialStatePropertyAll(
                              CircleBorder(
                                side: BorderSide(color: Colors.white, width: 3),
                              ),
                            ),
                            backgroundColor: const MaterialStatePropertyAll(
                              Color(0xff01301C),
                            ),
                          ),
                          onPressed: _decrementCounter,
                          icon: const Icon(
                            Icons.keyboard_arrow_down_outlined,
                            size: 80,
                            color: Color(0xff00EA86),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 20.0),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
