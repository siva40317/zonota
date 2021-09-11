
import 'package:flutter/material.dart';
import 'package:zonota/common/colors.dart';
import 'package:zonota/pages/notes_page.dart';
import 'package:zonota/pages/settings_page.dart';
import 'package:zonota/pages/tasks_page.dart';
import 'package:zonota/repositories/repository.dart';
import 'my_tasks_page.dart';


class HomeContainer extends StatefulWidget {
  HomeContainer({Key key}) : super(key: key);

  @override
  _HomeContainerState createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {

  int _current_index=0;

  List<Widget> fragments =[TasksPage(),NotesPage(),SettingsPage()];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: AppColors.colorFromHex(AppColors.primary),
        unselectedItemColor: Colors.grey.shade300,
        type: BottomNavigationBarType.fixed,
        currentIndex: _current_index,
        items: [
          _bottomIcons(Icons.home,"Tasks"),
          _bottomIcons(Icons.star_border,"Notes"),
          _bottomIcons(Icons.person,"Profile"),
        ],

        onTap:(index)
        {
          setState(() {
            _current_index = index;
          });
        },



      ),
      body:
      Container(
        child:fragments[_current_index],
      ),
    );
  }


  BottomNavigationBarItem _bottomIcons(IconData icon,String title) {
    return BottomNavigationBarItem(icon: Icon(icon), title: Text(title));
  }

}