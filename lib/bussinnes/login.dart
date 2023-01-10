import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:hemenyukle/bussinnes/register.dart';
import 'package:hemenyukle/bussinnes/work_list.dart';
import 'package:hemenyukle/home.dart';
import 'package:hemenyukle/widgets/app_color.dart';
import 'package:hemenyukle/widgets/text_form_field.dart';

class BussinesLogin extends StatefulWidget {
  const BussinesLogin({super.key});

  @override
  State<BussinesLogin> createState() => _BussinesLoginState();
}

class _BussinesLoginState extends State<BussinesLogin> {
  String? phone;
  String? password;

  final phoneTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  String? codeSendVerificationId;
  TextEditingController smsController = TextEditingController();

  bool smsVerificationScreen = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (auth.currentUser != null) {
      print(':::::::::::::::User login with uid: ${auth.currentUser!.uid}');
      Timer(
          const Duration(seconds: 1),
          () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => const WorkList())));
    } else {
      print(':::::::::::::::User not login.');
    }
  }

  Future<void> getUser() async {
    print('::::::getUser');
    await FirebaseFirestore.instance
        .collection('businessUsers')
        .where('phone', isEqualTo: phoneTextController.text)
        .where('password', isEqualTo: passwordTextController.text)
        .get()
        .then(
      (value) {
        value.docs.forEach((element) {
          if (element.data().isNotEmpty) {
            print(element.data());
            auth.verifyPhoneNumber(
              phoneNumber: '+90${phoneTextController.text}',
              codeSent: (String verificationId, int? resendToken) async {
                setState(() {
                  codeSendVerificationId = verificationId;
                  smsVerificationScreen = true;
                });
              },
              codeAutoRetrievalTimeout: (String verificationId) {},
              verificationCompleted: (PhoneAuthCredential credential) async {
                // ANDROID ONLY!

                // Sign the user in (or link) with the auto-generated credential
                await auth.signInWithCredential(credential);
              },
              verificationFailed: (FirebaseAuthException error) {
                print('::::::::::::::::::::::::verificartion Failed $error');
              },
            );
          }
        });
      },
    ).catchError((onError) {
      print(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Giriş Yap',
          style: TextStyle(color: const AppColors().grey),
        ),
      ),
      backgroundColor: const AppColors().light,
      body: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          vertical: 40, horizontal: 30),
                      child: Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Telefon numaranız ile giriş yapınız.',
                                style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        const AppColors().grey.withOpacity(.7)),
                              ),
                              const SizedBox(height: 30),
                              CustomTextField(
                                controller: phoneTextController,
                                textInputAction: TextInputAction.next,
                                hintText: 'Telefon Numaranız',
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.phone,
                                icon: Icons.phone_android,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Lütfen telefon numaranızı giriniz.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),
                              CustomTextField(
                                controller: passwordTextController,
                                textInputAction: TextInputAction.done,
                                obscureText: true,
                                hintText: 'Şifreniz',
                                icon: Icons.password,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Lütfen şifrenizi giriniz.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),
                              ElevatedButton(
                                  style: ButtonStyle(
                                      padding: const MaterialStatePropertyAll(
                                          EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 20)),
                                      backgroundColor: MaterialStatePropertyAll(
                                          const AppColors().primary)),
                                  onPressed: (() async {
                                    getUser();
                                    if (formKey.currentState!.validate()) {}
                                  }),
                                  child: const Text('Giriş Yap')),
                              const SizedBox(height: 15),
                              Text(
                                'veya',
                                style: TextStyle(
                                    color:
                                        const AppColors().grey.withOpacity(.7),
                                    fontSize: 16),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                    padding: const MaterialStatePropertyAll(
                                        EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 20)),
                                    backgroundColor: MaterialStatePropertyAll(
                                        const AppColors().light2)),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const BussinesRegister()));
                                },
                                child: Text(
                                  'Kayıt Ol',
                                  style: TextStyle(color: AppColors().primary),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            ),
            (smsVerificationScreen)
                ? Container(
                    padding: EdgeInsets.all(20),
                    height: MediaQuery.of(context).size.height,
                    color: Colors.black.withOpacity(.3),
                    child: DraggableScrollableSheet(
                      snap: false,
                      maxChildSize: .5,
                      initialChildSize: .5,
                      minChildSize: .5,
                      builder: (BuildContext context,
                          ScrollController scrollController) {
                        return Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Center(
                                  child: Text(
                                    'Telefon Numaranızı Onaylayınız',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: const AppColors().grey,
                                        fontSize: 14),
                                  ),
                                ),
                                CustomTextField(
                                  textInputAction: TextInputAction.send,
                                  keyboardType: TextInputType.phone,
                                  icon: Icons.sms,
                                  hintText: 'SMS Onay Kodu',
                                  controller: smsController,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      style: ButtonStyle(
                                          padding:
                                              const MaterialStatePropertyAll(
                                                  EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 20)),
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  const AppColors().light2)),
                                      child: Text(
                                        'İptal',
                                        style: TextStyle(
                                            color: const AppColors().grey),
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          smsVerificationScreen = false;
                                        });
                                      },
                                    ),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                          padding:
                                              const MaterialStatePropertyAll(
                                                  EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 20)),
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  const AppColors().primary)),
                                      child: const Text('Onayla'),
                                      onPressed: () async {
                                        if (smsController.text.length == 6) {
                                          String smsCode = smsController.text;
                                          try {
                                            await FirebaseAuth.instance
                                                .signInWithCredential(
                                                    PhoneAuthProvider.credential(
                                                        verificationId:
                                                            codeSendVerificationId
                                                                .toString(),
                                                        smsCode: smsCode))
                                                .then((value) async {
                                              if (value.user != null) {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            super.widget));
                                                print('::::::::OK');
                                              }
                                            });
                                          } catch (e) {
                                            setState(() {
                                              smsVerificationScreen = false;
                                            });
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content:
                                                        Text(e.toString())));
                                            FocusScope.of(context).unfocus();
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ));
                      },
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
