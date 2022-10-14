import 'package:flutter/material.dart';
import 'package:tactibetter/api/login.dart';
import 'package:tactibetter/pages/about.dart';
import 'package:tactibetter/pages/schedule.dart';
import 'package:tactibetter/pages/timesheet/timesheet.dart';
import 'package:tactibetter/util/prefs.dart';
import 'package:tactibetter/views/login.dart';

class HomeView extends StatefulWidget {
  final Session session;

  const HomeView({Key? key, required this.session}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  int _navIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getAppBar(),
      body: _getNavigationPages()[_navIdx],
      bottomNavigationBar: BottomNavigationBar(
        items: _getNavigationItems(),
        currentIndex: _navIdx,
        onTap: (idx) {
          setState(() {
            _navIdx = idx;
          });
        },
      ),
    );
  }

  AppBar _getAppBar() {
    return AppBar(
      title: const Text('TactiBeter'),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await Prefs.removeSessionId();

            if(!mounted) return;
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (builder) => const LoginView()));
          },
        )
      ]
    );
  }

  List<Widget> _getNavigationPages() {
    return [
      SchedulePage(session: widget.session),
      TimesheetPage(session: widget.session),
      const AboutPage(),
    ];
  }

  List<BottomNavigationBarItem> _getNavigationItems() {
    return [
      const BottomNavigationBarItem(
        icon: Icon(Icons.schedule),
        label: 'Mijn Rooster'
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.hourglass_empty_sharp),
        label: "Urenregistratie",
      ),
      const BottomNavigationBarItem(
          icon: Icon(Icons.info_outline),
          label: 'Over'
      ),
    ];
  }
}