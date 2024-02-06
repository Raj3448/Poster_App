import 'package:flutter/material.dart';
import 'package:zapx/zapx.dart';

class DashboardWidget extends StatelessWidget {
  DashboardWidget({Key? key}) : super(key: key);

  List<String> imageNames = [
    'bill',
    'complaint',
    'invoice',
    'update',
    'customer-service',
    'cover-letter',
    'bill1',
    'global-network',
  ];

  List<String> names = [
    'Bills',
    'Disconnect',
    'Transfer',
    'Services',
    'Complaint',
    'update',
    'Connections',
    'Outage',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 3,
                width: 100,
                color: Colors.black,
              ),
            ).paddingOnly(bottom: 10),
            const Text(
              'Quick Actions',
              style: TextStyle(
                  color: Color.fromARGB(255, 115, 47, 251),
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height * 0.22,
                child: GridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 20,
                  children: List.generate(imageNames.length, (index) {
                    return InkWell(
                      onTap: () {},
                      child: SizedBox(
                        height: 70,
                        width: 70,
                        child: Column(
                          children: [
                            SizedBox(
                                height: 40,
                                width: 40,
                                child: Image.asset(
                                    'assets/images/${imageNames[index]}.png')),
                            Text(
                              names[index],
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            const Divider(
              thickness: 10,
              height: 40,
            ),
            ListTile(
              leading: const Text(
                'Gas |',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              title: const Text('SA1234567',
                  style: TextStyle(
                      color: Color.fromARGB(255, 115, 47, 251),
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              trailing: TextButton.icon(
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(
                      const Size(140, 40),
                    ),
                    shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(
                            10.0), // Adjust the border radius as needed
                      ),
                    ),
                  ),
                  label: const Text('Last month'),
                  onPressed: () {},
                  icon: const Icon(Icons.arrow_drop_down)),
            ),
            Card(
              elevation: 5,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.09,
                width: MediaQuery.of(context).size.width * 0.9,
                child: ListTile(
                  leading: SizedBox(
                      height: 50,
                      width: 50,
                      child: Image.asset('assets/images/customer-service.png')),
                  titleAlignment: ListTileTitleAlignment.center,
                  title: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text('Bills'), Text('20 Jan 2020')],
                  ),
                  trailing: const Text(
                    '43s',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            Card(
              elevation: 5,
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.09,
                width: MediaQuery.of(context).size.width * 0.9,
                child: ListTile(
                  leading: SizedBox(
                      height: 50,
                      width: 50,
                      child: Image.asset('assets/images/customer-service.png')),
                  titleAlignment: ListTileTitleAlignment.center,
                  title: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text('Bills'), Text('20 Jan 2020')],
                  ),
                  trailing: const Text(
                    '43s',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ).paddingOnly(top: 10)
          ],
        ),
      ),
    );
  }
}
