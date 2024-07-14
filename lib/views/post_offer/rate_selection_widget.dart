import 'package:fiat_match/provider/new/mid_market_rate_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:provider/provider.dart';

class RateSelectionWidget extends StatefulWidget {
  final String currency;
  final Function(double, String) onRateUpdated;

  const RateSelectionWidget(
      {Key? key, required this.currency, required this.onRateUpdated})
      : super(key: key);

  @override
  _RateSelectionWidgetState createState() => _RateSelectionWidgetState();
}

class _RateSelectionWidgetState extends State<RateSelectionWidget> {
  int _selectedIndex = 0;
  double total = 0.0;
  var currentFocus;
  late TextEditingController _valueController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      context.read<MidMarketRateProvider>().setCustomRate(0);
      context.read<MidMarketRateProvider>().setRateType(true);
    });
    _valueController = TextEditingController();
     _valueController.text = '0';
  }

  @override
  Widget build(BuildContext context) {
    final rate =
        Provider.of<MidMarketRateProvider>(context).rate;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Rate'),
        Transform.translate(
          offset: Offset(-16, 0),
          child: MaterialSegmentedControl(
            children: {
              0: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('Absolute'),
              ),
              1: Text('Relative'),
            },
            selectionIndex: _selectedIndex,
            borderColor: Colors.grey,
            selectedColor: Theme.of(context).accentColor,
            unselectedColor: Colors.white,
            verticalOffset: 0,
            borderRadius: 5.0,
            onSegmentChosen: (int index) {
              setState(() {
                _selectedIndex = index;
                index == 0 ? context.read<MidMarketRateProvider>().setRateType(true) : context.read<MidMarketRateProvider>().setRateType(false);
                widget.onRateUpdated(context.read<MidMarketRateProvider>().customRate, context.read<MidMarketRateProvider>().isAbsolute ? "Absolute" : "Relative");
              });
            },
          ),
        ),
        if (_selectedIndex == 1)
          Row(
            children: [
              Text('MKT Rate + '),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: SizedBox(
                    height: 35,
                    child: TextFormField(
                      controller: _valueController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      cursorHeight: 18,
                      decoration: InputDecoration(
                        border: UnderlineInputBorder(borderSide: BorderSide()),
                        enabledBorder:
                            UnderlineInputBorder(borderSide: BorderSide()),
                        focusedBorder:
                            UnderlineInputBorder(borderSide: BorderSide()),
                        errorBorder:
                            UnderlineInputBorder(borderSide: BorderSide()),
                      ),
                      onChanged: (value) =>
                          _validateUserInput(value, rate, isAbsolute: false),
                    ),
                  ),
                ),
              ),
              Consumer<MidMarketRateProvider>(builder: (context,response,child){
                return Text(' ${widget.currency} = ${response.rate.toStringAsFixed(5)} ${widget.currency}');
              })

            ],
          )
        else
          Row(
            children: [
              SizedBox(
                width: 100,
                height: 35,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 4.0),
                  child: TextFormField(
                    cursorHeight: 18,
                    controller: _valueController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(borderSide: BorderSide()),
                      enabledBorder:
                          UnderlineInputBorder(borderSide: BorderSide()),
                      focusedBorder:
                          UnderlineInputBorder(borderSide: BorderSide()),
                      errorBorder:
                          UnderlineInputBorder(borderSide: BorderSide()),
                    ),
                    onChanged: (value) => _validateUserInput(value, rate),
                  ),
                ),
              ),
              Text('${widget.currency}')
            ],
          ),
      ],
    );
  }

  void _validateUserInput(String value, double rate, {bool isAbsolute = true}) {
    var input = double.tryParse(value);
    // if (input != null) {
    //   if (isAbsolute) {
    //     total = input;
    //   } else {
    //     total = rate + input;
    //   }
    // } else {
    //   total = isAbsolute? 0.0 : rate;
    // }
    if (input != null) {
      context.read<MidMarketRateProvider>().setCustomRate(input);
      total = context.read<MidMarketRateProvider>().rate;
    }else{
      context.read<MidMarketRateProvider>().setCustomRate(0);
      total = isAbsolute? 0.0 : rate;
    }
    widget.onRateUpdated(context.read<MidMarketRateProvider>().customRate, isAbsolute ? "Absolute" : "Relative");
    setState(() {});
  }
}
