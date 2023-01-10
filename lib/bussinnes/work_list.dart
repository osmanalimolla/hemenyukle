import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hemenyukle/widgets/app_color.dart';

class WorkList extends StatefulWidget {
  const WorkList({super.key});

  @override
  State<WorkList> createState() => _WorkListState();
}

class _WorkListState extends State<WorkList> {
  int selectedIndex = 0;
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: const AppColors().lightGrey,
        actions: [
          (selectedIndex == 0)
              ? Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  width: MediaQuery.of(context).size.width,
                  child: Row(children: [
                    ElevatedButton(onPressed: (() {}), child: Text('asd')),
                    ElevatedButton(onPressed: (() {}), child: Text('asd'))
                  ]),
                )
              : Container(),
        ],
      ),
      extendBody: true,
      body: (selectedIndex == 0)
          ? Container(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                // Let the ListView know how many items it needs to build.
                itemCount: 9,
                // Provide a builder function. This is where the magic happens.
                // Convert each item into a widget based on the type of item it is.
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.only(top: 15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const ListTile(
                          leading: Icon(Icons.album),
                          title: Text('The Enchanted Nightingale'),
                          subtitle: Text(
                              'Music by Julie Gable. Lyrics by Sidney Stein.'),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            TextButton(
                              child: const Text('BUY TICKETS'),
                              onPressed: () {/* ... */},
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              child: const Text('LISTEN'),
                              onPressed: () {/* ... */},
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          : Container(),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 10),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: 50,
              color: Colors.white,
            ),
            Positioned(
              left: 0,
              child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * .33,
                child: Material(
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        onItemTapped(0);
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/box-archive.svg',
                          color: (selectedIndex == 0)
                              ? const AppColors().primary
                              : const AppColors().lightGrey,
                          height: 20,
                        ),
                        Text(
                          'Arşiv',
                          style: TextStyle(
                            fontSize: 12,
                            color: (selectedIndex == 0)
                                ? const AppColors().primary
                                : const AppColors().lightGrey,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              child: GestureDetector(
                onTap: () {
                  onItemTapped(1);
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const AppColors().primary,
                    border: Border.all(color: Colors.white, width: 5),
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 3),
                        spreadRadius: 1,
                        blurRadius: 6,
                        color: AppColors().lightGrey.withOpacity(.3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SvgPicture.asset(
                      'assets/icons/box.svg',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * .33,
                child: Material(
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        onItemTapped(2);
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/user.svg',
                          color: (selectedIndex == 2)
                              ? const AppColors().primary
                              : const AppColors().lightGrey,
                          height: 20,
                        ),
                        Text(
                          'Hesabım',
                          style: TextStyle(
                            fontSize: 12,
                            color: (selectedIndex == 2)
                                ? const AppColors().primary
                                : const AppColors().lightGrey,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/*
BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        currentIndex: selectedIndex,
        selectedItemColor: AppColors().primary,
        onTap: onItemTapped,
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: '',
            backgroundColor: Colors.green,
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
            backgroundColor: Colors.purple,
          ),
        ],
      ),
 */
