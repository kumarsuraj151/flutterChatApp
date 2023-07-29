import 'package:chatapp/Pages/homePage.dart';
import 'package:chatapp/helper/Shared_prefrence.dart';
import 'package:chatapp/helper/widgets.dart';
import 'package:chatapp/serivice/authService.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './main.dart';

class NewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.red),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
        body: MyCustomForm());
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// eate a corresponding State class. This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();
  bool _isloading = false;
  String name = "";
  String email = "";
  String password = "";
  AuthService authService = AuthService();

  FToast? fToast;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast?.init(context);
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return _isloading
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 18,
                ),
                Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Groupie",
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text("Create a account to chat and explore"),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                    width: 400,
                    height: 250,
                    child: Image.asset(
                      "assets/login.png",
                      fit: BoxFit.cover,
                    )),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      children: [
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              name = value;
                            });
                          },
                          decoration: const InputDecoration(
                              hintText: "Name",
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.red,
                              ),
                              labelText: "Name",
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue)),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black))),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                            decoration: const InputDecoration(
                                hintText: "Enter your email",
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.red,
                                ),
                                labelText: "Email",
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black))),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                password = value;
                              });
                            },
                            decoration: const InputDecoration(
                                hintText: "Password",
                                prefixIcon: Icon(
                                  Icons.password,
                                  color: Colors.red,
                                ),
                                labelText: "Password",
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black))),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(5)),
                              width: double.infinity,
                              child: TextButton(
                                  onPressed: () => {register()},
                                  child: const Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Text(
                                      "Register ",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 22),
                                    ),
                                  ))),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("already have a account"),
                              TextButton(
                                  onPressed: () => {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) => MyApp()))
                                      },
                                  child: const Text(
                                    "Login now",
                                    style: TextStyle(color: Colors.blue),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  register() async {
    setState(() {
      _isloading = true;
    });
    await authService.register(name, email, password).then((value) async {
      if (value == true) {
        await HeperFunction.saveUserLoggedIn(true);
        await HeperFunction.saveUserName(name);
        await HeperFunction.saveUserEmail(email);
        nextReplaceScreen(context, MyApp());
      } else {
        customToastmessage(context, value);
      }
    });

    setState(() {
      _isloading = false;
    });
  }
}
