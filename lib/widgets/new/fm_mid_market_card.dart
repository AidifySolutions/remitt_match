import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/provider/new/mid_market_rate_provider.dart';
import 'package:fiat_match/provider/new/user_offers_provider.dart';
import 'package:fiat_match/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MidMarketRateCard extends StatefulWidget {
  final bool showButton;
  final Function()? onTapUseOffer;

  const MidMarketRateCard({Key? key, this.showButton = true, this.onTapUseOffer}) : super(key: key);

  @override
  _MidMarketRateCardState createState() => _MidMarketRateCardState();
}

class _MidMarketRateCardState extends State<MidMarketRateCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: EdgeInsets.all(
          SizeConfig.resizeWidth(4),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.showButton ?'Preferred Partner Offer':'Mid-Market Rate',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).appBarTheme.foregroundColor,
                      fontSize: SizeConfig.resizeFont(11.22),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.resizeHeight(0.5),
                  ),
                  widget.showButton ?
                  Consumer<MidMarketRateProvider>(builder: (context, response, child) {
                    if (response.parallelRateResponse.status == Status.LOADING) return Text('...');
                    if (response.parallelRateResponse.status == Status.ERROR) return Text(response.parallelRateResponse.data?.message ?? '');
                    return Text(
                      '1 ${response.sellingCurrency} = ${response.parallelRateResponse.data?.rate!.toStringAsFixed(5)} ${response.buyingCurrency}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).appBarTheme.foregroundColor,
                        fontSize: SizeConfig.resizeFont(8.42),
                      ),
                    );
                  })
                  :
                  Consumer<MidMarketRateProvider>(builder: (context, response, child) {
                    if (response.rateResponse.status == Status.LOADING) return Text('...');
                    if (response.rateResponse.status == Status.ERROR) return Text(response.rateResponse.data?.message ?? '');
                    return Text(
                      '1 ${response.sellingCurrency} = ${response.rateResponse.data?.rate!.toStringAsFixed(5)} ${response.buyingCurrency}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).appBarTheme.foregroundColor,
                        fontSize: SizeConfig.resizeFont(8.42),
                      ),
                    );
                  }),
                ],
              ),
            ),
            if (widget.showButton)
              TextButton(
                onPressed: () {
                  if (widget.onTapUseOffer != null)
                    widget.onTapUseOffer!();
                },
                child: Text(context.read<UserOffersProvider>().selectedFiatOffer != null ? 'Selected offer':'Use offer'),
                style: TextButton.styleFrom(
                    side: BorderSide(color: Theme.of(context).accentColor),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200)),
                    textStyle: TextStyle(fontSize: SizeConfig.resizeFont(9), fontWeight: FontWeight.w500),
                    primary: context.read<UserOffersProvider>().selectedFiatOffer != null ? Colors.white :Theme.of(context).accentColor,
                    backgroundColor: context.read<UserOffersProvider>().selectedFiatOffer != null ?  Color(0xff1B6F41) : Theme.of(context).primaryColor,
                    minimumSize: Size(
                      SizeConfig.resizeWidth(24.52),
                      SizeConfig.resizeHeight(8),
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.zero),
              ),
          ],
        ),
      ),
    );
  }
}
