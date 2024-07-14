import 'package:fiat_match/models/channel_detail.dart';
import 'package:fiat_match/models/country.dart';
import 'package:fiat_match/models/currency.dart';
import 'package:fiat_match/models/recipient.dart';
import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/provider/channel_detail_provider.dart';
import 'package:fiat_match/provider/new/country_provider.dart';
import 'package:fiat_match/provider/new/currency_provider.dart';
import 'package:fiat_match/provider/recipient_provider.dart';
import 'package:fiat_match/repositories/recipient_repository.dart';
import 'package:fiat_match/utils/constants.dart';
import 'package:fiat_match/utils/helper.dart';
import 'package:fiat_match/utils/size_config.dart';
import 'package:fiat_match/widgets/fm__home_screen_loader.dart';
import 'package:fiat_match/widgets/fm_deliver_bottomsheet.dart';
import 'package:fiat_match/widgets/fm_phone_bottomsheet.dart';
import 'package:fiat_match/widgets/fm_dialog.dart';
import 'package:fiat_match/widgets/new/fm_country_field.dart';

import 'package:fiat_match/widgets/new/fm_dropdown.dart';
import 'package:fiat_match/widgets/new/fm_input_fields.dart';
import 'package:fiat_match/widgets/new/fm_phone_field.dart';
import 'package:fiat_match/widgets/new/fm_submit_button.dart';
import 'package:fiat_match/widgets/fm_toast.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class AddNewRecipient extends StatefulWidget {
  final Beneficiaries? recipient;

  AddNewRecipient({this.recipient});

  @override
  _AddNewRecipientState createState() => _AddNewRecipientState();
}

