import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(PythonExecutorApp());

class PythonExecutorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Python Code Executor',
      home: PythonExecutorScreen(),
    );
  }
}

class PythonExecutorScreen extends StatefulWidget {
  @override
  _PythonExecutorScreenState createState() => _PythonExecutorScreenState();
}

class _PythonExecutorScreenState extends State<PythonExecutorScreen> {
  final TextEditingController _codeController = TextEditingController();
  String _output = "";

  Future<void> executeCode(String code) async {
    final url = Uri.parse('http://10.0.2.2:5000/execute'); // Flask server URL
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'code': code}),
      );

      final responseBody = jsonDecode(response.body);
      if (responseBody['status'] == 'success') {
        setState(() {
          _output = "Output:\n${responseBody['output']}";
        });
      } else {
        setState(() {
          _output = "Error:\n${responseBody['message']}";
        });
      }
    } catch (e) {
      setState(() {
        _output = "Error:\nUnable to connect to server.";
      });
    }
  }

  void clearFields() {
    setState(() {
      _codeController.clear();
      _output = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'Python Code Executor',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Input Area
              TextField(
                controller: _codeController,
                maxLines: 10,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter Python code here',
                ),
              ),
              const SizedBox(height: 16),

              // Output Area
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    _output.isEmpty ? 'Output will appear here' : _output,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),

              // Buttons at the Bottom
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => executeCode(_codeController.text),
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.blue, // Background color
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.5),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Text(
                          'Run Code',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Clear Button
                  Expanded(
                    child: GestureDetector(
                      onTap: clearFields,
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.red, // Background color
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.5),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Text(
                          'Clear',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
