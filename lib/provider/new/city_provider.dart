import 'package:fiat_match/models/city.dart';
import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/repositories/country_repository.dart';
import 'package:flutter/cupertino.dart';

class CityProvider extends ChangeNotifier{
  late CountryRepository _countryRepository;
  late ApiResponse<City> _city;
  Cities? _selectedCity;

  ApiResponse<City> get city => _city;
  Cities? get selectCity => _selectedCity;

  CityProvider(BuildContext context){
    _countryRepository = CountryRepository(context);
    _city =  ApiResponse.initial('Not Initialized');
  }

  getCities(String? provinceCode) async{
    _city =  ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      City response = await _countryRepository.getCites(provinceCode!);
      _city = ApiResponse.completed(response);

      notifyListeners();
    } catch (e) {
      _city = ApiResponse.error(e.toString());

      notifyListeners();
    }
  }
  setSelectedCity(Cities? city){
    _selectedCity = city;
  }
}