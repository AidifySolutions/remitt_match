import 'package:fiat_match/models/country.dart';
import 'package:flutter/material.dart';

class FmCountryBottomSheet extends StatefulWidget {
  final List<Country> country;
  final Country initialValue;
  final Function(Country) selectedCountry;

  FmCountryBottomSheet(
      {required this.country,
        required this.initialValue,
        required this.selectedCountry});

  @override
  _FmCountryBottomSheetState createState() => _FmCountryBottomSheetState();
}

class _FmCountryBottomSheetState extends State<FmCountryBottomSheet> {
  @override
  Widget build(BuildContext context) {
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
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.country.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: () {
                    widget.selectedCountry(widget.country[index]);
                    Navigator.of(context).pop();
                  },
                  leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Image.asset(
                      'flags/' +
                          widget.country[index].code!.toLowerCase() +
                          '.png',
                      width: 36,
                    ),
                  ),
                  title: Text(widget.country[index].name.toString()),
                );
              }),
        ),
      ),
    );
  }
}
