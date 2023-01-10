import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hemenyukle/widgets/app_color.dart';
import 'package:hemenyukle/bussinnes/login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ScrollController controller = ScrollController();

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (auth.currentUser != null) {
      // Go to Business
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          body: TabBarView(
            physics: const BouncingScrollPhysics(),
            children: [
              Container(
                color: const AppColors().light,
                height: MediaQuery.of(context).size.height,
                child: Stack(alignment: Alignment.topCenter, children: [
                  Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * .5,
                    child: Image.asset(
                      'assets/images/bussines-man.png',
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width * .8,
                    ),
                  ),
                  DraggableScrollableSheet(
                    initialChildSize: .5,
                    minChildSize: .5,
                    maxChildSize: .5,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      return Container(
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                            color: const AppColors().primary,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50))),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text(
                                'Hoşgeldiniz...',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 27,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1),
                              ),
                              const Text(
                                'Eşya göndermek mi istiyorsunuz?',
                                style: TextStyle(color: Colors.white),
                              ),
                              InkWell(
                                onTap: (() async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const BussinesLogin()));
                                  //await auth.verifyPhoneNumber(
                                  //  phoneNumber: '+33 7 74 32 26 98',
                                  //  codeAutoRetrievalTimeout:
                                  //      (String verificationId) {
                                  //    // Auto-resolution timed out...
                                  //  },
                                  //  codeSent: (String verificationId,
                                  //      int? forceResendingToken) {},
                                  //  verificationCompleted:
                                  //      (PhoneAuthCredential
                                  //          phoneAuthCredential) {},
                                  //  verificationFailed:
                                  //      (FirebaseAuthException error) {},
                                  //);
                                }),
                                child: Ink(
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20, horizontal: 60),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.white,
                                    ),
                                    child: Text(
                                      'Başla',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: const AppColors().primary),
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 15,
                                    height: 15,
                                    margin: const EdgeInsets.only(right: 5),
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                  ),
                                  Container(
                                    width: 15,
                                    height: 15,
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.5),
                                        shape: BoxShape.circle),
                                  )
                                ],
                              )
                            ]),
                      );
                    },
                  )
                ]),
              ),
              Container(
                color: const AppColors().light,
                height: MediaQuery.of(context).size.height,
                child: Stack(alignment: Alignment.topCenter, children: [
                  Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * .5,
                    child: Image.asset(
                      'assets/images/truck-man.png',
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width * .8,
                    ),
                  ),
                  DraggableScrollableSheet(
                    initialChildSize: .5,
                    minChildSize: .5,
                    maxChildSize: .5,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      return Container(
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                            color: const AppColors().primary,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50))),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text(
                                'Hoşgeldiniz...',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 27,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1),
                              ),
                              const Text(
                                'Eşya taşımak mı istiyorsunuz?',
                                style: TextStyle(color: Colors.white),
                              ),
                              InkWell(
                                child: Container(
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 60),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.white,
                                  ),
                                  child: Text(
                                    'Başla',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: const AppColors().primary),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 15,
                                    height: 15,
                                    margin: const EdgeInsets.only(right: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.5),
                                        shape: BoxShape.circle),
                                  ),
                                  Container(
                                    width: 15,
                                    height: 15,
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                  )
                                ],
                              )
                            ]),
                      );
                    },
                  )
                ]),
              ),
            ],
          ),
        ));
  }

  void signin() async {}
}
