
import 'package:flutter/material.dart';

String fullName = '';
String sapId = '';
String email = '';
String password = '';

void main() {
  runApp(const MyApp());
}

// MAIN APP
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Profile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: const WelcomePage(),
    );
  }
}

// WELCOME PAGE
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final Animation<double> _logoScale;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  bool _showFirstHeading = true;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _logoScale = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeInOut,
      ),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF311B92),
              Color(0xFF7E57C2),
              Color(0xFFB39DDB),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _logoScale,
                    child: const Icon(
                      Icons.account_circle,
                      size: 110,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 28),

                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 900),
                    crossFadeState: _showFirstHeading
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: const Text(
                      'WELCOME',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    secondChild: const Text(
                      'MY PROFILE APP',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: const Text(
                      'Create your account and explore your profile.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  if (orientation == Orientation.portrait)
                    Column(
                      children: _welcomeButtons(context),
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _welcomeButtons(context),
                    ),

                  const SizedBox(height: 18),

                  TextButton(
                    onPressed: () {
                      setState(() {
                        _showFirstHeading = !_showFirstHeading;
                      });
                    },
                    child: const Text(
                      'Change Welcome Text',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _welcomeButtons(BuildContext context) {
    return [
      SizedBox(
        width: 210,
        height: 48,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SignupPage(),
              ),
            );
          },
          child: const Text('Sign Up'),
        ),
      ),
      const SizedBox(width: 12, height: 12),
      SizedBox(
        width: 210,
        height: 48,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(color: Colors.white),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          },
          child: const Text('Login'),
        ),
      ),
    ];
  }
}

// SIGNUP PAGE
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formKey = GlobalKey<FormState>();

  Widget _nameField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Full Name',
        prefixIcon: Icon(Icons.person),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Enter full name';
        }
        return null;
      },
      onSaved: (value) => fullName = value!.trim(),
    );
  }

  Widget _sapIdField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'SAP ID',
        prefixIcon: Icon(Icons.badge),
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter SAP ID';
        }
        if (int.tryParse(value) == null) {
          return 'SAP ID must contain numbers only';
        }
        return null;
      },
      onSaved: (value) => sapId = value!.trim(),
    );
  }

  Widget _emailField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Email',
        prefixIcon: Icon(Icons.email),
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter email';
        }
        if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
            .hasMatch(value.trim())) {
          return 'Enter a valid email';
        }
        return null;
      },
      onSaved: (value) => email = value!.trim(),
    );
  }

  Widget _passwordField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Password',
        prefixIcon: Icon(Icons.lock),
        border: OutlineInputBorder(),
      ),
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
      onSaved: (value) => password = value!,
    );
  }

  void _createAccount() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfilePage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.person_add_alt_1,
                  size: 60,
                  color: Colors.deepPurple,
                ),

                const SizedBox(height: 20),

                if (orientation == Orientation.portrait) ...[
                  _nameField(),
                  const SizedBox(height: 14),
                  _sapIdField(),
                  const SizedBox(height: 14),
                  _emailField(),
                  const SizedBox(height: 14),
                  _passwordField(),
                ] else ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _nameField()),
                      const SizedBox(width: 14),
                      Expanded(child: _sapIdField()),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _emailField()),
                      const SizedBox(width: 14),
                      Expanded(child: _passwordField()),
                    ],
                  ),
                ],

                const SizedBox(height: 22),

                ElevatedButton(
                  onPressed: _createAccount,
                  child: const Padding(
                    padding: EdgeInsets.all(14),
                    child: Text('Create Account'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// LOGIN PAGE
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  String enteredEmail = '';
  String enteredPassword = '';
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.lock_open,
                    size: 65,
                    color: Colors.deepPurple,
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'Welcome Back!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter email';
                      }
                      if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                          .hasMatch(value.trim())) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      enteredEmail = value!.trim();
                    },
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter password';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      enteredPassword = value!;
                    },
                  ),

                  const SizedBox(height: 15),

                  if (errorMessage != null)
                    Text(
                      errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();

                        if (enteredEmail == email &&
                            enteredPassword == password &&
                            email.isNotEmpty) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfilePage(),
                            ),
                          );
                        } else {
                          setState(() {
                            errorMessage =
                            'Incorrect email or password. '
                                'Please sign up first.';
                          });
                        }
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(14),
                      child: Text('Login'),
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Don't have an account? Sign Up",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// PROFILE PAGE
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              width: orientation == Orientation.portrait ? 350 : 600,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // PROFILE IMAGE
                  const CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage(
                      'assets/profilepic.png',
                    ),
                  ),

                  const SizedBox(height: 20),

                  // NAME
                  Text(
                    fullName.isEmpty ? 'Ahmed Raza' : fullName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Software Engineering Student',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Riphah International University',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    sapId.isEmpty ? 'Semester 5' : 'SAP ID: $sapId',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),

                  if (email.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      email,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],

                  const SizedBox(height: 20),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Skills: Flutter, Web Development, Python',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'I am a Software Engineering student interested in '
                        'Flutter, Web Development, and Python. I enjoy creating '
                        'simple and useful applications and learning new '
                        'technologies.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  ),

                  const SizedBox(height: 25),

                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WelcomePage(),
                        ),
                            (route) => false,
                      );
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
