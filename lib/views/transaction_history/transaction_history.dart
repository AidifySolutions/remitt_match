import 'package:fiat_match/models/trade_info.dart';
import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/provider/new/login_provider.dart';
import 'package:fiat_match/provider/new/rate_provider.dart';
import 'package:fiat_match/provider/new/transaction_history_provider.dart';
import 'package:fiat_match/utils/constants.dart';
import 'package:fiat_match/utils/helper.dart';
import 'package:fiat_match/utils/size_config.dart';
import 'package:fiat_match/utils/styles.dart';
import 'package:fiat_match/views/home/landing_new.dart';
import 'package:fiat_match/views/transaction_history/transcation_detail.dart';
import 'package:fiat_match/widgets/fm__home_screen_loader.dart';
import 'package:fiat_match/widgets/fm_dialog.dart';
import 'package:fiat_match/widgets/fm_toast.dart';
import 'package:fiat_match/widgets/new/fm_input_fields.dart';
import 'package:fiat_match/widgets/new/fm_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Transaction extends StatefulWidget {
  final bool activeTrade;

  const Transaction({Key? key, this.activeTrade = false}) : super(key: key);

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  late TransactionHistoryProvider _transactionHistoryProvider;
  late ScrollController _scrollController = ScrollController();
  late RatingProvider _ratingProvider;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _transactionHistoryProvider =
        Provider.of<TransactionHistoryProvider>(context, listen: false);
    _transactionHistoryProvider.reset();
    _transactionHistoryProvider.customer =
        context.read<LoginProvider>().authentication.data?.customerData;
    _ratingProvider = Provider.of<RatingProvider>(context, listen: false);
    //_transactionHistoryProvider.reset();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      getTradesHistory();
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_transactionHistoryProvider.pageCount <=
            _transactionHistoryProvider.trade.data!.paging!.totalPages!) {
          getTradesHistory();
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _transactionHistoryProvider.reset();
    print('transactionhistory dispose');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: widget.activeTrade ? null : buildAppBar(),
      body: Container(
        padding: EdgeInsets.only(
            left: SizeConfig.resizeWidth(6.14),
            right: SizeConfig.resizeWidth(6.16),
            top: SizeConfig.resizeWidth(4.11),
            bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            Consumer<TransactionHistoryProvider>(
                builder: (context, response, child) {
              if (response.trade.status == Status.LOADING) {
                if (_transactionHistoryProvider.paginatedTradeData.length ==
                    0) {
                  return FmHomeScreenLoader();
                } else {
                  return listOfTransactionHistory(true);
                }
              } else if (response.trade.status == Status.ERROR) {
                WidgetsBinding.instance!.addPostFrameCallback((_) {
                  _showDialog(response.trade.message ?? '', 'Cancel',
                      Icons.error_outline);
                });
                return Container();
              } else if (response.trade.status == Status.COMPLETED) {
                if (response.trade.data!.trades!.length > 0 &&
                    response.buyerAndSellerData.length > 0) {
                  return listOfTransactionHistory(false);
                } else {
                  return noTransactionContainer();
                }
              } else {
                return Container();
              }
            })
          ],
        ),
      ),
    );
  }

  Widget listOfTransactionHistory(bool isLoading) {
    return Expanded(
      child: ListView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _transactionHistoryProvider.paginatedTradeData.length,
          itemBuilder: (BuildContext context, int index) {
            if (isLoading &&
                index ==
                    _transactionHistoryProvider.paginatedTradeData.length - 1) {
              return FmHomeScreenLoader();
            }
            return tradeCard(
                _transactionHistoryProvider.paginatedTradeData[index]);
          }),
    );
  }

  Expanded noTransactionContainer() {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Image.asset(
            'assets/no_recipient.png',
            width: 200,
          ),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.resizeWidth(10.26),
                vertical: SizeConfig.resizeHeight(8.21)),
            alignment: Alignment.center,
            child: Text(
              'You haven’t performed any transactions yet.',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.resizeFont(12.31)),
            ),
          ),
          Container(
            padding:
                EdgeInsets.symmetric(horizontal: SizeConfig.resizeWidth(10.26)),
            alignment: Alignment.center,
            child: Text(
              'Go to the home page to perform a transaction.',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.resizeFont(12.31)),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: SizeConfig.resizeWidth(20),
                vertical: SizeConfig.resizeHeight(10.26)),
            child: FmSubmitButton(
              text: 'Perform transaction',
              onPressed: () {
                goToNewScreen(LandingNewPage());
              },
              showOutlinedButton: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget tradeCard(Trade trade) {
    return InkWell(
      onTap: widget.activeTrade
          ? () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TradeDetails(
                          trade: trade,
                        )),
              )
          : null,
      child: Card(
        elevation: 3,
        shadowColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.only(
          left: 0,
          // right: SizeConfig.resizeWidth(4),
          top: SizeConfig.resizeHeight(2),
          bottom: SizeConfig.resizeHeight(2),
        ),
        child: Container(
          // width: SizeConfig.resizeWidth(59.12),
          padding: EdgeInsets.only(
            left: SizeConfig.resizeWidth(4.68),
            right: SizeConfig.resizeWidth(4.68),
            top: SizeConfig.resizeWidth(4),
            bottom: SizeConfig.resizeWidth(2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recipient',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: SizeConfig.resizeFont(8.42),
                              color:
                                  Theme.of(context).textTheme.bodyText2?.color),
                        ),
                        Text(
                          '${_transactionHistoryProvider.getSellerBuyerName(trade.buyer?.buyerId)}',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: SizeConfig.resizeFont(10.8),
                              color: Theme.of(context)
                                  .appBarTheme
                                  .foregroundColor),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.resizeWidth(2),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Amount',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: SizeConfig.resizeFont(8.42),
                              color:
                                  Theme.of(context).textTheme.bodyText2?.color),
                        ),
                        Text(
                          '${trade.currencyCount} ${trade.fromCurrency}',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: SizeConfig.resizeFont(10.8),
                              color: Theme.of(context)
                                  .appBarTheme
                                  .foregroundColor),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.resizeWidth(2),
                  ),
                ],
              ),
              SizedBox(
                height: SizeConfig.resizeWidth(2),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Seller',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: SizeConfig.resizeFont(8.42),
                              color:
                                  Theme.of(context).textTheme.bodyText2?.color),
                        ),
                        Text(
                          '${_transactionHistoryProvider.getSellerBuyerName(trade.seller?.sellerId)}',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: SizeConfig.resizeFont(10.8),
                              color: Theme.of(context)
                                  .appBarTheme
                                  .foregroundColor),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.resizeWidth(2),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rate',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: SizeConfig.resizeFont(8.42),
                              color:
                                  Theme.of(context).textTheme.bodyText2?.color),
                        ),
                        Text(
                          '1 ${trade.fromCurrency} = ${trade.agreedRate?.toStringAsPrecision(5)} ${trade.toCurrency}',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: SizeConfig.resizeFont(10.8),
                              color: Theme.of(context)
                                  .appBarTheme
                                  .foregroundColor),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.resizeWidth(2),
                  ),
                ],
              ),
              SizedBox(
                height: SizeConfig.resizeWidth(2),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: SizeConfig.resizeFont(8.42),
                              color:
                                  Theme.of(context).textTheme.bodyText2?.color),
                        ),
                        Text(
                          '${Helper.dateTimeFormat(widget.activeTrade ? trade.creationDateTime : trade.updatedDateTime)}',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: SizeConfig.resizeFont(8.42),
                              color: Colors.grey.shade900),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Text(
                        //   'Status',
                        //   style: TextStyle(
                        //       fontWeight: FontWeight.w400,
                        //       fontSize: SizeConfig.resizeFont(8.42),
                        //       color: Theme.of(context).textTheme.bodyText2?.color),
                        // ),

                        _statusChip(trade)
                      ],
                    ),
                  ),
                ],
              ),
              showRatingOption(trade)
            ],
          ),
        ),
      ),
    );
  }

  Widget showRatingOption(Trade trade) {
    bool showRating = true;
    String label = '';
    var isUserBuyer =
        _transactionHistoryProvider.customer?.id == trade.buyer?.buyerId;
    var isUserSeller =
        _transactionHistoryProvider.customer?.id == trade.seller?.sellerId;
    if (trade.tradeType == 'UserBased' &&
        trade.status?.status ==
            Helper.getEnumValue(TradeStatus.Completed.toString())) {
      if (isUserBuyer) {
        showRating = trade.buyerRating ?? true;
        label = 'seller';
      } else {
        showRating = trade.sellerRating ?? true;
        label = 'buyer';
      }
    }
    return InkWell(
      onTap: () {
        _showPayemntSuccessDialog(context,
            label: label, isUserBuyer: isUserBuyer, trade: trade);
      },
      child: Align(
          alignment: Alignment.bottomRight,
          child: Visibility(
              visible: !showRating,
              child: Text('Rate your $label',
                  style: TextStyle(
                      color: Color(0xff2FBF71),
                      decoration: TextDecoration.underline)))),
    );
  }

  _showPayemntSuccessDialog(BuildContext context,
      {required bool isUserBuyer, String? label = '', Trade? trade}) {
    var _descriptionCOntroller = TextEditingController();
    double? _selectedRating = 0.0;
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return StreamBuilder<Object>(builder: (context, snapshot) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 40,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: SizeConfig.resizeHeight(9.35)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(Icons.check_circle_sharp,
                            size: SizeConfig.resizeWidth(14),
                            color: Theme.of(context).accentColor),
                        Padding(
                          padding: EdgeInsets.only(
                              left: SizeConfig.resizeWidth(8),
                              right: SizeConfig.resizeWidth(8),
                              top: SizeConfig.resizeWidth(5.61),
                              bottom: SizeConfig.resizeHeight(5.61)),
                          child: Text(
                            'Transaction complete!',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: SizeConfig.resizeFont(11.22),
                                color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: SizeConfig.resizeWidth(8),
                              right: SizeConfig.resizeWidth(8),
                              top: SizeConfig.resizeWidth(1.61),
                              bottom: SizeConfig.resizeHeight(5.61)),
                          child: Column(
                            children: [
                              Text(
                                'Rate your $label',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: SizeConfig.resizeFont(11.22),
                                    color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: SizeConfig.resizeWidth(2.61),
                                    bottom: SizeConfig.resizeWidth(2.61)),
                                child: Text(
                                  'Any comments about the $label?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: SizeConfig.resizeFont(11.22),
                                      color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: SizeConfig.resizeWidth(2.61),
                                    bottom: SizeConfig.resizeWidth(2.61)),
                                child: RatingBar(
                                  initialRating: 1.0,
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemSize: 32,
                                  ratingWidget: RatingWidget(
                                    full: Image.asset(
                                        'assets/rating_star_filled.png'),
                                    half: Image.asset(
                                        'assets/rating_star_empty.png'),
                                    empty: Image.asset(
                                        'assets/rating_star_empty.png'),
                                  ),
                                  itemPadding: EdgeInsets.symmetric(
                                      horizontal: 2, vertical: 0),
                                  onRatingUpdate: (double value) {
                                    _selectedRating = value;
                                  },
                                ),
                              ),
                              FmInputFields(
                                  title: '',
                                  obscureText: false,
                                  textEditingController: _descriptionCOntroller,
                                  textInputType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  onValidation: (value) {
                                    if (value.isEmpty) {
                                      return 'Required';
                                    }
                                  },
                                  autoFocus: false,
                                  maxLines: 4),
                            ],
                          ),
                        ),
                        Consumer<RatingProvider>(
                            builder: (context, response, child) {
                          if (response.rate.status == Status.LOADING) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          return Padding(
                            padding: EdgeInsets.only(
                                left: SizeConfig.resizeWidth(20.5),
                                right: SizeConfig.resizeWidth(20.5),
                                bottom: SizeConfig.resizeWidth(9.2)),
                            child: FmSubmitButton(
                                text: 'Submit',
                                onPressed: () async {
                                  try {
                                    await _ratingProvider.submitTradeRating(
                                        comments: _descriptionCOntroller.text,
                                        rating: _selectedRating!.toInt(),
                                        subject: isUserBuyer
                                            ? trade?.seller?.sellerId
                                            : trade?.buyer?.buyerId,
                                        critic: isUserBuyer
                                            ? trade?.buyer?.buyerId
                                            : trade?.seller?.sellerId,
                                        tradeId: trade!.id //to be asked
                                        );
                                    if (response.rate.status == Status.ERROR) {
                                      _showSnackBar(
                                          msg: _ratingProvider.rate.message ??
                                              '');
                                      response.rate.status = Status.INITIAL;
                                    } else if (response.rate.status ==
                                        Status.COMPLETED) {
                                      _showSnackBar(
                                          msg: _ratingProvider
                                                  .rate.data?.message ??
                                              '');
                                    }
                                  } catch (exp) {
                                    print(exp);
                                  } finally {}

                                  Navigator.pop(context, true);
                                },
                                showOutlinedButton: false),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  Container _statusChip(Trade trade) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        color: Color(getTradeStatusColor(trade.status?.status ?? '')),
      ),
      child: Text(
        '${getTradeStatusMsg(trade.status?.status ?? '')}',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: SizeConfig.resizeFont(7.01),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        widget.activeTrade ? 'Active Trades' : 'Transaction History',
        style: TextStyle(
            fontSize: SizeConfig.resizeFont(12.31),
            fontWeight: FontWeight.w500),
      ),
      centerTitle: true,
      elevation: 1,
      leadingWidth: 105,
    );
  }

  getTradesHistory() async {
    await context
        .read<TransactionHistoryProvider>()
        .getAllTrade(activeTrades: widget.activeTrade);
  }

  _showDialog(String title, String buttonText, IconData icon) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return FmDialogWidget(
              iconData: icon,
              title: title,
              message: '',
              buttonText: buttonText,
              voidCallback: () async {
                context.read<TransactionHistoryProvider>().reset();
                Navigator.pop(dialogContext);
              });
        });
  }

  _showSnackBar({String msg = ''}) {
    final snackBar = SnackBar(
      content: Text(msg),
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  goToNewScreen(Widget screen) async {
    _transactionHistoryProvider.reset();
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  int getTradeStatusColor(String tradeStatus) {
    switch (tradeStatus) {
      case 'AwaitingConfirmation':
      case 'InReview':
      case 'AwaitingPayment':
      case 'AwaitingSettlement':
      case 'AwaitingVerification':
        return 0xffFB7800; //orange
      case 'Rejected':
        return 0xffFF0B0B; //red
      case 'Completed':
        return 0xff2FBF71; //green
      case 'Cancelled':
        return 0xffFF0B0B; //red

      default:
        return 0xffFFFFFF;
    }
  }

  String getTradeStatusMsg(String tradeStatus) {
    switch (tradeStatus) {
      case 'AwaitingConfirmation':
        return 'In Progress'; //orange
      case 'Completed':
        return 'Successful'; //green
      case 'Cancelled':
        return 'Discard'; //red
      case 'InReview':
        return 'In Review'; //orange
      case 'AwaitingPayment':
        return 'Awaiting Payment'; //orange
      case 'AwaitingSettlement':
        return 'Awaiting Settlement';
      case 'AwaitingVerification':
        return 'Awaiting Verification';
      case 'Rejected':
        return 'Rejected'; //red
      default:
        return 'No status found';
    }
  }
}
