import 'package:fiat_match/models/city.dart';
import 'package:fiat_match/models/country.dart';
import 'package:fiat_match/models/province.dart';
import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/repositories/country_repository.dart';
import 'package:flutter/cupertino.dart';

class CountryProvider extends ChangeNotifier {
  late CountryRepository _countryRepository;
  late ApiResponse<List<Country>> _country;
  late ApiResponse<Province> _province;
  late ApiResponse<City> _city;

  Provinces? _selectedProvince;
  Cities? _selectedCity;


  ApiResponse<List<Country>> get country => _country;
  ApiResponse<Province> get province => _province;
  ApiResponse<City> get city => _city;
  Provinces? get selectedProvince => _selectedProvince;
  Cities? get selectCity => _selectedCity;

  CountryProvider(BuildContext context) {
    _countryRepository = CountryRepository(context);
    _country = ApiResponse.initial('Not Initialized');
    _province = ApiResponse.initial('Not Initialized');
    _city =  ApiResponse.initial('Not Initialized');
  }



  getCountry() async {
    _country = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      List<Country> response = await _countryRepository.getCountries();
      _country = ApiResponse.completed(response);
      notifyListeners();
    } catch (e) {
      _country = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }

  String getCountryNameByCode(String? code) {
    return _country.data!
        .firstWhere((element) => element.code.toString() == code)
        .name
        .toString();
  }

}
