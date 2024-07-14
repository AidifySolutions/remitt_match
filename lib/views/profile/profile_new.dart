import 'package:fiat_match/models/city.dart';
import 'package:fiat_match/models/country.dart';
import 'package:fiat_match/models/customer.dart';
import 'package:fiat_match/models/province.dart';
import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/provider/new/city_provider.dart';
import 'package:fiat_match/provider/new/country_provider.dart';
import 'package:fiat_match/provider/new/customer_provider.dart';
import 'package:fiat_match/provider/new/document_provider.dart';
import 'package:fiat_match/provider/new/login_provider.dart';
import 'package:fiat_match/provider/new/province_provider.dart';
import 'package:fiat_match/utils/helper.dart';
import 'package:fiat_match/utils/size_config.dart';
import 'package:fiat_match/views/login/login.dart';
import 'package:fiat_match/widgets/fm_dialog.dart';
import 'package:fiat_match/widgets/new/fm_country_field.dart';
import 'package:fiat_match/widgets/new/fm_dropdown.dart';

import 'package:fiat_match/widgets/new/fm_input_fields.dart';
import 'package:fiat_match/widgets/new/fm_phone_field.dart';
import 'package:fiat_match/widgets/new/fm_submit_button.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late TextEditingController _firstNameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _countryController;
  late TextEditingController _emailController;
  late TextEditingController _dateOfBirthController;
  late TextEditingController _titleController;
  late TextEditingController _lastNameController;
  late TextEditingController _bioController;
  late TextEditingController _nicknameController;
  late TextEditingController _address1Controller;
  late TextEditingController _address2Controller;
  late TextEditingController _cityController;
  late TextEditingController _provinceController;
  late TextEditingController _occupationController;
  late TextEditingController _employmentController;
  late TextEditingController _incomeSourceController;

  late List<Country>? _country;
  late Province? _province;
  late List<String> _titleList;
  late List<Provinces> _provinces;
  late Country? _selectedCountry;
  late DocumentProvider _documentProvider;
  late Country? _selectPhoneCountry;
  late CustomerData? _customer;
  bool todoLogOut = false;
  bool isCountryChange = false;
  DateTime _todayDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();

  XFile? _profileImageFile;
  final picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _firstNameController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _emailController = TextEditingController();
    _countryController = TextEditingController();
    _dateOfBirthController = TextEditingController();
    _titleController = TextEditingController();
    _lastNameController = TextEditingController();
    _bioController = TextEditingController();
    _nicknameController = TextEditingController();
    _address1Controller = TextEditingController();
    _address2Controller = TextEditingController();
    _cityController = TextEditingController();
    _provinceController = TextEditingController();
    _occupationController = TextEditingController();
    _employmentController = TextEditingController();
    _incomeSourceController = TextEditingController();

    _country =
        Provider.of<CountryProvider>(context, listen: false).country.data!;

    _documentProvider = Provider.of<DocumentProvider>(context, listen: false);

    _selectedCountry = _country?[0];
    _selectPhoneCountry = _country?[0];

    _countryController.text = _selectedCountry?.name ?? '';
    _titleList = ['Mr', 'Miss', 'Mrs.'];

    _customer = Provider.of<LoginProvider>(context, listen: false)
        .authentication
        .data
        ?.customerData;
    _titleController.text = _customer?.title ?? '';
    _firstNameController.text = _customer?.firstName ?? '';
    _lastNameController.text = _customer?.lastName ?? '';
    _bioController.text = _customer?.bio ?? '';
    _nicknameController.text = _customer?.nickName ?? '';
    if (_customer?.dateOfBirth != null) {
      DateTime dob =
          DateFormat('yyyy-MM-dd').parse(_customer?.dateOfBirth ?? '');
      _dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(dob);
    } else {
      _dateOfBirthController.text = '';
    }

    _selectPhoneCountry = _customer?.phoneNumber?.countryCode != null
        ? _country?.firstWhere(
            (element) => element.code == _customer?.phoneNumber?.countryCode,
            orElse: () => Country())
        : null;

    _phoneNumberController.text = _customer?.phoneNumber?.number ?? '';
    _emailController.text = _customer?.email ?? '';
    _address1Controller.text = _customer?.address1 ?? '';
    _address2Controller.text = _customer?.address2 ?? '';
    _selectedCountry = _customer?.country != null
        ? _country?.firstWhere((element) => element.code == _customer?.country,
            orElse: () => Country())
        : null;

    _countryController.text = _selectedCountry?.name ?? '';

    //_cityController.text = _customer?.city ?? '';
    // _provinceController.text = _customer?.province ?? '';
    _occupationController.text = _customer?.occupation ?? '';
    _employmentController.text = _customer?.employment ?? '';
    _incomeSourceController.text = _customer?.incomeSource ?? '';

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      context.read<ProvinceProvider>().getProvinces(_selectedCountry?.code);
      context.read<CityProvider>().getCities(_customer?.province);
      // Provider.of<CountryProvider>(context, listen: false).getProvinces(_selectedCountry?.code);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(SizeConfig.resizeWidth(1.54));
    return Scaffold(
        appBar: buildAppBar(),
        body: Container(
          padding: EdgeInsets.only(
              left: SizeConfig.resizeWidth(10.26),
              right: SizeConfig.resizeWidth(10.26),
              top: SizeConfig.resizeWidth(4.11),
              bottom: 50),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Update your personal information",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.resizeFont(9.24),
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: SizeConfig.resizeHeight(4.11)),
                  Text(
                    "Customer Info",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.resizeFont(12.31),
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: SizeConfig.resizeHeight(4.11)),
                  Text(
                    "Profile Picture",
                    style: TextStyle(
                        color: Color(0xFF4F4F4F),
                        fontSize: SizeConfig.resizeFont(9.24),
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: SizeConfig.resizeHeight(4.11)),
                  Consumer<DocumentProvider>(
                      builder: (context, response, child) {
                    return InkWell(
                      onTap: () => _modalBottomSheetMenu(),
                      child: Stack(
                        children: [
                          Container(
                            width: SizeConfig.resizeWidth(18.21), //71,
                            height: SizeConfig.resizeHeight(18.21), //71
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.2),
                                    BlendMode.srcOver),
                                image: NetworkImage(
                                  '${_customer?.profilePhoto ?? ''}', //https://faith-bucket.s3.ap-south-1.amazonaws.com/fizzaselfie.jpeg
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: SizeConfig.resizeWidth(6.713),
                            left: SizeConfig.resizeWidth(6.713),
                            child: Icon(Icons.camera_alt_rounded,
                                color: Colors.white,
                                size: SizeConfig.resizeWidth(4.78)),
                          )
                        ],
                      ),
                    );
                  }),

                  SizedBox(height: SizeConfig.resizeHeight(4.11)),
                  Text(
                    "Allowed file types: png, jpg, jpeg.",
                    style: TextStyle(
                        color: Color(0xFF4F4F4F),
                        fontSize: SizeConfig.resizeFont(9.24),
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: SizeConfig.resizeWidth(8.21)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: FmDropdown(
                          title: 'Title*',
                          onValidation: (value) {
                            if (value.isEmpty) {
                              return 'Required field';
                            }
                          },
                          maxLines: 1,
                          textEditingController: _titleController,
                          onTap: () {
                            _showBottomSheet(
                                _titleList, 'Select Title', _titleController);
                          },
                        ),
                      ),
                      SizedBox(width: SizeConfig.resizeWidth(4.11)),
                      Expanded(
                        flex: 3,
                        child: FmInputFields(
                          title: 'First Name',
                          obscureText: false,
                          textEditingController: _firstNameController,
                          textInputType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          onValidation: (value) {
                            if (value.isEmpty) {
                              return 'Required field';
                            } else if (value.length < 2) {
                              return 'Minimum 2 characters required';
                            } else if (value.length > 50) {
                              return 'Maximum 50 characters allowed';
                            }
                          },
                          autoFocus: false,
                          maxLines: 1,
                          isMandatory: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.resizeHeight(6.16)),
                  FmInputFields(
                    title: 'Last Name',
                    obscureText: false,
                    textEditingController: _lastNameController,
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    onValidation: (value) {
                      if (value.isEmpty) {
                        return 'Required field';
                      } else if (value.length < 2) {
                        return 'Minimum 2 characters required';
                      } else if (value.length > 50) {
                        return 'Maximum 50 characters allowed';
                      }
                    },
                    autoFocus: false,
                    maxLines: 1,
                    isMandatory: true,
                  ),
                  SizedBox(height: SizeConfig.resizeHeight(6.16)),
                  FmInputFields(
                    title: 'Bio',
                    obscureText: false,
                    textEditingController: _bioController,
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    onValidation: (value) {
                      if (value.length > 300) {
                        return 'Maximum 300 characters allowed';
                      }
                    },
                    autoFocus: false,
                    maxLines: 5,
                  ),
                  SizedBox(height: SizeConfig.resizeHeight(6.16)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Stack(
                          children: [
                            FmInputFields(
                              title: 'Nickname*',
                              obscureText: false,
                              textEditingController: _nicknameController,
                              textInputType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              onValidation: (value) {
                                if (value.isEmpty) {
                                  return 'Required field';
                                } else if (value.length > 50) {
                                  return 'Maximum 20 characters allowed';
                                }
                              },
                              autoFocus: false,
                              maxLines: 1,
                            ),
                            Positioned(
                              right: SizeConfig.resizeWidth(1.54),
                              child: MyTooltip(
                                message: 'What should we call you?',
                                child: Icon(
                                  CupertinoIcons.question_circle,
                                  size: 15,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: SizeConfig.resizeWidth(4.11)),
                      Expanded(
                        flex: 1,
                        child: FmDropdown(
                          title: 'Date of Birth*',
                          textEditingController: _dateOfBirthController,
                          onValidation: (value) {
                            if (value.isEmpty) {
                              return 'Required field';
                            } else if (DateTime.parse(value)
                                    .compareTo(_todayDate) >
                                0) {
                              return 'Should not be greater than current date';
                            }
                          },
                          maxLines: 1,
                          trailingIcon: Icons.date_range,
                          trailingIconColor:
                              Theme.of(context).appBarTheme.foregroundColor!,
                          onTap: () {
                            _selectDate(context);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.resizeHeight(6.16)),
                  FmInputFields(
                    title: 'Address Line 1*',
                    obscureText: false,
                    textEditingController: _address1Controller,
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    onValidation: (value) {
                      if (value.isEmpty) {
                        return 'Required field';
                      } else if (value.length > 75) {
                        return 'Maximum 75 characters allowed';
                      }
                    },
                    autoFocus: false,
                    maxLines: 1,
                  ),
                  SizedBox(height: SizeConfig.resizeHeight(6.16)),
                  FmInputFields(
                    title: 'Address Line 2',
                    obscureText: false,
                    textEditingController: _address2Controller,
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    onValidation: (value) {
                      if (value.length > 75) {
                        return 'Maximum 75 characters allowed';
                      }
                    },
                    autoFocus: false,
                    maxLines: 1,
                  ),
                  SizedBox(height: SizeConfig.resizeHeight(6.16)),
                  FmCountryFields(
                    title: 'Country*',
                    textEditingController: _countryController,
                    textInputAction: TextInputAction.done,
                    autoFocus: false,
                    maxLines: 1,
                    country: _country!,
                    initialValue: _selectedCountry?.code != null
                        ? _selectedCountry!
                        : _country![0],
                    selectedCountry: (value) {
                      setState(() {
                        _selectedCountry = value;
                        _countryController.text = _selectedCountry?.name ?? '';
                        isCountryChange = true;
                        context
                            .read<ProvinceProvider>()
                            .getProvinces(value.code);
                      });
                    },
                  ),
                  SizedBox(height: SizeConfig.resizeHeight(6.16)),

                  //print('Province response--${response.province.data?.provinces?.single.name}');
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Consumer<ProvinceProvider>(
                          builder: (context, response, child) {
                        // if (response.province.status == Status.LOADING) {
                        //   return Align(
                        //       alignment: Alignment.center,
                        //       child: CircularProgressIndicator());
                        // }
                        if (response.province.status == Status.COMPLETED &&
                            _customer?.province != null) {
                          WidgetsBinding.instance!.addPostFrameCallback((_) {
                            Provinces? province =
                                response.province.data?.provinces?.firstWhere(
                                    (element) =>
                                        element.code == _customer?.province,
                                    orElse: () => Provinces());
                            if (isCountryChange) {
                              isCountryChange = false;
                              _provinceController.text = '';
                            } else {
                              _provinceController.text = province?.name ?? '';
                              response.setSelectProvince(province);
                            }
                          });
                        }
                        return Expanded(
                          flex: 1,
                          child: FmDropdown(
                            title: 'Province*',
                            onValidation: (value) {
                              if (value.isEmpty) {
                                return 'Required field';
                              }
                            },
                            maxLines: 1,
                            textEditingController: _provinceController,
                            //TextEditingController(text: response.selectedProvince?.name ?? '' ),
                            onTap: () {
                              if (response.province.data != null) {
                                WidgetsBinding.instance!
                                    .addPostFrameCallback((_) {
                                  _showProvinceBottomSheet(
                                      response.province.data?.provinces,
                                      'Select Province');
                                });
                              }
                            },
                          ),
                        );
                      }),
                      SizedBox(width: SizeConfig.resizeWidth(4.11)),
                      Consumer<CityProvider>(
                          builder: (context, response, child) {
                        // if (response.city.status == Status.LOADING) {
                        //   return Align(
                        //       alignment: Alignment.center,
                        //       child: CircularProgressIndicator());
                        // }
                        if (response.city.status == Status.COMPLETED &&
                            _customer?.city != null) {
                          WidgetsBinding.instance!.addPostFrameCallback((_) {
                            Cities? city = response.city.data?.cities
                                ?.firstWhere(
                                    (element) =>
                                        element.code == _customer?.city,
                                    orElse: () => Cities());
                            if (isCountryChange) {
                              _cityController.text = '';
                              _provinceController.text = '';
                            } else {
                              response.setSelectedCity(city);
                              _cityController.text = city?.name ?? '';
                            }
                          });
                        }
                        return Expanded(
                          flex: 1,
                          child: FmDropdown(
                            title: 'City*',
                            onValidation: (value) {
                              if (value.isEmpty) {
                                return 'Required field';
                              }
                            },
                            maxLines: 1,
                            textEditingController: _cityController,
                            //TextEditingController(text: response.selectCity?.name ?? '' ),
                            onTap: () {
                              if (response.city.data != null) {
                                WidgetsBinding.instance!
                                    .addPostFrameCallback((_) {
                                  _showCityBottomSheet(
                                      response.city.data?.cities,
                                      'Select City');
                                });
                              }
                            },
                          ),
                        );
                      }),
                    ],
                  ),

                  SizedBox(height: SizeConfig.resizeHeight(6.16)),
                  FmInputFields(
                    title: 'Occupation',
                    obscureText: false,
                    textEditingController: _occupationController,
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    onValidation: (value) {
                      if (value.isEmpty) {
                        return 'Required field';
                      } else if (value.length > 50) {
                        return 'Maximum 50 characters allowed';
                      }
                    },
                    autoFocus: false,
                    maxLines: 1,
                    isMandatory: true,
                  ),
                  SizedBox(height: SizeConfig.resizeHeight(6.16)),
                  FmInputFields(
                    title: 'Employment',
                    obscureText: false,
                    textEditingController: _employmentController,
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    onValidation: (value) {
                      if (value.isEmpty) {
                        return 'Required field';
                      } else if (value.length > 50) {
                        return 'Maximum 50 characters allowed';
                      }
                    },
                    autoFocus: false,
                    maxLines: 1,
                    isMandatory: true,
                  ),
                  SizedBox(height: SizeConfig.resizeHeight(6.16)),
                  FmInputFields(
                    title: 'Income Source',
                    obscureText: false,
                    textEditingController: _incomeSourceController,
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    onValidation: (value) {
                      if (value.isEmpty) {
                        return 'Required field';
                      } else if (value.length > 50) {
                        return 'Maximum 50 characters allowed';
                      }
                    },
                    autoFocus: false,
                    maxLines: 1,
                    isMandatory: true,
                  ),
                  SizedBox(height: SizeConfig.resizeHeight(6.16)),
                  Text(
                    "Contact Info",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.resizeFont(12.31),
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: SizeConfig.resizeHeight(6.16)),

                  FmPhoneFields(
                      title: 'Phone Number*',
                      textEditingController: _phoneNumberController,
                      textInputAction: TextInputAction.done,
                      autoFocus: false,
                      maxLines: 1,
                      country: _country!,
                      initialValue: _selectPhoneCountry!.code != null
                          ? _selectPhoneCountry!
                          : _country![0],
                      selectedCountry: (value) {
                        setState(() {
                          _selectPhoneCountry = value;
                        });
                      }),
                  SizedBox(height: SizeConfig.resizeHeight(6.16)),
                  FmInputFields(
                    title: 'Email Address',
                    obscureText: false,
                    textEditingController: _emailController,
                    textInputType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    onValidation: (value) {
                      if (value.isEmpty) {
                        return 'Required';
                      } else if (!Helper.isValidEmail(value)) {
                        return 'Invalid email address';
                      }
                    },
                    autoFocus: false,
                    maxLines: 1,
                    isMandatory: true,
                  ),
                  SizedBox(height: SizeConfig.resizeHeight(2.06)),
                  Text(
                    "We will never share your information with anybody.",
                    style: TextStyle(
                        color: Color(0xFF4F4F4F),
                        fontSize: SizeConfig.resizeFont(9.24),
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: SizeConfig.resizeHeight(10.26)),
                  Consumer<CustomerProvider>(
                      builder: (context, response, child) {
                    if (response.customer.status == Status.LOADING) {
                      return Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator());
                    } else if (response.customer.status == Status.ERROR) {
                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                        _showDialog(response.customer.message.toString(),
                            'Close', Icons.error);
                      });
                    } else if (response.customer.status == Status.COMPLETED) {
                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                        _showDialog('Profile update successfully', 'Close',
                            Icons.check_circle);
                        context.read<LoginProvider>().checkStatus();
                        if (todoLogOut) {
                          todoLogOut = false;
                          context.read<LoginProvider>().reset();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                              (Route<dynamic> route) => false);
                        }
                      });
                    }
                    return FmSubmitButton(
                        text: "Submit",
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _showConfirmDialog(
                                'To complete the verification process, please confirm that the information you have provided is correct.',
                                'Yes, I am Sure',
                                'No, I want to make sure');
                          }
                        },
                        showOutlinedButton: false);
                  }),
                ],
              ),
            ),
          ),
        ));
  }

  void _modalBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            color: Color(0xFF737373),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    onTap: () {
                      browseImage(ImageSource.camera);
                      Navigator.pop(context);
                    },
                    leading: Icon(Icons.camera),
                    title: Text(
                      'Take Photo',
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      browseImage(ImageSource.gallery);
                      Navigator.pop(context);
                    },
                    leading: Icon(Icons.upload),
                    title: Text(
                      'Upload Photo',
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future browseImage(ImageSource src) async {
    final pickedFile =
        await picker.pickImage(source: src, maxWidth: 800, maxHeight: 600);
    if (pickedFile != null) {
      print('Name of the file: ${pickedFile.path}');
      _profileImageFile = pickedFile;
      final profileImageFile =
          await _profileImageFile?.readAsBytes() as List<int>;
      final documentName = '${_customer?.id}-Selfie';
      _documentProvider.upLoadDocument(
          document: base64.encode(profileImageFile),
          documentType: 2,
          documentName: documentName,
          customerId: _customer?.id);
    }
  }

  _showConfirmDialog(String title, String buttonText, String secondButtonText) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return FmDialogWidget(
              iconData: Icons.error_outline,
              title: title,
              message: '',
              buttonText: buttonText,
              secondButtonText: secondButtonText,
              secondButtonCallback: () async {
                Navigator.pop(dialogContext);
              },
              voidCallback: () async {
                updateCustomerProfile();
                Navigator.pop(dialogContext);
              });
        });
  }

  _showDialog(String title, String buttonText, IconData icon) {
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
                context.read<CustomerProvider>().reset();
                Navigator.pop(dialogContext);
              });
        });
  }

  void updateCustomerProfile() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = _titleController.text;
    data['firstName'] = _firstNameController.text;
    data['lastName'] = _lastNameController.text;
    data['bio'] = _bioController.text;
    data['nickName'] = _nicknameController.text;
    data['dateOfBirth'] = _dateOfBirthController.text;
    if (_phoneNumberController.text != '') {
      PhoneNumber phone = new PhoneNumber(
          countryCode: _selectPhoneCountry?.code,
          dialCode: _selectPhoneCountry?.dialCode,
          number: _phoneNumberController.text);
      data['phoneNumber'] = phone.toJson();
    }
    data['email'] = _emailController.text.toLowerCase().trim();
    data['address1'] = _address1Controller.text;
    data['address2'] = _address2Controller.text;
    data['city'] = context.read<CityProvider>().selectCity?.code;
    data['province'] = context.read<ProvinceProvider>().selectedProvince?.code;
    data['country'] = _selectedCountry?.code;
    data['occupation'] = _occupationController.text;
    data['employment'] = _employmentController.text;
    data['incomeSource'] = _incomeSourceController.text;

    if (_emailController.text != _customer?.email ||
        _phoneNumberController.text !=
            _customer?.phoneNumber?.number.toString()) {
      print('In todo Logout');
      todoLogOut = true;
    }

    context.read<CustomerProvider>().updateCustomer(_customer!.id, data);
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        'Personal Information',
        style: TextStyle(
            fontSize: SizeConfig.resizeFont(12.31),
            fontWeight: FontWeight.w500),
      ),
      centerTitle: true,
      elevation: 1,
      leadingWidth: 105,
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _todayDate,
        // Refer step 1
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light().copyWith(
                primary: Theme.of(context).appBarTheme.foregroundColor,
              ),
            ),
            child: child!,
          );
        });
    if (picked != null && picked != _todayDate)
      setState(() {
        _dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
  }

  void _showBottomSheet(
      List<dynamic>? dataList, String title, TextEditingController controller) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (builder) {
          return Container(
            color: Color(0xFF737373),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
              ),
              child: Material(
                color: Colors.grey.shade200,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: dataList?.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            onTap: () {
                              // widget.selectedCountry(dataList[index]);
                              controller.text = dataList?[index];
                              Navigator.of(context).pop();
                            },
                            title: Text(dataList?[index].toString() ?? ''),
                          );
                        }),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _showProvinceBottomSheet(List<Provinces>? dataList, String title) {
    showModalBottomSheet(
        isScrollControlled: false,
        context: context,
        builder: (builder) {
          return Container(
            color: Color(0xFF737373),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
              ),
              child: Material(
                color: Colors.grey.shade200,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: dataList?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              onTap: () {
                                // widget.selectedCountry(dataList[index]);
                                context
                                    .read<ProvinceProvider>()
                                    .setSelectProvince(dataList![index]);
                                _provinceController.text =
                                    dataList[index].name.toString();
                                Navigator.of(context).pop();
                                context
                                    .read<CityProvider>()
                                    .getCities(dataList[index].code);
                                // WidgetsBinding.instance!
                                //     .addPostFrameCallback((_) {
                                //   context
                                //       .read<CountryProvider>()
                                //       .getCities(dataList[index].code);
                                //
                                // });
                              },
                              title:
                                  Text(dataList?[index].name.toString() ?? ''),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _showCityBottomSheet(List<Cities>? dataList, String title) {
    showModalBottomSheet(
        isScrollControlled: false,
        context: context,
        builder: (builder) {
          return Container(
            color: Color(0xFF737373),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
              ),
              child: Material(
                color: Colors.grey.shade200,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: dataList?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              onTap: () {
                                // widget.selectedCountry(dataList[index]);
                                context
                                    .read<CityProvider>()
                                    .setSelectedCity(dataList![index]);
                                Navigator.of(context).pop();
                                _cityController.text =
                                    dataList[index].name.toString();
                              },
                              title:
                                  Text(dataList?[index].name.toString() ?? ''),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class MyTooltip extends StatelessWidget {
  final Widget child;
  final String message;

  MyTooltip({required this.message, required this.child});

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<State<Tooltip>>();
    return Tooltip(
      verticalOffset: 14,
      // margin: EdgeInsets.only(left: 150),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 10.0,
              offset: new Offset(3.0, 3.0),
            ), //BoxShadow
          ],
          color: Colors.white,
          border: Border.all(
              color: Theme.of(context).appBarTheme.foregroundColor!)),
      textStyle: TextStyle(
        color: Colors.black,
        fontSize: 12,
      ),
      key: key,
      message: message,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onTap(key),
        child: child,
      ),
    );
  }

  void _onTap(GlobalKey key) {
    final dynamic tooltip = key.currentState;
    tooltip?.ensureTooltipVisible();
  }
}
