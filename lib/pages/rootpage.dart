import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:case_study/cubit/UserDetailsCubit/UserDetailsCubit.dart';
import 'package:case_study/widgets/dashboard_widget.dart';
import 'package:case_study/widgets/history_widget.dart';
import 'package:case_study/widgets/support_widget.dart';
import 'package:case_study/widgets/usage_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zapx/zapx.dart';

class RootPage extends StatefulWidget {
  @override
  State<RootPage> createState() => _DashBoardState();
}

class _DashBoardState extends State<RootPage> {
  NotchBottomBarController _notchController =
      NotchBottomBarController(index: 0);

  int currentIndex = 0;
  List<Widget> _widgetsList = [];

  @override
  void initState() {
    super.initState();
    _widgetsList = [
      DashboardWidget(),
      const UsageWidget(),
      const HistoryWidget(),
      const SupportWidget()
    ];
  }

  @override
  void dispose() {
    super.dispose();
    _notchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 115, 47, 251),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 115, 47, 251),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ListTile(
                    leading: const Icon(
                      Icons.menu,
                      size: 30,
                      color: Colors.white,
                    ),
                    trailing: SizedBox(
                      width: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.white,
                          ),
                          const Icon(
                            Icons.notifications,
                            size: 30,
                            color: Colors.white,
                          ).paddingOnly(left: 15)
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: FutureBuilder(
                      future: context
                          .read<UserDetailsCubit>()
                          .getCurrentUserDetails(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(
                            width: 60,
                          );
                        }
                        return ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                NetworkImage(snapshot.data!['imageURL']),
                            backgroundColor:
                                const Color.fromARGB(255, 115, 47, 251),
                          ),
                          titleAlignment: ListTileTitleAlignment.top,
                          title: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Hello',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                  ),
                                ),
                                Text(
                                  snapshot.data!['userName'],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
          SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: _widgetsList[currentIndex]),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: AnimatedNotchBottomBar(
          notchBottomBarController: _notchController,
          itemLabelStyle: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
          bottomBarItems: [
            BottomBarItem(
                inActiveItem: Image.asset('assets/images/dashboard.png',
                    color: Colors.grey),
                activeItem: Image.asset('assets/images/dashboard.png',
                    color: Colors.white),
                itemLabel: 'DashB'),
            BottomBarItem(
                inActiveItem: Image.asset('assets/images/speedometer.png',
                    color: Colors.grey),
                activeItem: Image.asset('assets/images/speedometer.png',
                    color: Colors.white),
                itemLabel: 'Usage'),
            BottomBarItem(
                inActiveItem:
                    Image.asset('assets/images/file.png', color: Colors.grey),
                activeItem:
                    Image.asset('assets/images/file.png', color: Colors.white),
                itemLabel: 'History'),
            BottomBarItem(
                inActiveItem: Image.asset('assets/images/support.png',
                    color: Colors.grey),
                activeItem: Image.asset('assets/images/support.png',
                    color: Colors.white),
                itemLabel: 'Support')
          ],
          notchColor: const Color.fromARGB(255, 250, 110, 40),
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
            _notchController.jumpTo(index);
            print('current selected index: $index');
          }),
    );
  }
}
