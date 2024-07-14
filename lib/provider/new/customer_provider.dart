import 'package:fiat_match/models/customer.dart';
import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/repositories/customer_repo.dart';
import 'package:flutter/material.dart';

class CustomerProvider extends ChangeNotifier {
  late CustomerRepository _customerRepository;
  late ApiResponse<Customer> _customer;
  late ApiResponse<List<Customer>> _allCustomer;
  late List<String> _customerIds;

  ApiResponse<Customer> get customer => _customer;

  ApiResponse<List<Customer>> get allCustomer => _allCustomer;

  CustomerProvider(BuildContext context) {
    _customerRepository = CustomerRepository(context);
    _customer = ApiResponse.initial('Not Initialized');
    _allCustomer = ApiResponse.initial('Not Initialized');
    _customerIds = [];
  }

  createNewCustomer(String firstName, String phoneNumber, String dialCode,
      String isoCountryCode, String email, String password) async {
    _customer = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      Customer response = await _customerRepository.createNewCustomer(
          firstName, phoneNumber, dialCode, isoCountryCode, email, password);
      _customer = ApiResponse.completed(response);
      notifyListeners();
    } catch (e) {
      _customer = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }

  getCustomer(String customerId) async {
    _customer = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      Customer response = await _customerRepository.getCustomer(customerId);
      _customer = ApiResponse.completed(response);
      notifyListeners();
    } catch (e) {
      _customer = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }

  getAllCustomersByIds() async {
    _allCustomer = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      _customerIds.forEach((element) async {
        Customer response = await _customerRepository.getCustomer(element);
        _allCustomer.data?.add(response);
      });
      _allCustomer = ApiResponse.completed(_allCustomer.data);
      notifyListeners();
    } catch (e) {
      _allCustomer = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }

  updateCustomer(String? customerId, Map<String, dynamic> body) async {
    _customer = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      Customer response =
          await _customerRepository.updateCustomer(customerId, body);
      _customer = ApiResponse.completed(response);
      notifyListeners();
    } catch (e) {
      _customer = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }

  Future<Customer> getChatCustomer(String customerId) async {
    _customer = ApiResponse.loading('Fetching Data');

    try {
      return await _customerRepository.getAnyCustomerById(customerId);
    } catch (e) {
      return Customer();
    } finally {
      notifyListeners();
    }
  }

  getAnyCustomerByID(String customerId) async {
    _customer = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      Customer response =
          await _customerRepository.getAnyCustomerById(customerId);
      return response;
    } catch (e) {
      _customer = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }

  addId(String customerId) {
    _customerIds.add(customerId);
  }

  reset() {
    _customer = ApiResponse.initial('Not Initialized');
    _allCustomer = ApiResponse.initial('Not Initialized');
  }
}
