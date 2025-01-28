import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {

    const String _title = 'Register to BenzinApp';

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text(_title),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                      child: const Text(
                        "Welcome to BenzinApp!",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30
                        ),
                      )
                  ),

                  const SizedBox(height: 40),

                  Center(
                    child: Image.asset(
                      "lib/assets/images/benzinapp_logo_round.png",
                      height: 150,
                      width: 150,
                    ),
                  ),

                  const SizedBox(height: 40),

                  Row(
                    children: [
                      Expanded(
                        child: new Container(
                            margin: const EdgeInsets.only(left: 5, right: 10),
                            child: Divider(
                              color: Colors.black,
                              height: 36,
                            )),
                      ),
                      Text(
                        "Account Details",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17
                        ),
                      ),
                      Expanded(
                        child: new Container(
                            margin: const EdgeInsets.only(left: 10, right: 5),
                            child: Divider(
                              color: Colors.black,
                              height: 36,
                            )),
                      ),
                  ]),

                  const SizedBox(height: 10),


                  // BenzinApp Logo
                  TextField(
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Enter your Username",
                      labelText: "Username",
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16.0),

                  // Password TextField
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Enter your password",
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  Center(
                      child: TapRegion(
                        child: const Text(
                          "Already registered? Log into your account.",
                        ),
                        onTapInside: (value) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterPage()
                              )
                          );
                        },
                      )
                  ),

                  const SizedBox(height: 50),

                  // Login Button
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      style: const ButtonStyle(
                          elevation: WidgetStatePropertyAll(4),
                          backgroundColor: WidgetStatePropertyAll(
                              Color.fromARGB(255, 184, 134, 59)
                          )
                      ),
                      label: const Text(
                        "Register",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black
                        ),
                      ),
                      icon: const Icon(Icons.app_registration, color: Colors.black),
                    ),
                  )
                ]
            ),
          ),
        ));
  }

}