import 'package:fiat_match/models/customer.dart';
import 'package:fiat_match/provider/new/login_provider.dart';
import 'package:fiat_match/utils/size_config.dart';
import 'package:fiat_match/views/change_password/change_password.dart';
import 'package:fiat_match/views/customer_care/customer_care.dart';
import 'package:fiat_match/views/identity_verification/identity_verification.dart';
import 'package:fiat_match/views/login/login.dart';
import 'package:fiat_match/views/profile/profile_new.dart';
import 'package:fiat_match/views/transaction_history/transaction_history.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  late CustomerData? _customerData;

  @override
  void initState() {
    super.initState();
    _customerData = Provider.of<LoginProvider>(context, listen: false)
        .authentication
        .data
        ?.customerData;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.resizeWidth(75),
      child: Drawer(
        child: Container(
          padding: EdgeInsets.only(
            left: SizeConfig.resizeWidth(5),
            right: SizeConfig.resizeWidth(1),
          ),
          color: Theme.of(context).appBarTheme.foregroundColor,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: SizeConfig.resizeHeight(15),
                  left: SizeConfig.resizeWidth(3.5),
                  bottom: SizeConfig.resizeHeight(2),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      'assets/drawer_cross.png',
                      color: Colors.white,
                      // fit: BoxFit.contain,
                      width: SizeConfig.resizeWidth(5.61),
                      //height: SizeConfig.resizeWidth(5.61),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.only(
                    top: SizeConfig.resizeHeight(0),
                  ),
                  shrinkWrap: true,
                  children: [
                    // profilePicTile(),
                    // SizedBox(
                    //   height: SizeConfig.resizeHeight(5.5),
                    // ),
                    Consumer<LoginProvider>(
                        builder: (context, response, child) {
                      return buildMenuTile('assets/person.png', 'Profile',
                          showChip: true,
                          chipStatus: response.authentication.data?.customerData
                                  ?.profileStatus?.status ??
                              '', onTap: () {
                        goToNewScreen(Profile());
                      });
                    }),
                    buildMenuTile(
                        'assets/transaction.png', 'Transaction History',
                        onTap: () {
                      goToNewScreen(Transaction());
                    }),
                    Padding(
                      padding: EdgeInsets.only(
                          right: SizeConfig.resizeWidth(7.71),
                          left: SizeConfig.resizeWidth(2.56)),
                      child: Divider(color: Color(0xffFFFFFF)),
                    ),
                    buildMenuTile(
                        'assets/change_password.png', 'Change Password',
                        onTap: () {
                      goToNewScreen(ChangePassword());
                    }),
                    Consumer<LoginProvider>(
                        builder: (context, response, child) {
                      return buildMenuTile(
                          'assets/baseline_verification.png', 'Identity Verification',
                          showChip: true,
                          chipStatus: response.authentication.data?.customerData
                                  ?.livenessStatus?.status ??
                              '', onTap: () {
                        goToNewScreen(IdentityVerification());
                      });
                    }),
                    Padding(
                      padding: EdgeInsets.only(
                          right: SizeConfig.resizeWidth(7.71),
                          left: SizeConfig.resizeWidth(2.56)),
                      child: Divider(color: Color(0xffFFFFFF)),
                    ),
                    // buildMenuTile('assets/settings.png', 'Settings'),
                    buildMenuTile('assets/customer_care.png', 'Customer Care',
                        onTap: () {
                      goToNewScreen(CustomerCare());
                    }),
                    buildMenuTile('assets/log_out.png', 'Log out', onTap: () {
                      context.read<LoginProvider>().reset();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                          (Route<dynamic> route) => false);
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding profilePicTile() {
    return Padding(
      padding: EdgeInsets.only(
        left: SizeConfig.resizeWidth(3.74),
        //bottom: SizeConfig.resizeHeight(5.5),
      ),
      child: Row(
        children: [
          profilePic(),
          SizedBox(
            width: SizeConfig.resizeWidth(3.74),
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: SizeConfig.resizeHeight(1),
                ),
                Text(
                  '${_customerData?.firstName} ${_customerData?.lastName}',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget profilePic() {
    return Container(
      child: Align(
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          child: Image.asset(
            'assets/profile.png',
            width: SizeConfig.resizeWidth(14.96),
            height: SizeConfig.resizeHeight(14.96),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  InkWell buildMenuTile(String asset, String title,
      {bool showChip = false, String chipStatus = "", VoidCallback? onTap}) {
    return InkWell(
      onTap: () => onTap!(),
      child: Padding(
        padding: EdgeInsets.only(
            left: SizeConfig.resizeWidth(3.74),
            top: SizeConfig.resizeHeight(6),
            bottom: SizeConfig.resizeHeight(6)),
        child: Row(
          children: [
            Image.asset(
              asset,
              width: SizeConfig.resizeWidth(5.61),
            ),
            SizedBox(
              width: SizeConfig.resizeWidth(
                SizeConfig.resizeWidth(1.3),
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: SizeConfig.resizeFont(8.42),
              ),
            ),
            SizedBox(
              width: SizeConfig.resizeWidth(
                SizeConfig.resizeWidth(0.3),
              ),
            ),
            showChip
                ? Container(
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.resizeWidth(1.29),
                        horizontal: SizeConfig.resizeWidth(2.06)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                      color: Color(getStatusColor(chipStatus)),
                    ),
                    child: Text(
                      getStatusMsg(chipStatus),
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: SizeConfig.resizeFont(7.01),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  goToNewScreen(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  int getStatusColor(String status) {
    switch (status) {
      case 'Incomplete':
        return 0xffFB7800; //orange
      case 'Verified':
        return 0xff2FBF71; //green
      case 'Rejected':
        return 0xffFF0B0B; //red
      case 'Pending':
        return 0xffFB7800; //orange
      default:
        return 0xffFFFFFF;
    }
  }

  String getStatusMsg(String status) {
    switch (status) {
      case 'Incomplete':
        return 'Incomplete'; //orange
      case 'Verified':
        return 'Verified'; //green
      case 'Rejected':
        return 'Rejected'; //red
      case 'Pending':
        return 'In Reviewal'; //orange
      default:
        return '';
    }
  }
}
