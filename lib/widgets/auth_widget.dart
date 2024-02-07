import 'dart:io';

import 'package:case_study/bloc/autth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sysPathProvider;
import 'package:provider/provider.dart';
import 'package:zapx/zapx.dart';

class AuthWidget extends StatefulWidget {
  AuthWidget._empty({super.key});

  static AuthWidget? _singleInstance;
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode userNameFocusNode = FocusNode();
  get getFocus1 => emailFocusNode;
  get getFocus2 => passwordFocusNode;
  get getFocus3 => userNameFocusNode;

  factory AuthWidget() {
    _singleInstance ??= AuthWidget._empty();
    return _singleInstance!;
  }
  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  bool _isObscured = true;
  String? email;
  String? password;
  String? userName = '';
  File? _storedImage;

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  bool _isLogin = true;
  bool _isLoading = false;

  String? role;

  Future<void> _submit(BuildContext context) async {
    if ((_storedImage == null || role == null) && (!_isLogin)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('missing image or role for select...!!!'),
        duration: Duration(seconds: 3),
      ));
      return;
    }
    if (!(_globalKey.currentState!.validate())) {
      return;
    }

    setState(() {
      _isLoading = true;
    });
    FocusScope.of(context).unfocus();
    _globalKey.currentState!.save();

    context.read<AuthBloc>().add(AuthLoginRequested(
        username: userName,
        email: email!,
        password: password!,
        role: role!,
        isLogin: _isLogin,
        context: context,
        storedImage: _storedImage));

    setState(() {
      _isLoading = false;
    });

    debugPrint(email);
    debugPrint(password);
    debugPrint(userName);
  }

  Future<void> _getDirectory(XFile receivedImage) async {
    final appDirectory =
        await sysPathProvider.getApplicationDocumentsDirectory();
    final imageFile = File(receivedImage.path);
    final fileName = path.basename(imageFile.path);
    final storageResponse =
        await imageFile.copy('${appDirectory.path}/$fileName');

    print("Image Added Succesfully at :- $storageResponse");
  }

  Future<void> _takeImage() async {
    final XFile? receivedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (receivedImage == null) {
      return;
    }
    setState(() {
      _storedImage = File(receivedImage.path);
    });

    _getDirectory(receivedImage);
  }

  Future<void> _selectImage() async {
    final XFile? receivedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxHeight: 150);

    if (receivedImage == null) {
      return;
    }
    setState(() {
      _storedImage = File(receivedImage.path);
    });

    _getDirectory(receivedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 5,
      child: AnimatedContainer(
        duration: const Duration(seconds: 00),
        height: _isLogin
            ? MediaQuery.of(context).size.height * 0.4
            : MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: _isLogin ? 60 : 10,
            ),
            Form(
                key: _globalKey,
                child: Column(
                  children: [
                    if (!_isLogin)
                      Column(
                        children: [
                          CircleAvatar(
                              radius: 50,
                              backgroundImage: _storedImage == null
                                  ? null
                                  : FileImage(
                                      _storedImage!,
                                    ),
                              backgroundColor: _storedImage == null
                                  ? Colors.deepOrange
                                  : null),
                          Padding(
                            padding: const EdgeInsets.only(left: 0, top: 2.0),
                            child: DropdownButton(
                                underline: const Text(
                                  'Add Image',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                icon: const Icon(Icons.edit),
                                items: [
                                  DropdownMenuItem(
                                    value: 'Take Image',
                                    child: Container(
                                      child: const Row(
                                        children: [
                                          Icon(Icons.exit_to_app),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text('Take Image'),
                                        ],
                                      ),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Choose Gallery',
                                    child: Container(
                                      child: const Row(
                                        children: [
                                          Icon(Icons.exit_to_app),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text('Choose Gallery'),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                                onChanged: (identifier) {
                                  if (identifier == 'Take Image') {
                                    _takeImage();
                                  }
                                  if (identifier == 'Choose Gallery') {
                                    _selectImage();
                                  }
                                }),
                          )
                        ],
                      ),
                    if (!_isLogin)
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: TextFormField(
                          key: const ValueKey('username'),
                          focusNode: widget.userNameFocusNode,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter username';
                            }

                            return null;
                          },
                          style: const TextStyle(
                              color: Colors.black, fontSize: 18),
                          decoration: const InputDecoration(
                            label: Text(
                              'Username',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueGrey),
                            ),
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          onSaved: (value) {
                            userName = value;
                          },
                        ),
                      ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextFormField(
                        key: const ValueKey('email'),
                        focusNode: widget.emailFocusNode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter email';
                          }
                          if (!value.contains('@')) {
                            return 'Invalid email';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18),
                        decoration: const InputDecoration(
                          label: Text(
                            'Email',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueGrey),
                          ),
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        onSaved: (value) {
                          email = value;
                        },
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextFormField(
                        key: const ValueKey('password'),
                        focusNode: widget.passwordFocusNode,
                        textInputAction: TextInputAction.done,
                        obscureText: _isObscured,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 18),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter password';
                          }
                          if (value.length < 7) {
                            return 'Please enter a valid password with at least 7 characters';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueGrey),
                          ),
                          labelText: 'Password',
                          labelStyle: const TextStyle(
                              color: Colors.black, fontSize: 18),
                          focusColor: Colors.white,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isObscured = !_isObscured;
                              });
                            },
                            icon: Icon(
                              _isObscured
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        onSaved: (value) {
                          password = value;
                        },
                      ),
                    ),
                    if (!_isLogin)
                      SizedBox(
                        //width: MediaQuery.of(context).size.width * 0.45,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: DropdownButton(
                              isExpanded: true,
                              alignment: Alignment.topLeft,
                              underline: Text(
                                role == null ? 'Choose Role For SignUp' : role!,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'admin',
                                  child: Text('Admin Signup'),
                                ),
                                DropdownMenuItem(
                                  value: 'user',
                                  child: Text('User Signup'),
                                )
                              ],
                              onChanged: (identifier) {
                                setState(() {
                                  role = identifier;
                                });
                              }),
                        ),
                      ),
                  ],
                )),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(
                      const Size(250, 50),
                    ),
                    shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10.0), // Adjust the border radius as needed
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xFFFA5F1C))),
                onPressed: _isLoading
                    ? null
                    : () async {
                        await _submit(context);
                      },
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                          strokeWidth: 5.0,
                          backgroundColor: Colors.grey,
                        ),
                      )
                    : Text(
                        _isLogin ? 'Log In' : 'Create Account',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isLogin
                      ? 'Don\'t have account?'
                      : 'Already have an account?',
                  style: const TextStyle(color: Colors.black),
                ),
                TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                        _storedImage = null;
                      });
                    },
                    child: Text(
                      _isLogin ? 'Create Now' : 'Login',
                      style: const TextStyle(
                          color: Color.fromARGB(255, 115, 47, 251)),
                    ))
              ],
            )
          ],
        ).paddingSymmetric(horizontal: 10),
      ),
    );
  }
}
