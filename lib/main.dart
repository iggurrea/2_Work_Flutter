import 'package:flutter/material.dart';
import 'package:work_2_flutter/screens/login_screen.dart';
import 'database_helper.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  await DatabaseHelper.instance.database;

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final dbHelper = DatabaseHelper.instance;
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _rows = [];

  void _insert() async {
  final username = _controller.text.trim();
  final password = '1234'; // Aquí puedes usar otro controlador si lo deseas

  final result = await dbHelper.insertUser(username, password);

  if (result == -1) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("⚠️ Error: usuario duplicado o inválido")),
    );
  } else {
    _controller.clear();
    _query();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Usuario insertado correctamente")),
    );
  }
}


  void _query() async {
    final allRows = await dbHelper.queryAllUsers();
    setState(() {
      _rows = allRows;
    });
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: _rows.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_rows[index][DatabaseHelper.columnUsername]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SQLite User Test")),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(hintText: "Enter username"),
            ),
          ),
          ElevatedButton(onPressed: _insert, child: const Text("Insert")),
          ElevatedButton(onPressed: _query, child: const Text("Query")),
          const SizedBox(height: 20),
          Expanded(child: _buildListView()),
        ],
      ),
    );
  }
}