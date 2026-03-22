import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'dart:convert';
import 'dart:io';

// IMPORTANT: This file must exist in your lib/ folder locally
import 'amplifyconfiguration.dart'; 

void main() => runApp(const LegalAnalyzerApp());

class LegalAnalyzerApp extends StatefulWidget {
  const LegalAnalyzerApp({super.key});

  @override
  State<LegalAnalyzerApp> createState() => _LegalAnalyzerAppState();
}

class _LegalAnalyzerAppState extends State<LegalAnalyzerApp> {
  bool _isAmplifyConfigured = false;

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    try {
      // Method A: Using the imported 'amplifyconfig' constant
      await Amplify.addPlugin(AmplifyAuthCognito());
      await Amplify.configure(amplifyconfig);

      if (mounted) {
        setState(() => _isAmplifyConfigured = true);
      }
    } catch (e) {
      debugPrint('DEBUG: Error configuring Amplify: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F172A),
          primary: const Color(0xFF0F172A),
          secondary: const Color(0xFFB45309),
        ),
        fontFamily: 'Inter',
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          color: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F172A),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFB45309), width: 2),
          ),
        ),
      ),
      home: _isAmplifyConfigured ? const AuthWrapper() : const Scaffold(body: Center(child: CircularProgressIndicator())),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/dashboard': (context) => const DashboardScreen(),
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});
  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  Future<void> _checkUser() async {
    try {
      await Amplify.Auth.getCurrentUser();
      if (mounted) Navigator.pushReplacementNamed(context, '/dashboard');
    } catch (_) {
      if (mounted) Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _handleLogin() async {
    try {
      try { await Amplify.Auth.signOut(); } catch (_) {}
      final result = await Amplify.Auth.signIn(
        username: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (result.isSignedIn && mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70, height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(child: Text("AI", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900))),
            ),
            const SizedBox(height: 20),
            const Text("Legal Risk Analyzer", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            const SizedBox(height: 40),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email Address")),
            const SizedBox(height: 16),
            TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
            const SizedBox(height: 32),
            ElevatedButton(onPressed: _handleLogin, child: const Text("SIGN IN")),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/register'),
              child: const Text("Need an account? Register here", style: TextStyle(color: Color(0xFF64748B))),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _codeController = TextEditingController();
  bool _isConfirming = false;

  Future<void> _handleRegister() async {
    try {
      final userAttributes = {AuthUserAttributeKey.email: _emailController.text.trim()};
      final result = await Amplify.Auth.signUp(
        username: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        options: SignUpOptions(userAttributes: userAttributes),
      );
      if (result.nextStep.signUpStep == AuthSignUpStep.confirmSignUp && mounted) {
        setState(() => _isConfirming = true);
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  Future<void> _handleConfirm() async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
        username: _emailController.text.trim(),
        confirmationCode: _codeController.text.trim(),
      );
      if (result.isSignUpComplete && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Success! Please Login.")));
        Navigator.pop(context);
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(_isConfirming ? "Verify Identity" : "Register"),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: _isConfirming
              ? [
            const Text("Enter the code sent to your email", style: TextStyle(color: Color(0xFF64748B))),
            const SizedBox(height: 30),
            TextField(controller: _codeController, decoration: const InputDecoration(labelText: "Verification Code")),
            const SizedBox(height: 30),
            ElevatedButton(onPressed: _handleConfirm, child: const Text("VERIFY ACCOUNT")),
          ]
              : [
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email Address")),
            const SizedBox(height: 16),
            TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
            const SizedBox(height: 32),
            ElevatedButton(onPressed: _handleRegister, child: const Text("CREATE ACCOUNT")),
          ],
        ),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _promptController = TextEditingController();
  File? _selectedFile;
  bool _isProcessing = false;
  String _statusMessage = "";
  Map<String, dynamic>? _analysisData;

  final String bucketName = "risk-analysing-app-data";

  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result != null && mounted) {
      setState(() => _selectedFile = File(result.files.single.path!));
    }
  }

  void _resetAnalysis() {
    setState(() {
      _selectedFile = null;
      _analysisData = null;
      _promptController.clear();
      _statusMessage = "";
    });
  }

  Future<void> _runFullProcess() async {
    if (_selectedFile == null) return;
    setState(() { _isProcessing = true; _statusMessage = "Initiating Analysis..."; });

    try {
      final authUser = await Amplify.Auth.getCurrentUser();
      final userId = authUser.userId;
      if (mounted) setState(() => _statusMessage = "Securing Document...");

      String fileName = "${DateTime.now().millisecondsSinceEpoch}_${_selectedFile!.path.split('/').last}";
      final String s3Key = "uploads/$userId/$fileName";
      final Uri s3Uri = Uri.parse("https://$bucketName.s3.amazonaws.com/");

      var request = http.MultipartRequest('POST', s3Uri);
      request.fields.addAll({
        'key': s3Key,
        'Content-Type': _selectedFile!.path.endsWith('.pdf') ? 'application/pdf' : 'image/jpeg',
      });
      request.files.add(await http.MultipartFile.fromPath('file', _selectedFile!.path));

      var response = await request.send();
      if (response.statusCode == 200 || response.statusCode == 204) {
        if (!mounted) return;
        setState(() => _statusMessage = "Scanning Structure...");

        // SANITIZED: Placeholder for API Gateway URL
        const String lambdaUrl = "https://your-api-id.execute-api.ap-south-1.amazonaws.com/Prod/analyze";

        final lambdaResponse = await http.post(
          Uri.parse(lambdaUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'fileName': s3Key,
            'userPrompt': _promptController.text,
            'userId': userId
          }),
        ).timeout(const Duration(seconds: 45));

        if (lambdaResponse.statusCode == 200 && mounted) {
          setState(() {
            _analysisData = jsonDecode(lambdaResponse.body)['data'];
            _statusMessage = "Complete";
          });
        }
      } else {
        throw "Secure upload failed";
      }
    } catch (e) {
      if (mounted) setState(() => _statusMessage = "Error: $e");
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('DASHBOARD', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 16)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () async {
              await Amplify.Auth.signOut();
              if (mounted) Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: _isProcessing
          ? _buildProcessingUI()
          : (_analysisData == null ? _buildInputUI() : _buildResultsUI()),
    );
  }

  Widget _buildInputUI() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("FILE UPLOAD", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF64748B), letterSpacing: 2)),
          const SizedBox(height: 16),

          GestureDetector(
            onTap: _pickDocument,
            child: Container(
              width: double.infinity,
              height: _selectedFile == null ? 180 : 350,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
              ),
              child: _selectedFile == null
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_upload_outlined, size: 48, color: Color(0xFFB45309)),
                  const SizedBox(height: 12),
                  const Text("Tap to select document", style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
                  const Text("PDF, JPG, PNG", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                ],
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    _selectedFile!.path.endsWith('.pdf')
                        ? SfPdfViewer.file(_selectedFile!)
                        : Image.file(_selectedFile!, fit: BoxFit.cover, width: double.infinity),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.black.withAlpha(150), Colors.transparent],
                            begin: Alignment.topCenter, end: Alignment.bottomCenter,
                          )
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.check_circle, color: Color(0xFF22C55E), size: 18),
                          SizedBox(width: 8),
                          Text("DOCUMENT ATTACHED", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1)),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0, left: 0, right: 0,
                      child: Container(
                        color: Colors.white.withAlpha(200),
                        padding: const EdgeInsets.all(8),
                        child: const Center(child: Text("TAP TO CHANGE FILE", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)))),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),
          const Text("ADDITIONAL INSTRUCTIONS", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF64748B), letterSpacing: 2)),
          const SizedBox(height: 12),
          TextField(
            controller: _promptController,
            maxLines: 4,
            decoration: const InputDecoration(hintText: "e.g. Identify non-compete clauses..."),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _selectedFile != null ? _runFullProcess : null,
            child: const Text("START ANALYSIS"),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessingUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Color(0xFFB45309)),
          const SizedBox(height: 24),
          Text(_statusMessage, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A), letterSpacing: 1)),
        ],
      ),
    );
  }

  Widget _buildResultsUI() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _buildHeaderCard(),
              const SizedBox(height: 20),
              if (_analysisData!['risks'] != null)
                ...(_analysisData!['risks'] as List).map((risk) => _buildRiskCard(risk)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
          ),
          child: OutlinedButton(
            onPressed: _resetAnalysis,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 54),
              side: const BorderSide(color: Color(0xFF0F172A), width: 2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text("NEW ANALYSIS", style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w900, letterSpacing: 1)),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_analysisData!['entity_name']?.toUpperCase() ?? "EXTRACTION", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Color(0xFF0F172A))),
            const SizedBox(height: 4),
            Text(_analysisData!['document_type'] ?? "Legal Insight", style: const TextStyle(color: Color(0xFFB45309), fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 15),
            Text(_analysisData!['summary'] ?? "", style: const TextStyle(height: 1.6, color: Color(0xFF334155), fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskCard(Map<String, dynamic> risk) {
    final String severity = risk['severity']?.toString().toUpperCase() ?? "UNKNOWN";
    final bool isHigh = severity == 'HIGH';
    final bool isMedium = severity == 'MEDIUM';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: isHigh ? const Color(0xFFEF4444).withAlpha(51) : 
                 (isMedium ? const Color(0xFFF59E0B).withAlpha(51) : const Color(0xFF22C55E).withAlpha(51))
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                  color: isHigh ? const Color(0xFFFEF2F2) : 
                         (isMedium ? const Color(0xFFFFFBEB) : const Color(0xFFF0FDF4)),
                  borderRadius: BorderRadius.circular(6)
              ),
              child: Text(
                "$severity RISK", 
                style: TextStyle(
                  color: isHigh ? const Color(0xFFEF4444) : 
                         (isMedium ? const Color(0xFFD97706) : const Color(0xFF22C55E)), 
                  fontSize: 10, 
                  fontWeight: FontWeight.w900
                )
              ),
            ),
            const SizedBox(height: 10),
            Text(risk['reason'] ?? "", style: const TextStyle(fontSize: 14, height: 1.4, color: Color(0xFF1E293B))),
          ],
        ),
      ),
    );
  }
}




// -- D Ram Prahasith Sharma.