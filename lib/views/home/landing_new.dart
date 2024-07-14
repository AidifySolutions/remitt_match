import 'package:fiat_match/chat/chat.dart';
import 'package:fiat_match/chat/chat_provider.dart';
import 'package:fiat_match/chat/chat_room_list.dart';
import 'package:fiat_match/models/transaction_history.dart';
import 'package:fiat_match/utils/constants.dart';
import 'package:fiat_match/utils/size_config.dart';
import 'package:fiat_match/views/Notification/notification.dart';
import 'package:fiat_match/views/drawer/navigation_drawer.dart';
import 'package:fiat_match/views/recipient/recipients.dart';
import 'package:fiat_match/views/send_money/send_money.dart';
import 'package:fiat_match/views/transaction_history/transaction_history.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingNewPage extends StatefulWidget {
  final int tabSelection;
  const LandingNewPage({Key? key, this.tabSelection = 0}) : super(key: key);
  @override
  _LandingNewPageState createState() => _LandingNewPageState();
}

class _LandingNewPageState extends State<LandingNewPage> {
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  int _selectedTab = 0;
  List<String> _appBarTitle = [
    'Send Money',
    'Recipients',
    'Notifications',
    'Active Trades'
  ];
  final List<Widget> _widgetOptions = <Widget>[
    SendMoney(),
    Recipients(),
    AppNotifications(),
    Transaction(
      activeTrade: true,
    )
  ];

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.tabSelection;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: buildAppBar(title: _appBarTitle[_selectedTab]),
      drawer: NavigationDrawer(),
      bottomNavigationBar: _bottomNavigationBar(),
      body: _widgetOptions.elementAt(_selectedTab),
    );
  }

  AppBar buildAppBar({String title = 'Send money'}) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
            fontSize: SizeConfig.resizeFont(12.31),
            fontWeight: FontWeight.w500),
      ),
      centerTitle: true,
      elevation: 1,
      leading: InkWell(
        onTap: () {

          setState(() {
            _selectedTab = 0;
          });
          _key.currentState!.openDrawer();
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Container(
          padding: EdgeInsets.all(18),
          child: Image.asset(
            'assets/hamburger.png',
            fit: BoxFit.contain,
            width: SizeConfig.resizeWidth(5.61),
            height: SizeConfig.resizeHeight(5.61),
          ),
        ),
      ),
      leadingWidth: 105,
      actions: [
        Visibility(
          visible: Constants.featureVisibilty,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChatRoomList(),
                ),
              );
            },
            child: Image.asset(
              'assets/new_message.png',
              width: SizeConfig.resizeWidth(25),
            ),
          ),
        )
      ],
    );
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).appBarTheme.foregroundColor,
      unselectedItemColor: Theme.of(context).appBarTheme.foregroundColor,
      currentIndex: _selectedTab,
      backgroundColor: Colors.white,
      selectedFontSize: 12,
      onTap: (index) {
        setState(() {
          _selectedTab = index;
        });
      },
      items: [
        BottomNavigationBarItem(
            icon: Image.asset(
              'assets/home.png',
              width: SizeConfig.resizeWidth(6.2),
              color: _selectedTab == 0
                  ? Theme.of(context).appBarTheme.foregroundColor
                  : Color(0xffC4C4C4),
            ),
            label: 'Home'),
        BottomNavigationBarItem(
            icon: Image.asset(
              'assets/recipients.png',
              width: SizeConfig.resizeWidth(6.16),
              color: _selectedTab == 1
                  ? Theme.of(context).appBarTheme.foregroundColor
                  : Color(0xffC4C4C4),
            ),
            label: 'Recipients'),
        BottomNavigationBarItem(
            icon: Image.asset(
              'assets/bell.png',
              width: SizeConfig.resizeWidth(6.16),
              color: _selectedTab == 2
                  ? Theme.of(context).appBarTheme.foregroundColor
                  : Color(0xffC4C4C4),
            ),
            label: 'Notifications'),
        BottomNavigationBarItem(
            icon: Image.asset(
              'assets/people-trading.png',
              width: SizeConfig.resizeWidth(6.16),
              color: _selectedTab == 3
                  ? Theme.of(context).appBarTheme.foregroundColor
                  : Color(0xffC4C4C4),
            ),
            label: 'Active trades'),
      ],
    );
  }
}
