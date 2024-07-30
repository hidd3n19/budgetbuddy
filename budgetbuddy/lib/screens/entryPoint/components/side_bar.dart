import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../model/menu.dart';
import '../../../utils/rive_utils.dart';
import 'info_card.dart';
import 'side_menu.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  final user = FirebaseAuth.instance.currentUser;
  Menu selectedSideMenu = sidebarMenus.first;
  bool isLogoutSelected = false; // New state variable

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: 288,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF17203A),
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoCard(
                name: user?.email ?? 'Guest',
                bio: "Student",
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
                child: Text(
                  "Browse".toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white70),
                ),
              ),
              ...sidebarMenus.map((menu) => SideMenu(
                    menu: menu,
                    selectedMenu: selectedSideMenu,
                    press: () {
                      RiveUtils.chnageSMIBoolState(menu.rive.status!);
                      setState(() {
                        selectedSideMenu = menu;
                        isLogoutSelected = false; // Deselect logout when another menu is selected
                      });
                    },
                    riveOnInit: (artboard) {
                      menu.rive.status = RiveUtils.getRiveInput(artboard,
                          stateMachineName: menu.rive.stateMachineName);
                    },
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 40, bottom: 16),
                child: Text(
                  "History".toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white70),
                ),
              ),
              ...sidebarMenus2.map((menu) => SideMenu(
                    menu: menu,
                    selectedMenu: selectedSideMenu,
                    press: () {
                      RiveUtils.chnageSMIBoolState(menu.rive.status!);
                      setState(() {
                        selectedSideMenu = menu;
                        isLogoutSelected = false; // Deselect logout when another menu is selected
                      });
                    },
                    riveOnInit: (artboard) {
                      menu.rive.status = RiveUtils.getRiveInput(artboard,
                          stateMachineName: menu.rive.stateMachineName);
                    },
                  )),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isLogoutSelected = !isLogoutSelected; // Toggle highlight
                  });
                  Future.delayed(const Duration(milliseconds: 400), () {
                    FirebaseAuth.instance.signOut(); // Log out after delay
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.fastOutSlowIn,
                  decoration: BoxDecoration(
                    color: isLogoutSelected ? const Color.fromARGB(255, 255, 0, 0) : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 24, bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(color: Colors.white24, height: 3),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.delete,
                              color: Colors.white,
                            ),
                            SizedBox(width: 21), // Space between Icon and Text
                            Text(
                              'Log out',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
