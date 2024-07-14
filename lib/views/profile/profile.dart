import 'package:fiat_match/models/customer.dart';
import 'package:fiat_match/provider/new/country_provider.dart';
import 'package:fiat_match/provider/new/login_provider.dart';
import 'package:fiat_match/utils/constants.dart';
import 'package:fiat_match/utils/size_config.dart';
import 'package:fiat_match/views/profile/country_selection.dart';
import 'package:fiat_match/views/profile/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late CustomerData? _customer;
  late CountryProvider _countryProvider;

  @override
  void initState() {
    super.initState();
    _countryProvider = Provider.of<CountryProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    _customer = Provider.of<LoginProvider>(context, listen: false)
        .authentication
        .data
        ?.customerData;
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: buildAppBar(),
      body: SafeArea(
        child: Container(
          padding:
              EdgeInsets.symmetric(horizontal: SizeConfig.resizeWidth(13.35)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                profilePic(),
                infoListTile(
                  'First Name',
                  _customer?.firstName,
                  'assets/person.png',
                  true,
                  () {
                    goToNewScreen(EditProfile(
                        profileFields: ProfileFields.FirstName,
                        maxLines: 1,
                        value: _customer?.firstName));
                  },
                ),
                buildDivider(context),
                infoListTile(
                  'Last Name',
                  _customer?.lastName.toString(),
                  'assets/person.png',
                  true,
                  () {
                    goToNewScreen(EditProfile(
                        profileFields: ProfileFields.LastName,
                        maxLines: 1,
                        value: _customer?.lastName.toString()));
                  },
                ),
                buildDivider(context),
                infoListTile(
                  'Country',
                  _customer?.country == null
                      ? ""
                      : _countryProvider
                          .getCountryNameByCode(_customer?.country.toString()),
                  'assets/country.png',
                  true,
                  () {
                    goToNewScreen(CountrySelection());
                  },
                ),
                buildDivider(context),
                infoListTile(
                  'Address',
                  _customer?.address1.toString(),
                  'assets/location.png',
                  true,
                  () {
                    goToNewScreen(EditProfile(
                        profileFields: ProfileFields.Address,
                        maxLines: 5,
                        value: _customer?.address1.toString()));
                  },
                ),
                buildDivider(context),
                infoListTile(
                    'Phone Number',
                    '+${_customer?.phoneNumber?.dialCode} ${_customer?.phoneNumber?.number}'
                        .toString(),
                    'assets/call.png',
                    false, () {
                  goToNewScreen(
                    EditProfile(
                        profileFields: ProfileFields.PhoneNumber,
                        maxLines: 1,
                        value:
                            '${_customer?.phoneNumber?.countryCode}|${_customer?.phoneNumber?.number}'),
                  );
                }),
                buildDivider(context),
                infoListTile(
                  'Email',
                  _customer?.email.toString(),
                  'assets/message.png',
                  false,
                  () {
                    goToNewScreen(EditProfile(
                        profileFields: ProfileFields.Email,
                        maxLines: 1,
                        value: _customer?.email.toString()));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Divider buildDivider(BuildContext context) {
    return Divider(
      color: Theme.of(context).textTheme.bodyText2!.color,
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text('Profile'),
      leadingWidth: SizeConfig.resizeWidth(26),
      titleTextStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: SizeConfig.resizeFont(11.22),
          color: Theme.of(context).appBarTheme.foregroundColor),
    );
  }

  Widget infoListTile(
      String? title, String? subTitle, String icon, bool canEdit,
      [VoidCallback? onTap]) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 0),
      onTap: () => onTap != null ? onTap() : null,
      leading: Container(
        padding: EdgeInsets.only(left: 10),
        height: double.infinity,
        child: Image.asset(
          icon,
          width: SizeConfig.resizeWidth(4),
          color: Colors.black,
        ),
      ),
      title: Text(
        title.toString(),
        style: TextStyle(
            fontSize: SizeConfig.resizeFont(8.42), fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subTitle.toString().isEmpty ? 'Required' : subTitle.toString(),
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: SizeConfig.resizeFont(8.42),
            fontWeight: FontWeight.w400,
            color: subTitle.toString().isEmpty
                ? Colors.orange
                : Theme.of(context).textTheme.bodyText2!.color),
      ),
      trailing: Icon(
        Icons.keyboard_arrow_right,
        color: Color(0xff555555),
      ),
    );
  }

  Widget profilePic() {
    return Container(
      margin: EdgeInsets.only(
        top: SizeConfig.resizeHeight(9.35),
        bottom: SizeConfig.resizeHeight(4),
      ),
      child: Align(
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          child: Image.asset(
            'assets/profile.png',
            width: SizeConfig.resizeWidth(37.15),
            height: SizeConfig.resizeHeight(37.15),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  goToNewScreen(Widget screen) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
    setState(() {});
  }
}
