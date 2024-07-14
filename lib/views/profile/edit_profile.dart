import 'package:fiat_match/models/country.dart';
import 'package:fiat_match/models/customer.dart';
import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/provider/new/country_provider.dart';
import 'package:fiat_match/provider/new/customer_provider.dart';
import 'package:fiat_match/provider/new/login_provider.dart';
import 'package:fiat_match/utils/constants.dart';
import 'package:fiat_match/utils/size_config.dart';
import 'package:fiat_match/views/login/login.dart';
import 'package:fiat_match/widgets/fm_dialog.dart';
import 'package:fiat_match/widgets/new/fm_input_fields.dart';
import 'package:fiat_match/widgets/new/fm_phone_field.dart';
import 'package:fiat_match/widgets/new/fm_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  final ProfileFields profileFields;
  final int maxLines;
  final String? value;

  EditProfile(
      {required this.profileFields,
      required this.maxLines,
      required this.value});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _textEditingController;
  late CustomerData? _customer;
  late CustomerProvider _customerProvider;

  late List<Country> _country;
  late Country _selectedCountry;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _textEditingController.text = widget.value.toString();

    _customerProvider = Provider.of<CustomerProvider>(context, listen: false);
    _customerProvider.reset();

    _customer = Provider.of<LoginProvider>(context, listen: false)
        .authentication
        .data
        ?.customerData;

    if (widget.profileFields == ProfileFields.PhoneNumber) {
      var phoneDetail = widget.value.toString().split("|");
      _textEditingController.text = phoneDetail[1];
      _country =
          Provider.of<CountryProvider>(context, listen: false).country.data!;
      _selectedCountry =
          _country.where((element) => element.code == phoneDetail[0]).first;
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: buildAppBar(context),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(
            left: SizeConfig.resizeWidth(9.35),
            right: SizeConfig.resizeWidth(9.35),
            bottom: SizeConfig.resizeWidth(9.35),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.resizeHeight(3.74),
                ),
                child: Text(
                  'Please enter your ${_getFieldName().toString().toLowerCase()}.',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: SizeConfig.resizeFont(8.42),
                      fontWeight: FontWeight.w400),
                ),
              ),
              Form(
                key: _formKey,
                child: widget.profileFields == ProfileFields.PhoneNumber
                    ? FmPhoneFields(
                        title: 'Phone Number',
                        textEditingController: _textEditingController,
                        textInputAction: TextInputAction.done,
                        autoFocus: false,
                        fillColor: true,
                        maxLines: 1,
                        country: _country,
                        initialValue: _selectedCountry,
                        selectedCountry: (value) {
                          setState(() {
                            _selectedCountry = value;
                          });
                        })
                    : FmInputFields(
                        title: _getFieldName(),
                        obscureText: false,
                        fillColor: true,
                        textEditingController: _textEditingController,
                        textInputType:
                            widget.profileFields == ProfileFields.Email
                                ? TextInputType.emailAddress
                                : TextInputType.text,
                        textInputAction: TextInputAction.done,
                        maxLines: widget.maxLines,
                        autoFocus: true,
                        onValidation: (value) {
                          if (value.isEmpty) {
                            return 'Required';
                          }
                        }),
              ),
              Expanded(
                child: SizedBox(
                  height: 10,
                ),
              ),
              Consumer<CustomerProvider>(builder: (context, response, child) {
                if (response.customer.status == Status.LOADING) {
                  return Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator());
                } else if (response.customer.status == Status.COMPLETED) {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    var split = widget.value.toString().trim().split('|');
                    if ((widget.profileFields == ProfileFields.Email &&
                            widget.value != _textEditingController.text) ||
                        (widget.profileFields == ProfileFields.PhoneNumber &&
                            (split[1] != _textEditingController.text.trim() ||
                                split[0] != _selectedCountry.code))) {
                      _showDialog(
                          'Please sign in again to verify your ${_getFieldName().toString().toLowerCase()}.',
                          'Continue',
                          Icons.check_circle,
                          logout: true);
                    } else {
                      Navigator.pop(context);
                    }
                  });
                  return buildSaveButton();
                } else if (response.customer.status == Status.ERROR) {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    _showDialog(response.customer.message.toString(), 'Close',
                        Icons.error);
                    _customerProvider.reset();
                  });
                  return buildSaveButton();
                } else {
                  return buildSaveButton();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  FmSubmitButton buildSaveButton() {
    return FmSubmitButton(
        text: 'Save',
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _customerProvider.updateCustomer(_customer?.id, _getRequestBody());
          }
        },
        showOutlinedButton: false);
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Profile Update'),
      leadingWidth: SizeConfig.resizeWidth(26),
      titleTextStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: SizeConfig.resizeFont(11.22),
          color: Theme.of(context).appBarTheme.foregroundColor),
    );
  }

  _getFieldName() {
    if (widget.profileFields == ProfileFields.FirstName) {
      return 'First Name';
    } else if (widget.profileFields == ProfileFields.LastName) {
      return 'Last Name';
    } else if (widget.profileFields == ProfileFields.Country) {
      return 'Country';
    } else if (widget.profileFields == ProfileFields.Address) {
      return 'Address';
    } else if (widget.profileFields == ProfileFields.PhoneNumber) {
      return 'Phone Number';
    } else if (widget.profileFields == ProfileFields.Email) {
      return 'Email';
    }
  }

  Map<String, dynamic> _getRequestBody() {
    var phone = {
      "dialCode": _customer?.phoneNumber?.dialCode,
      "number": _customer?.phoneNumber?.number,
      "countryCode": _customer?.phoneNumber?.countryCode,
    };
    var body = {
      "title": _customer?.title,
      "firstName": _customer?.firstName,
      "lastName": _customer?.lastName,
      "bio": _customer?.bio,
      "nickName": _customer?.nickName,
      "dateOfBirth": _customer?.dateOfBirth,
      "phoneNumber": _customer?.phoneNumber,
      "email": _customer?.email,
      "address1": _customer?.address1,
      "address2": _customer?.address2,
      "city": _customer?.city,
      "occupation": _customer?.occupation,
      "employment": _customer?.employment,
      "incomeSource": _customer?.incomeSource,
      "country": _selectedCountry,
    };
    if (widget.profileFields == ProfileFields.FirstName) {
      body["firstName"] = _textEditingController.text.toString();
    } else if (widget.profileFields == ProfileFields.LastName) {
      body["lastName"] = _textEditingController.text.toString();
    } else if (widget.profileFields == ProfileFields.Address) {
      body["address1"] = _textEditingController.text.toString();
    } else if (widget.profileFields == ProfileFields.Email) {
      body["email"] = _textEditingController.text.toString();
    } else if (widget.profileFields == ProfileFields.PhoneNumber) {
      phone["dialCode"] = _selectedCountry.dialCode;
      phone["number"] = _textEditingController.text.toString();
    }

    return body;
  }

  _showDialog(String title, String buttonText, IconData icon,
      {bool logout = false}) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return FmDialogWidget(
              iconData: icon,
              title: title,
              message: '',
              buttonText: buttonText,
              voidCallback: () async {
                if (logout) {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                    (Route<dynamic> route) => false,
                  );
                } else {
                  Navigator.pop(dialogContext);
                }
              });
        });
  }
}
