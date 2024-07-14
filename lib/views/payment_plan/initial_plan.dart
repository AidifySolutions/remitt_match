import 'package:fiat_match/models/plans/plans.dart';
import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/provider/new/payment_plan_provider.dart';
import 'package:fiat_match/utils/loader.dart';
import 'package:fiat_match/utils/styles.dart';
import 'package:fiat_match/widgets/new/fm_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InitialPaymentPlan extends StatefulWidget {
  final Function(Plans) onSelectPlan;
  InitialPaymentPlan({Key? key, required this.onSelectPlan}) : super(key: key);

  @override
  _InitialPaymentPlanState createState() => _InitialPaymentPlanState();
}

class _InitialPaymentPlanState extends State<InitialPaymentPlan> {
  late PaymentPlanProvider _paymentPlanProvider;
  @override
  void initState() {
    _paymentPlanProvider =
        Provider.of<PaymentPlanProvider>(context, listen: false);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _paymentPlanProvider.getInitialPlans();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentPlanProvider>(builder: (context, response, child) {
      if (response.intialPlans.status == Status.LOADING) return Loader();

      if (response.intialPlans.status == Status.COMPLETED)
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Choose a payment plan",
                style: FiatStyles.setStyle(
                    style: FiatStyles.heading1(), color: FiatColors.white),
              ),
              Column(
                  children: response.intialPlans.data!.plans!
                      .map(
                        (e) => _paymentCard(e),
                      )
                      .toList()),
              SizedBox(
                height: 32,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2,
                child: FmSubmitButton(
                    text: 'Cancel',
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    showWhiteBorder: true,
                    showOutlinedButton: true),
              ),
            ],
          ),
        );
      return Container();
    });
  }

  Widget _paymentCard(Plans e) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 12),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
            Radius.circular(4.0) //                 <--- border radius here
            ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e.name!, style: FiatStyles.body2()),
                    Text(
                      '\$' + ' ' + e.price!.toString(),
                      style: FiatStyles.body5(),
                    ),
                  ],
                ),
                SizedBox(
                  height: 48,
                  width: 100,
                  child: FmSubmitButton(
                      text: 'Choose plan',
                      onPressed: () {
                        widget.onSelectPlan(e);
                      },
                      showOutlinedButton: false),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                  child: Text('.',
                      style: FiatStyles.setStyle(
                          style: FiatStyles.body5(),
                          color: FiatColors.fiatGreen)),
                ),
                if (e.name == 'Freemium')
                  Text('One transaction per month.', style: FiatStyles.body3()),
                if (e.name == 'Basic')
                  Text('\$ ${e.price} for every \$1000 sent.',
                      style: FiatStyles.body3()),
                if (e.name == 'Premium')
                  Flexible(
                    child: Text(
                        'For individuals needing frequent money transfer.',
                        style: FiatStyles.body3()),
                  ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, right: 8.0),
                  child: Text('.',
                      style: FiatStyles.setStyle(
                          style: FiatStyles.body5(),
                          color: FiatColors.fiatGreen)),
                ),
                if (e.name == 'Basic' || e.name == 'Freemium') ...[
                  Text('Monthly transaction limit of \$${e.transactionLimit}',
                      style: FiatStyles.body3()),
                ],
                if (e.name == 'Premium') ...[
                  Text('Maximum \$${e.transactionLimit} send value per month',
                      style: FiatStyles.body3()),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