class _AddNewRecipientState extends State<AddNewRecipient> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _countryController;
  // late TextEditingController _currencyController;

  late List<Country> _country;
  late Country _selectedCountry;
  late Country _selectPhoneCountry;
  // late Currencies _selectedCurrency;
  late TextEditingController _deliveryController;
  late bool _isLoading;
  late FToast _fToast;
  late RecipientRepository _recipientRepository;
  String _selectedCountryCode = '';
  bool _updateRecipient = false;
  late ChannelDetailProvider _channelDetailProvider;
  late List<Widget> _fields;
  late Map<String, TextEditingController> _controllers;
  var _selectedDeliveryMethod;
  late RecipientProvider _recipientProvider;

  @override
  void initState() {
    super.initState();
    _controllers = Map<String, TextEditingController>();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _countryController = TextEditingController();
    // _currencyController = TextEditingController();
    _deliveryController = TextEditingController();
    _country =
        Provider.of<CountryProvider>(context, listen: false).country.data!;

    _channelDetailProvider =
        Provider.of<ChannelDetailProvider>(context, listen: false);
    _recipientProvider = Provider.of<RecipientProvider>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _recipientProvider.resetChannel();
      _channelDetailProvider.resetChannelDetailState();
      if (widget.recipient != null) {
        _updateRecipient = true;
        reloadData();
      }
    });

    _selectedCountry = _country[0];
    _selectPhoneCountry = _country[0];
    _recipientRepository = RecipientRepository(context);
    _fToast = FToast();
    _fToast.init(context);
    _isLoading = false;

    _fields = [];
    _recipientProvider = Provider.of<RecipientProvider>(context, listen: false);
  }

  reloadData() async {
    setLoader(true);
    _firstNameController.text = widget.recipient!.firstName.toString();
    _lastNameController.text = widget.recipient!.lastName.toString();
    _phoneNumberController.text =
        widget.recipient!.phoneNumber!.number.toString();
    _emailController.text = widget.recipient!.email.toString();
    _selectPhoneCountry = _country
        .firstWhere((element) =>
            element.code == widget.recipient!.phoneNumber!.countryCode,orElse:()=> Country());

    _selectedCountry =
         _country.firstWhere((element) => element.code == widget.recipient!.countryCode,orElse:()=> Country() );

    _selectedCountryCode = _selectedCountry.code ?? '';

    _countryController.text = _selectedCountry.name ?? '';
   // _selectedCurrency = Provider.of<CurrencyProvider>(context,listen: false).currency.data!.currencies!.firstWhere((element) => element.code == widget.recipient!.channel?.first.currency, orElse:()=> Currencies());
   // _currencyController.text = _selectedCurrency.name ?? '';
    _deliveryController.text = widget.recipient!.channel!.length > 0 ? widget.recipient!.channel!.first.channelType! : '';
    _channelDetailProvider
        .getChannelDetailsByCountryCode(widget.recipient!.countryCode!);
    ChannelDetail response = await _recipientRepository
        .getChannelDetailsByCountryCode(widget.recipient!.countryCode!);
    _selectedDeliveryMethod = response.channelDetails!.firstWhere((element) =>
        element.countryCode == widget.recipient!.countryCode! &&
        element.channelType == widget.recipient!.channel!.first.channelType);
    setLoader(false);
  }

  Future<void> _addNewRecipient() async {
    try {
      setLoader(true);
      var _recipients = await _recipientRepository.addNewRecipient(
          _firstNameController.text.toString(),
          _lastNameController.text.toString(),
          _emailController.text.toString(),
          _selectedCountry.dialCode.toString(),
          _phoneNumberController.text.toString(),
          _selectedCountry.code.toString(),
          _selectedCountryCode);
      _recipientProvider.addChannel(_recipients.id!, _recipients.countryCode!,
          _deliveryController.text, null,_controllers);
      setLoader(false);

      Provider.of<RecipientProvider>(context, listen: false).getAllRecipients();

      _showDialog(context, _recipients);
    } catch (e) {
      _showToast(e.toString(), Icons.error);
      setLoader(false);
    }
  }

  Future<void> _update() async {
    try {
      setLoader(true);
      var _recipients = await _recipientRepository.updateRecipient(
          widget.recipient!.id.toString(),
          _firstNameController.text.toString(),
          _lastNameController.text.toString(),
          _emailController.text.toString(),
          _selectedCountry.dialCode.toString(),
          _phoneNumberController.text.toString(),
          _selectedCountry.code.toString(),
          _selectedCountryCode);
      var _updatechannel = await _recipientRepository.updateChannel(
          _recipients.id!,
          _recipients.channel!.first.id!,
          _selectedCountry.code.toString(),
          _deliveryController.text,
         '',
          _controllers);
      await Provider.of<RecipientProvider>(context, listen: false)
          .getAllRecipients();

      setLoader(false);

      _showDialog(context, _recipients);
    } catch (e) {
      _showToast(e.toString(), Icons.error);
      setLoader(false);
    }
  }

  setLoader(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: buildAppBar(),
      body: WillPopScope(
        onWillPop: () => _onBackPressed(),
        child: Container(
          padding: EdgeInsets.only(
              left: SizeConfig.resizeWidth(10.26),
              right: SizeConfig.resizeWidth(10.26),
              top: SizeConfig.resizeWidth(4.11),
              bottom: 50),
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Container(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                height: 16,
                              ),
                              FmInputFields(
                                title: 'First Name*',
                                obscureText: false,
                                textEditingController: _firstNameController,
                                textInputType: TextInputType.name,
                                textInputAction: TextInputAction.next,
                                autoFocus: false,
                                maxLines: 1,
                                onValidation: (value) {
                                  if (value.isEmpty) {
                                    return 'Required field';
                                  } else if (value.length < 2) {
                                    return 'Minimum 2 characters required';
                                  } else if (value.length > 50) {
                                    return 'Maximum 50 characters allowed';
                                  }
                                },
                              ),
                              _fieldSpacing(),
                              FmInputFields(
                                title: 'Last Name*',
                                obscureText: false,
                                textEditingController: _lastNameController,
                                textInputType: TextInputType.name,
                                textInputAction: TextInputAction.next,
                                autoFocus: false,
                                maxLines: 1,
                                onValidation: (value) {
                                  if (value.isEmpty) {
                                    return 'Required field';
                                  } else if (value.length < 2) {
                                    return 'Minimum 2 characters required';
                                  } else if (value.length > 50) {
                                    return 'Maximum 50 characters allowed';
                                  }
                                },
                              ),
                              _fieldSpacing(),
                              FmPhoneFields(
                                title: 'Phone Number*',
                                textEditingController: _phoneNumberController,
                                textInputAction: TextInputAction.next,
                                autoFocus: false,
                                maxLines: 1,
                                country: _country,
                                initialValue: _selectPhoneCountry,
                                selectedCountry: (value) {
                                  print(value.sampleNumber);
                                  setState(() {
                                    _selectPhoneCountry = value;
                                  });
                                  print(_selectPhoneCountry.name);
                                },
                              ),
                              _fieldSpacing(),
                              FmInputFields(
                                title: 'Email*',
                                obscureText: false,
                                textEditingController: _emailController,
                                textInputType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                autoFocus: false,
                                maxLines: 1,
                                onValidation: (value) {
                                  if (value.isEmpty) {
                                    return 'Required';
                                  } else if (!Helper.isValidEmail(value)) {
                                    return 'Invalid Email Address';
                                  }
                                },
                              ),
                              _fieldSpacing(),
                              FmCountryFields(
                                title: 'Country*',
                                textEditingController: _countryController,
                                maxLines: 1,
                                country: _country,
                                initialValue: _selectedCountry,
                                autoFocus: false,
                                selectedCountry: (Country) {
                                  setState(() {
                                    _selectedCountryCode = Country.code!;
                                    _countryController.text = Country.name!;
                                    _selectedCountry = Country;
                                    _deliveryController.text = '';
                                    _selectedDeliveryMethod = null;
                                    _channelDetailProvider
                                        .getChannelDetailsByCountryCode(
                                            Country.code!);
                                  });
                                },
                                textInputAction: TextInputAction.done,
                              ),
                              // _fieldSpacing(),
                              // FmDropdown(
                              //   textEditingController: _currencyController,
                              //   onTap: () {
                              //     _currencyBottomSheet(_currencyController);
                              //   },
                              //   title: 'Currency*',
                              //   onValidation: (value) {
                              //     if (value.isEmpty) {
                              //       return 'required';
                              //     }
                              //   },
                              //   maxLines: 1,
                              // ),
                              if (_countryController.text.isNotEmpty) ...[
                                _fieldSpacing(),
                                // _fieldTitle('Delivery method',
                                //     isMandatory: true),
                                FmDropdown(
                                  textEditingController: _deliveryController,
                                  onTap: () {
                                    _deliveryController.text = '';
                                    _deliveryMethodBottomSheet();
                                  },
                                  onValidation: (value) {
                                    if (value.isEmpty) {
                                      return 'Required';
                                    }
                                  },
                                  title: 'Delivery method*',
                                  maxLines: 1,
                                ),
                              ],
                              if (_selectedDeliveryMethod != null) ...[
                                dynamicForms(
                                    _selectedDeliveryMethod.fieldDetails!),
                                SizedBox(height: SizeConfig.resizeHeight(6.16)),
                              ],
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 24),
                                child: FmSubmitButton(
                                    text: _updateRecipient ? 'Update' : 'Save',
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        _updateRecipient
                                            ? await _update()
                                            : await _addNewRecipient();
                                        //Navigator.pop(context, true);
                                      }
                                    },
                                    showOutlinedButton: false),
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
  Future<bool> _onBackPressed() {
    return _showCancelDialogDialog(context);
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        _updateRecipient ? 'Update Recipient' : 'Add Recipient',
        style: TextStyle(
            fontSize: SizeConfig.resizeFont(12.31),
            fontWeight: FontWeight.w500),
      ),
      leading: new IconButton(
        icon: new Icon(Icons.arrow_back_ios_new),
        onPressed: () {
          _showCancelDialogDialog(context);
        },
      ),
      centerTitle: true,
      elevation: 1,
      leadingWidth: 105,
    );
  }

  Widget _fieldTitle(String title, {bool isMandatory = false}) {
    title = isMandatory ? title + '*' : title;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
            color: Color(0xFF4F4F4F),
            fontSize: 12,
            fontWeight: FontWeight.w400),
      ),
    );
  }

  void _phoneCodeBottomSheet() {
    setState(() {
      _deliveryController.clear();
      _selectedDeliveryMethod = null;
    });
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (builder) {
          return FmPhoneBottomSheet(
              country: _country,
              initialValue: _selectedCountry,
              selectedCountry: (value) {
                setState(() {
                  _selectedCountryCode = value.code!;
                  _countryController.text = value.name!;
                  _channelDetailProvider
                      .getChannelDetailsByCountryCode(value.code!);
                });
              });
        });
  }

  void _deliveryMethodBottomSheet() {
    setState(() {
      _selectedDeliveryMethod = null;
    });
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), topRight: Radius.circular(8))),
        builder: (builder) {
          return Consumer<ChannelDetailProvider>(
              builder: (context, response, child) {
            if (response.channelDetail.status == Status.COMPLETED) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                ),
                padding: const EdgeInsets.only(top: 16.0),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount:
                        response.channelDetail.data!.channelDetails!.length,
                    itemBuilder: (BuildContext context, int index) {
                      var item =
                          response.channelDetail.data!.channelDetails![index];
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _deliveryController.text = item.channelType!;
                            _selectedDeliveryMethod = item;
                            Navigator.of(context).pop();
                          });
                        },
                        child: FmDeliveryBottomSheetItem(channel: item),
                      );
                    }),
              );
            } else if (response.channelDetail.status == Status.ERROR) {
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                _showToast(response.channelDetail.message, Icons.error);
              });
              return Container();
            } else if (response.channelDetail.status == Status.LOADING) {
              return FmHomeScreenLoader();
            } else {
              return Container();
            }
          });
        });
  }

  @override
  void dispose() {
    super.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _countryController.dispose();
  }

  _showToast(String? msg, IconData icon) {
    _fToast.showToast(
      child: FmToast(
        message: msg,
        icon: icon,
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  _showDialog(BuildContext _context, Beneficiaries recipient) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return FmDialogWidget(
              iconData: Icons.check_circle,
              title:
                  _updateRecipient ? 'Recipient Updated' : 'Recipient Created',
              buttonText: 'Ok',
              message: 'Recipient ${_updateRecipient? 'updated': 'added'} successfully',
              voidCallback: () {
                Navigator.pop(context);
                Navigator.pop(context);
              });
        });
  }

  Widget dynamicForms(List<FieldDetails> channelDetail) {
    _fields = [];

    channelDetail.forEach((element) {
      if (element.type == Helper.getEnumValue(FieldType.text.toString())) {
        RegExp regExp = RegExp(element.regex.toString());
        TextEditingController textEditingController = TextEditingController();
        if (widget.recipient != null &&
            widget.recipient!.channel!.first.fieldDetails != null &&
            widget.recipient!.channel!.first.fieldDetails[element.code] !=
                null) {
          print(widget.recipient!.channel!.first);
          textEditingController.text =
              widget.recipient!.channel!.first.fieldDetails[element.code];
        }
        _fields.add(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          key: ValueKey(element.label.toString()),
          children: [
            _fieldSpacing(),
            // _fieldTitle(element.label.toString(),
            //     isMandatory: element.isMandatory!),
            FmInputFields(
                title: element.isMandatory!
                    ? element.label.toString() + '*'
                    : element.label.toString(),
                obscureText: false,
                textEditingController: textEditingController,
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.done,
                onValidation: (value) {
                  if (element.isMandatory! && value.isEmpty) {
                    return 'required';
                  } else if (!regExp.hasMatch(value)) {
                    return 'Invalid input';
                  }
                },
                autoFocus: false,
                maxLines: 1),
          ],
        ));
        _controllers.putIfAbsent(element.code!, () => textEditingController);
      } else if (element.type ==
          Helper.getEnumValue(FieldType.select.toString())) {
        TextEditingController textEditingController = TextEditingController();

        _controllers.putIfAbsent(element.code!, () => textEditingController);
        if (widget.recipient != null &&
            widget.recipient?.channel!.first.fieldDetails != null &&
            widget.recipient?.countryCode! == _selectedCountryCode) {
          textEditingController.text =
              widget.recipient?.channel?.first.fieldDetails[element.code] ?? '';
        }
        // _fields.add(
        //   Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     key: ValueKey(element.label.toString()),
        //     children: [
        //       _fieldSpacing(),
        //       // _fieldTitle(element.label.toString(),
        //       //     isMandatory: element.isMandatory!),
        //       FmDropdown(
        //         textEditingController: textEditingController,
        //         onTap: () {
        //           _currencyBottomSheet(textEditingController);
        //         },
        //         title: element.isMandatory!
        //             ? element.label.toString() + '*'
        //             : element.label.toString(),
        //         onValidation: (value) {
        //           if (value.isEmpty) {
        //             return 'required';
        //           }
        //         },
        //         maxLines: 1,
        //       ),
        //     ],
        //   ),
        // );
      }
    });
    return Column(
      children: _fields,
    );
  }

  // void _currencyBottomSheet(TextEditingController textEditingController) {
  //   showModalBottomSheet(
  //       isScrollControlled: true,
  //       context: context,
  //       builder: (builder) {
  //         return Container(
  //           color: Color(0xFF737373),
  //           child: Container(
  //             padding: EdgeInsets.all(16),
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.only(
  //                 topLeft: Radius.circular(12.0),
  //                 topRight: Radius.circular(12.0),
  //               ),
  //             ),
  //             child: Consumer<CurrencyProvider>(
  //               builder: (context, response, child) {
  //                 if (response.currency.status == Status.COMPLETED) {
  //                   return ListView.builder(
  //                     shrinkWrap: true,
  //                     itemCount: response.currency.data?.currencies?.length,
  //                     itemBuilder: (BuildContext context, int index) {
  //                       return ListTile(
  //                         onTap: () {
  //                           textEditingController.text =
  //                               '${response.currency.data?.currencies?[index].name}';
  //                           _selectedCurrency = response.currency.data!.currencies![index];
  //                           Navigator.of(context).pop();
  //                         },
  //                         leading: CircleAvatar(
  //                           backgroundColor: Colors.transparent,
  //                           child: Image.asset(
  //                             'flags/${response.currency.data?.currencies?[index].code.toString().toLowerCase()}.png',
  //                             width: 36,
  //                           ),
  //                         ),
  //                         title: Text(
  //                             '${response.currency.data?.currencies?[index].name}'),
  //                       );
  //                     },
  //                   );
  //                 } else {
  //                   return Container();
  //                 }
  //               },
  //             ),
  //           ),
  //         );
  //       });
  // }

  _showCancelDialogDialog(BuildContext _context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return FmDialogWidget(
              iconData: Icons.info,
              title: '',
              buttonText: 'Yes',
              secondButtonText: 'Cancel',
              secondButtonCallback: () => Navigator.pop(context, true),
              message:
                  'You have not saved your changes. Do you wish to continue?',
              voidCallback: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              });
        });
  }
}

class _fieldSpacing extends StatelessWidget {
  const _fieldSpacing({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: SizeConfig.resizeHeight(6.16));
  }
}
