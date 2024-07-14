import 'package:fiat_match/models/city.dart';
import 'package:fiat_match/models/country.dart';
import 'package:fiat_match/models/province.dart';
import 'package:fiat_match/network_module/api_path.dart';
import 'package:fiat_match/network_module/http_client.dart';
import 'package:flutter/material.dart';

class CountryRepository {
  late final BuildContext _context;

  CountryRepository(BuildContext context) {
    _context = context;
  }

  Future<List<Country>> getCountries() async {
    final response = await HttpClient.instance.fetchData(
        ApiPathHelper.getValue(APIPath.GetCountries), _context);

    final parsed = response.cast<Map<String, dynamic>>();
    List<Country> country =
        parsed.map<Country>((json) => Country.fromJson(json)).toList();

    return country;
  }

  Future<Province> getProvinces(String countryCode) async{
    var queryParam = {"country": countryCode};
    final response = await HttpClient.instance.fetchData(
        ApiPathHelper.getValue(APIPath.GetProvinces), _context, params: queryParam);

    return Province.fromJson(response);
  }

  Future<City> getCites(String provinceCode) async{
    var queryParam = {"province": provinceCode};
    final response = await HttpClient.instance.fetchData(
        ApiPathHelper.getValue(APIPath.GetCities), _context, params: queryParam);

    return City.fromJson(response);
  }



}
