import 'package:fiat_match/models/document.dart';
import 'package:fiat_match/provider/new/login_provider.dart';
import 'package:flutter/material.dart';

import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/repositories/customer_repo.dart';
import 'package:provider/provider.dart';

class DocumentProvider extends ChangeNotifier {
  late CustomerRepository _customerRepository;
  late ApiResponse<List<Document>> _documents;
  late ApiResponse<String> _uploadedDoc;
  late LoginProvider _loginProvider;
  ApiResponse<List<Document>> get document => _documents;
  ApiResponse<String> get uploadedDoc => _uploadedDoc;
  DocumentProvider(BuildContext context) {
    _customerRepository = CustomerRepository(context);
    _documents = ApiResponse.initial('Not Initialized');
    _loginProvider = Provider.of<LoginProvider>(context, listen: false);


  }

  getDocuments(String? customerId) async {
    _documents = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      List<Document> response = await _customerRepository.getDocuments(customerId);
      _documents = ApiResponse.completed(response);
      notifyListeners();
    } catch (e) {
      _documents = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }
  upLoadDocument({required String document,required int documentType,required String documentName,required customerId}) async {
    _uploadedDoc = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try{
     var response = await _customerRepository.uploadDocument(
          document,
          documentType,
          documentName,
          customerId);
     _uploadedDoc = ApiResponse.completed(response);
     _loginProvider.authentication.data?.customerData?.profilePhoto = _uploadedDoc.data;
     notifyListeners();
    }catch(e){
      _uploadedDoc = ApiResponse.error(e.toString());
      notifyListeners();
    }

  }

  reset() {
    _documents = ApiResponse.initial('Not Initialized');
  }
}
