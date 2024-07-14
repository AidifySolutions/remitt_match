import 'package:fiat_match/provider/new/user_offers_provider.dart';
import 'package:fiat_match/utils/size_config.dart';
import 'package:fiat_match/widgets/new/fm_input_fields.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterDialog extends StatefulWidget {
  final Function(String, String, String, String) onUpdateCallback;
  const FilterDialog({Key? key, required this.onUpdateCallback})
      : super(key: key);

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

List<String> _list = [
  '1. Rate: Low to High',
  '2. Rate: High to Low',
  '3. Expiry: Today to later',
  '4. Expiry: Later to Today',
  '5. Top Sellers'
];

Map<String, String> details = {
  'Today': '1',
  'This week': '7',
  'This month': '30',
  'This year': '365'
};
Map<String, String> sortByDetails = {
  '1. Rate: Low to High': 'RateAsc',
  '2. Rate: High to Low': 'RateDsc',
  '3. Expiry: Today to later': 'ExpiryDsc',
  '4. Expiry: Later to Today': 'ExpiryAsc',
  '5. Top Sellers': 'TopSeller'
};

class _FilterDialogState extends State<FilterDialog> {
  bool isStretchedDropDown = false;
  String _noOfUserTransactionFilter = '';
  String _offerExpireFilter = '';
  String _sortByType = 'Sort By';
  String _sortBy = 'Sort By';
  late TextEditingController _maxLimitController;
  late UserOffersProvider _userOffersProvider;
  Map<String, String> _userTransaction = {
    '200+': "200",
    "100+": "100",
    "50+": "5",
    "10+": "10",
    "1+": "1"
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _noOfUserTransactionFilter = _userTransaction.entries.first.value;
    //_offerExpireFilter = details.entries.first.value;
    _userOffersProvider =
        Provider.of<UserOffersProvider>(context, listen: false);
    _maxLimitController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
            side: BorderSide(
                color: Theme.of(context).appBarTheme.foregroundColor!,
                width: 0.5)),
        elevation: 40,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            dialogHeader(),
            Container(
              height: SizeConfig.resizeWidth(0.1),
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.resizeHeight(3.74),
                horizontal: SizeConfig.resizeWidth(5.61),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 3, child: offerThatExpiresFilter()),
                  SizedBox(
                    width: SizeConfig.resizeWidth(16),
                  ),
                  Expanded(
                    flex: 2,
                    child: numberOfUserTransactionsFilter(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: SizeConfig.resizeWidth(5.61),
                right: SizeConfig.resizeWidth(5.61),
              ),
              child: FmInputFields(
                  title: 'Min Limit',
                  obscureText: false,
                  textEditingController: _maxLimitController,
                  textInputType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  onValidation: (value) {},
                  autoFocus: false,
                  maxLines: 1),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.resizeHeight(5.61),
                horizontal: SizeConfig.resizeWidth(20.33),
              ),
              child: TextButton(
                onPressed: () {
                  widget.onUpdateCallback(
                      _offerExpireFilter,
                      _noOfUserTransactionFilter,
                      _sortByType == 'Sort By' ? '' : _sortByType,
                      _maxLimitController.text);
                },
                child: Text('Update Offers'),
                style: TextButton.styleFrom(
                    side: BorderSide(color: Theme.of(context).accentColor),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(200)),
                    textStyle: TextStyle(
                        fontSize: SizeConfig.resizeFont(9),
                        fontWeight: FontWeight.w600),
                    primary: Theme.of(context).primaryColor,
                    backgroundColor: Theme.of(context).accentColor,
                    minimumSize: Size(
                      double.infinity,
                      SizeConfig.resizeHeight(10),
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.zero),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget offerThatExpiresFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Offer that expires:',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: SizeConfig.resizeFont(8.42),
              color: Colors.black),
        ),
        SizedBox(
          height: SizeConfig.resizeHeight(1.5),
        ),
        Column(
            children: details.entries
                .map((e) => buildCheckBox(e.key, e.value, (value) {
                      _offerExpireFilter = value;
                      setState(() {});
                    }, isSelected: e.value == _offerExpireFilter))
                .toList()),
        SizedBox(
          height: SizeConfig.resizeHeight(0.5),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.resizeWidth(2.35),
            vertical: SizeConfig.resizeWidth(1.5),
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey)),
          child: DropdownButton<String>(
            hint: Text(
              _sortBy,
              style: TextStyle(
                  fontSize: SizeConfig.resizeFont(8.42),
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            items: sortByDetails.entries.map((e) {
              return DropdownMenuItem<String>(
                value: e.value,
                child: Text(
                  e.key,
                  style: TextStyle(
                      fontSize: SizeConfig.resizeFont(7.01),
                      fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  setState(() {
                    _sortByType = e.value;
                    _sortBy = e.key;
                  });
                },
              );
            }).toList(),
            icon: Icon(Icons.keyboard_arrow_down),
            underline: Container(),
            isDense: true,
            isExpanded: true,
            onChanged: (_) {},
          ),
        ),
      ],
    );
  }

  Widget numberOfUserTransactionsFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Number of user\'s transactions:',
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: SizeConfig.resizeFont(8.42),
              color: Colors.black),
        ),
        SizedBox(
          height: SizeConfig.resizeHeight(1.5),
        ),
        Column(
            children: _userTransaction.entries
                .map((e) => buildCheckBox(e.key, e.value, (value) {
                      _noOfUserTransactionFilter = value;
                      setState(() {});
                    }, isSelected: e.value == _noOfUserTransactionFilter))
                .toList()),
      ],
    );
  }

  Widget buildCheckBox(String title, String value, Function(String) onchange,
      {bool isSelected = false}) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: SizeConfig.resizeHeight(2.34),
      ),
      child: Row(
        children: [
          SizedBox(
            width: SizeConfig.resizeWidth(5.61),
            height: SizeConfig.resizeWidth(5.61),
            child: Checkbox(
                value: isSelected,
                onChanged: (selected) {
                  onchange(value);
                }),
          ),
          SizedBox(
            width: SizeConfig.resizeHeight(3),
          ),
          Text(
            title,
            style: TextStyle(
                fontSize: SizeConfig.resizeFont(9.82),
                fontWeight: FontWeight.w400,
                color: Colors.black),
          ),
        ],
      ),
    );
  }

  Padding dialogHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: SizeConfig.resizeHeight(3.74),
        horizontal: SizeConfig.resizeWidth(5.61),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Filter Offers',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: SizeConfig.resizeFont(11.22),
                  color: Colors.black),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              'assets/drawer_cross.png',
              color: Colors.black,
              width: SizeConfig.resizeWidth(5.61),
            ),
          ),
        ],
      ),
    );
  }
}
