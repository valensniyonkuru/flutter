import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'signin_page.dart';
import 'signup_page.dart';
import 'calculator_page.dart';
import 'connectivity_service.dart';
import 'battery_service.dart';
import 'theme_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeService(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return MaterialApp(
      title: 'Calculator App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Color(0xFF1E1E1E),
      ),
      darkTheme: ThemeData.dark(),
      themeMode: themeService.themeMode,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    SignInPage(),
    SignUpPage(),
    CalculatorPage(),
  ];

  late ConnectivityService _connectivityService;
  ConnectivityResult _connectionStatus = ConnectivityResult.none;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _connectivityService = ConnectivityService();
    _initConnectivity();
    BatteryService(); // Initialize battery service

    _connectivityService.onConnectivityChanged
        .listen((ConnectivityResult result) {
      print('Connectivity changed: $result'); // Debug print
      setState(() {
        _connectionStatus = result;
      });
      _showConnectivityToast(result);
    });
  }

  Future<void> _initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivityService.checkConnectivity();
    } catch (e) {
      print('Error checking connectivity: $e'); // Debug print
      result = ConnectivityResult.none;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _connectionStatus = result;
    });
    _showConnectivityToast(result); // Show initial connectivity status
  }

  void _showConnectivityToast(ConnectivityResult result) {
    String message;
    switch (result) {
      case ConnectivityResult.none:
        message = "No Internet Connection";
        break;
      case ConnectivityResult.mobile:
        message = "Connected to Mobile Network";
        break;
      case ConnectivityResult.wifi:
        message = "Connected to Wi-Fi";
        break;
      default:
        message = "Connection Status: $result";
        break;
    }
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _onItemTapped(int index) {
    if (index >= 0 && index < _pages.length) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator App'),
        backgroundColor: Color(0xFF00897B),
        actions: [
          IconButton(
            icon: Icon(themeService.themeMode == ThemeMode.light
                ? Icons.dark_mode
                : Icons.light_mode),
            onPressed: () {
              themeService.toggleTheme();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          controller: _scrollController,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.login),
              title: Text('Sign In'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(0);
              },
            ),
            ListTile(
              leading: Icon(Icons.app_registration),
              title: Text('Sign Up'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(1);
              },
            ),
            ListTile(
              leading: Icon(Icons.calculate),
              title: Text('Calculator'),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(2);
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.login),
            label: 'Sign In',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.app_registration),
            label: 'Sign Up',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: 'Calculator',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
