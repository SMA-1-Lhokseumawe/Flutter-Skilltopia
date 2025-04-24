import 'package:flutter/material.dart';
import 'package:skilltopia/Beranda/BerandaContent.dart';
import 'package:skilltopia/Kuesioner/Kuesioner.dart';
import 'package:skilltopia/Materi/ListModul.dart';
import 'package:skilltopia/Quiz/ListQuiz.dart';
import 'package:skilltopia/TipsAndTrick/TipsAndTrick.dart';
import 'package:skilltopia/Nilai/NilaiSaya.dart';
import 'package:skilltopia/Notifikasi/Notifikasi.dart';
import 'package:skilltopia/Profile/Profile.dart';
import 'package:skilltopia/repository.dart';

class Beranda extends StatefulWidget {
  final String uuid;
  final String username;
  final String accessToken;

  const Beranda({
    Key? key,
    required this.uuid,
    required this.username,
    required this.accessToken,
  }) : super(key: key);

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  int _selectedIndex = 0;

  late String accessToken;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _screens = [
      BerandaContent(
        uuid: widget.uuid,
        username: widget.username,
        accessToken: widget.accessToken,
      ),
      NilaiSaya(uuid: widget.uuid, accessToken: widget.accessToken),
      Notifikasi(uuid: widget.uuid, username: widget.username, accessToken: widget.accessToken),
      ProfilePage(uuid: widget.uuid, accessToken: widget.accessToken),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            selectedItemColor: Color(0xFF27DEBF),
            unselectedItemColor: Colors.grey[400],
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            selectedFontSize: 12,
            unselectedFontSize: 11,
            iconSize: 24,
            elevation: 0,
            showUnselectedLabels: true,
            selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                activeIcon: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFF27DEBF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.home_rounded),
                ),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt_rounded),
                activeIcon: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFF27DEBF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.list_alt_rounded),
                ),
                label: 'Nilai',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications_none_rounded),
                activeIcon: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFF27DEBF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.notifications_none_rounded),
                ),
                label: 'Notifikasi',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_rounded),
                activeIcon: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFF27DEBF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.person_outline_rounded),
                ),
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
