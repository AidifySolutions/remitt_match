import 'package:fiat_match/models/advertisement.dart';
import 'package:fiat_match/models/customer.dart';
import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/provider/new/user_offers_provider.dart';
import 'package:fiat_match/utils/helper.dart';
import 'package:fiat_match/utils/size_config.dart';
import 'package:fiat_match/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import 'filter_dialog.dart';

//import 'package:fiat_match/utils/styles.dart';
class UserOffers extends StatefulWidget {
  final List<Ads> offers;
  final UserOffersProvider userOffersProvider;
  final Function(Ads, CustomerData) onTapCallback;
  final Function(String, String, String, String) onUpdateCallback;
  final Function() clearFillterCallback;
  final bool showButtons;

  UserOffers({
    required this.offers,
    required this.userOffersProvider,
    required this.onTapCallback,
    required this.onUpdateCallback,
    required this.clearFillterCallback,
    this.showButtons = true,
  });

  @override
  _UserOffersState createState() => _UserOffersState();
}

class _UserOffersState extends State<UserOffers> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        buildHeading(),
        SizedBox(
          height: SizeConfig.resizeHeight(1),
        ),
        buildSubHeading(context),
        if (widget.offers.length > 0) ...[
          Container(
            height: SizeConfig.resizeHeight(widget.showButtons ? 47 : 38),
            padding: EdgeInsets.only(
              left: SizeConfig.resizeWidth(9.35),
            ),
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.offers.length,
                itemExtent: 290,
                itemBuilder: (BuildContext context, int index) {
                  if (widget.userOffersProvider.loadOffers &&
                      index == widget.offers.length) {
                    return Container(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return InkWell(
                    // onTap: () {
                    //   widget.onTapCallback(
                    //       widget.userOffersProvider.fetchOffers[index],
                    //       widget.userOffersProvider.fetchOffersSellers[index]);
                    // },
                    child: offerCard(
                        widget.userOffersProvider.fetchOffers[index], index),
                  );
                }),
          ),
        ] else ...[
          Container(
              padding: EdgeInsets.only(
                left: SizeConfig.resizeWidth(9.35),
                bottom: SizeConfig.resizeWidth(4),
              ),
              child: Text("No offers found"))
        ],
      ],
    );
  }

  Padding buildHeading() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.resizeWidth(9.35),
      ),
      child: Text(
        'User Offers',
        style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: SizeConfig.resizeFont(12.31),
            color: Theme.of(context).appBarTheme.foregroundColor),
      ),
    );
  }

  Padding buildSubHeading(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.resizeWidth(9.35),
      ),
      child: InkWell(
        onTap: () {
          _showDialog();
        },
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Padding(
                      padding: EdgeInsets.only(right: 5, left: 2),
                      child: Image.asset('assets/filter.png')),
                  Expanded(
                    child: Text(
                      'Filter Offers',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: SizeConfig.resizeFont(10.8),
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                  InkWell(
                    onTap: widget.clearFillterCallback,
                    child: Text(
                      'Clear filters',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: SizeConfig.resizeFont(10.8),
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: false,
              child: InkWell(
                onTap: () {
                  _showDialog();
                },
                child: Text(
                  '< Back to top offers',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: SizeConfig.resizeFont(8.42),
                      color: Theme.of(context).colorScheme.secondary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card offerCard(Ads? ads, int index) {
    final days =
        Helper.calculateDays(DateTime.now(), DateTime.parse(ads!.expiry!));
    return Card(
      elevation: 3,
      shadowColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(
        left: 0,
        right: SizeConfig.resizeWidth(4),
        top: SizeConfig.resizeHeight(2),
        bottom: SizeConfig.resizeHeight(1),
      ),
      child: Container(
        width: SizeConfig.resizeWidth(59.12),
        padding: EdgeInsets.only(
          left: SizeConfig.resizeWidth(4.68),
          right: SizeConfig.resizeWidth(4.68),
          top: SizeConfig.resizeWidth(4),
          // bottom: SizeConfig.resizeWidth(2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Text(
                  '1 ${ads.sellingCurrency} = ${ads.rate?.value!.toStringAsFixed(5)} ${ads.buyingCurrency}',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: SizeConfig.resizeFont(11.22),
                      color: Theme.of(context).appBarTheme.foregroundColor),
                ),
                SizedBox(
                  width: SizeConfig.resizeWidth(2),
                ),
              ],
            ),
            Text(
              'GOOD DEAL!',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: SizeConfig.resizeFont(5.61),
                color: Color(0xff59D20F),
              ),
            ),
            Text(
              'Offer expires in ${days == 0 ? days + 1 : days} days',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.resizeFont(8.42),
                  color: Theme.of(context).textTheme.bodyText2?.color),
            ),
            SizedBox(
              height: SizeConfig.resizeHeight(1.25),
            ),
            Text(
              'Limit: ${ads.sellingLimit} ${ads.sellingCurrency}',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: SizeConfig.resizeFont(8.42),
                  color: Colors.grey.shade900),
            ),
            buildSellerInfo(index),
            if (widget.showButtons) buildOfferCardButton(ads)
          ],
        ),
      ),
    );
  }

  Widget buildSellerInfo(int index) {
    return Consumer<UserOffersProvider>(builder: (context, response, child) {
      if (response.sellers.status == Status.LOADING)
        return Container(
          padding: EdgeInsets.symmetric(vertical: 10),
            child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2,)));
      if (response.fetchOffersSellers == null ||
          response.fetchOffersSellers.length == 0)
        return Text('No seller found');
      final inital =
          response.fetchOffersSellers[index].firstName!.split('').first;
              response.fetchOffersSellers[index].lastName! != '' ? response.fetchOffersSellers[index].lastName!.split('').first : '';
      return Padding(
        padding: EdgeInsets.only(
          top: SizeConfig.resizeHeight(2),
          bottom: SizeConfig.resizeHeight(3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: response.fetchOffersSellers[index].profilePhoto != null
                  ? ClipOval(
                      child: Image.network(
                          response.fetchOffersSellers[index].profilePhoto!),
                    )
                  : Material(
                      elevation: 1,
                      color: FiatColors.fiatGreen,
                      borderRadius: BorderRadius.circular(20),
                      clipBehavior: Clip.antiAlias,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(left: 2.0, right: 2.0),
                          child: Text(
                            inital,
                            style: TextStyle(
                                color: FiatColors.white, fontSize: 14),
                          ),
                        ),
                      ),
                    ),
            ),
            SizedBox(
              width: SizeConfig.resizeWidth(1.5),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  response.fetchOffersSellers[index].nickName ?? response.fetchOffersSellers[index].firstName!,
                  style: TextStyle(
                      fontSize: SizeConfig.resizeFont(7),
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: SizeConfig.resizeHeight(0.5),
                ),
                RatingBar(
                  initialRating: response.fetchOffersSellers[index].rating!,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  ignoreGestures: true,
                  itemSize: 12,
                  ratingWidget: RatingWidget(
                    full: Image.asset('assets/rating_star_filled.png'),
                    half: Image.asset('assets/rating_star_empty.png'),
                    empty: Image.asset('assets/rating_star_empty.png'),
                  ),
                  itemPadding: EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                  onRatingUpdate: (double value) {},
                ),
              ],
            )
          ],
        ),
      );
    });
  }

  Row buildOfferCardButton(Ads? ads) {
    widget.userOffersProvider.setSelectedOfferSellerByAdd();
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () {
              widget.userOffersProvider.setSelectedOffer(ads);
              widget.onTapCallback(widget.userOffersProvider.selectedOffer!,
                  widget.userOffersProvider.sellerOfferData!);
            },
            child: Text(widget.userOffersProvider.selectedOffer?.id == ads?.id && widget.userOffersProvider.selectedFiatOffer == null
                ? 'Offer Selected'
                : 'Use Offer'),
            style: TextButton.styleFrom(
                side:
                    BorderSide(color: Theme.of(context).colorScheme.secondary),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(200)),
                textStyle: TextStyle(
                    fontSize: SizeConfig.resizeFont(9),
                    fontWeight: FontWeight.w500),
                primary: Theme.of(context).primaryColor,
                backgroundColor:
                    widget.userOffersProvider.selectedOffer?.id == ads?.id && widget.userOffersProvider.selectedFiatOffer == null
                        ? Color(0xff1B6F41)
                        : Theme.of(context).colorScheme.secondary,
                minimumSize: Size(
                  double.infinity,
                  SizeConfig.resizeHeight(8),
                ),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.zero),
          ),
        ),
        SizedBox(
          width: SizeConfig.resizeWidth(3),
        ),
        Expanded(
          child: ads!.openToNegotiate!
              ? Text(
            'Negotiation\navailable',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xff1B6F41),
              fontWeight: FontWeight.w400,
              fontSize: SizeConfig.resizeFont(7.7),
            ),
          )
              : Text(
                  'Negotiation\nunavailable',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: SizeConfig.resizeFont(7.7),
                  ),
                ),
        ),
      ],
    );
  }

  _showDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return FilterDialog(
            onUpdateCallback:
                (offferExpire, userTrasnaction, sortBy, maxLimit) {
              widget.onUpdateCallback(
                  offferExpire, userTrasnaction, sortBy, maxLimit);
            },
          );
        });
  }
}
