import 'package:fiat_match/models/province.dart';
import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/repositories/country_repository.dart';
import 'package:flutter/material.dart';

class ProvinceProvider extends ChangeNotifier{
  late CountryRepository _countryRepository;
  late ApiResponse<Province> _province;
  Provinces? _selectedProvince;
  ApiResponse<Province> get province => _province;
  Provinces? get selectedProvince => _selectedProvince;
  ProvinceProvider(BuildContext context){
    _countryRepository = CountryRepository(context);
    _province = ApiResponse.initial('Not Initialized');
  }

  getProvinces(String? countryCode) async{
    _province =  ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      Province response = await _countryRepository.getProvinces(countryCode!);
      _province = ApiResponse.completed(response);

      notifyListeners();
    } catch (e) {
      _province = ApiResponse.error(e.toString());

      notifyListeners();
    }
  }

  setSelectProvince(Provinces? province){
    _selectedProvince = province;

  }

}