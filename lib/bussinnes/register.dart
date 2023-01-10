import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hemenyukle/bussinnes/login.dart';
import 'package:hemenyukle/bussinnes/work_list.dart';
import 'package:hemenyukle/data.dart';
import 'package:hemenyukle/main.dart';
import 'package:hemenyukle/widgets/app_color.dart';
import 'package:hemenyukle/widgets/text_form_field.dart';
import 'package:http/http.dart' as http;

class BussinesRegister extends StatefulWidget {
  const BussinesRegister({super.key});

  @override
  State<BussinesRegister> createState() => _BussinesRegisterState();
}

class _BussinesRegisterState extends State<BussinesRegister>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? bussinesName;
  String? name;
  String? mail;
  String? phone;
  String? localPhone;
  String? password;
  String? passwordSecond;
  String? city;
  String? address;

  final bussinesNameTextController = TextEditingController();
  final nameTextController = TextEditingController();
  final phoneTextController = TextEditingController();
  final localPhoneTextController = TextEditingController();
  final addressTextController = TextEditingController();
  final mailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  TextEditingController smsController = TextEditingController();

  bool smsVerificationScreen = false;

  FirebaseAuth auth = FirebaseAuth.instance;

  CollectionReference businessUsers =
      FirebaseFirestore.instance.collection('businessUsers');

  String? codeSendVerificationId;

  var cities = Data().Cities();
  final List listCities = [];

  Future<void> addUser(String? uid) async {
    Map<String, String> dataTosave = {
      'bussinesName': bussinesNameTextController.text,
      'name': nameTextController.text,
      'mail': mailTextController.text,
      'phone': phoneTextController.text,
      'localPhone': localPhoneTextController.text,
      'password': passwordTextController.text,
      'city': city.toString(),
      'address': addressTextController.text,
      'userId': uid.toString(),
    };

    await businessUsers.doc(uid).set(dataTosave).then((value) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const BussinesLogin()));
    }).catchError((error) {});
  }

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

  @override
  Widget build(BuildContext context) {
    listCities.clear();
    for (var item in cities) {
      listCities.add(item['il'].toString());
    }

    Future register() async {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: '$mail'.trim(), password: '$password'.trim());
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: '$mail', password: '$password');

        await credential.user?.updateDisplayName(name);
        await credential.user?.verifyBeforeUpdateEmail('newEmail');
        print(credential.user?.uid);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shadowColor: Colors.transparent,
        title: Text(
          'Kayıt Ol',
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
                          autovalidateMode: AutovalidateMode.always,
                          key: formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Nakliyeci Kayıt Ekranı',
                                style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        const AppColors().grey.withOpacity(.7)),
                              ),
                              const SizedBox(height: 30),
                              CustomTextField(
                                controller: bussinesNameTextController,
                                textInputAction: TextInputAction.next,
                                hintText: 'Şirketinizin Adı',
                                icon: Icons.business,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Lütfen şirketinizin adını giriniz.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),
                              CustomTextField(
                                controller: nameTextController,
                                textInputAction: TextInputAction.next,
                                hintText: 'İsminiz',
                                icon: Icons.person,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Lütfen isminizi giriniz.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),
                              CustomTextField(
                                controller: mailTextController,
                                textInputAction: TextInputAction.next,
                                hintText: 'E-mail',
                                keyboardType: TextInputType.emailAddress,
                                icon: Icons.mail,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Lütfen e-mail adresinizi giriniz.';
                                  } else if (!value.contains("@") &&
                                      !value.contains(".")) {
                                    return 'Lürtfen geçerli bir e-mail adresi giriniz.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),
                              CustomTextField(
                                controller: phoneTextController,
                                textInputAction: TextInputAction.next,
                                hintText: 'Telefon Numaranız',
                                helperText: 'Örn: 5367160309',
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.phone,
                                icon: Icons.phone_android,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Lütfen telefon numaranızı giriniz.';
                                  } else if (value.length < 10 ||
                                      value[0] != '5') {
                                    return 'Lürtfen geçerli bir telefon numarası giriniz.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),
                              CustomTextField(
                                controller: localPhoneTextController,
                                textInputAction: TextInputAction.next,
                                hintText: 'Sabit Telefon Numaranız',
                                helperText: 'Örn: 2122121212',
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.phone,
                                icon: Icons.local_phone,
                              ),
                              const SizedBox(height: 15),
                              CustomTextField(
                                controller: passwordTextController,
                                textInputAction: TextInputAction.next,
                                obscureText: true,
                                hintText: 'Şifre',
                                icon: Icons.password,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Lütfen şifrenizi giriniz.';
                                  }
                                  password = value;
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),
                              CustomTextField(
                                textInputAction: TextInputAction.next,
                                obscureText: true,
                                hintText: 'Şifre Takrar',
                                icon: Icons.password,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Lütfen şifrenizi giriniz.';
                                  } else if (password != value) {
                                    return 'Şifreleriniz uyuşmuyor lütfen kontrol ediniz.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 15),
                              CustomDropDownMenu(
                                  hintText: 'Şehir seçiniz',
                                  list: listCities,
                                  icon: Icons.location_city,
                                  onChanged: (String? value) {
                                    setState(() {
                                      city = '$value';
                                    });
                                  }),
                              const SizedBox(height: 15),
                              CustomTextField(
                                controller: addressTextController,
                                textInputAction: TextInputAction.newline,
                                hintText: 'Adresiniz',
                                minLines: 2,
                                maxLines: 2,
                                icon: Icons.map,
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Lütfen adresinizi giriniz.';
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
                                child: Text('Kayıt Ol'),
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    auth.verifyPhoneNumber(
                                      phoneNumber:
                                          '+90${phoneTextController.text}',
                                      codeSent: (String verificationId,
                                          int? resendToken) async {
                                        setState(() {
                                          codeSendVerificationId =
                                              verificationId;
                                          smsVerificationScreen = true;
                                        });
                                      },
                                      codeAutoRetrievalTimeout:
                                          (String verificationId) {},
                                      verificationCompleted:
                                          (PhoneAuthCredential
                                              credential) async {
                                        // ANDROID ONLY!

                                        // Sign the user in (or link) with the auto-generated credential
                                        await auth
                                            .signInWithCredential(credential);
                                      },
                                      verificationFailed:
                                          (FirebaseAuthException error) {
                                        print(
                                            '::::::::::::::::::::::::verificartion Failed $error');
                                      },
                                    );
                                  }
                                },
                              ),
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
                                child: Text(
                                  'Giriş Yap',
                                  style: TextStyle(color: AppColors().primary),
                                ),
                                onPressed: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const BussinesLogin()));
                                },
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
                                                addUser(value.user?.uid);
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
