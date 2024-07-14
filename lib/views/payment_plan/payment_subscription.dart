// import 'package:fiat_match/models/plans/plans.dart';
// import 'package:fiat_match/models/plans/subscriptions.dart';
// import 'package:fiat_match/utils/loader.dart';
// import 'package:fiat_match/utils/size_config.dart';
// import 'package:fiat_match/utils/styles.dart';
// import 'package:fiat_match/views/payment_plan/payment_plan_add.dart';
// import 'package:fiat_match/widgets/new/fm_submit_button.dart';
// import 'package:flutter/material.dart';
//
// class PaymentPlanSubscription extends StatefulWidget {
//   final List<Subscription> subscriptions;
//   final Plans plan;
//   PaymentPlanSubscription(
//       {Key? key, required this.subscriptions, required this.plan})
//       : super(key: key);
//
//   @override
//   _PaymentPlanSubscriptionState createState() =>
//       _PaymentPlanSubscriptionState();
// }
//
// class _PaymentPlanSubscriptionState extends State<PaymentPlanSubscription> {
//   int _groupValue = 0;
//   var _selectedSubcritpion;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xfff5f5f5),
//       appBar: buildAppBar(),
//       body: _buildBody(),
//     );
//   }
//
//   Widget _buildBody() {
//     return SafeArea(
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: SizeConfig.resizeWidth(9.35)),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             SizedBox(
//               height: 32,
//             ),
//             Text(
//               "Extra Savings",
//               style: FiatStyles.body2()
//                   .copyWith(fontSize: 21, fontWeight: FontWeight.w600),
//             ),
//             Text('Contact us',
//                 style: FiatStyles.body2()
//                     .copyWith(fontSize: 42, fontWeight: FontWeight.w700)),
//             SizedBox(
//               height: 16,
//             ),
//             Expanded(
//               child: Container(
//                 margin: const EdgeInsets.all(15.0),
//                 padding: const EdgeInsets.all(3.0),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.all(Radius.circular(
//                           8.0) //                 <--- border radius here
//                       ),
//                   border: Border.all(color: FiatColors.darkBlue, width: 1),
//                 ),
//                 child: ListView.builder(
//                     shrinkWrap: false,
//                     itemCount: widget.subscriptions == null
//                         ? 1
//                         : widget.subscriptions.length + 1,
//                     itemBuilder: (BuildContext context, int index) {
//                       if (index == 0) {
//                         return _listHeader();
//                       }
//                       index -= 1;
//                       var item = widget.subscriptions[index];
//                       return Column(
//                         children: [
//                           ListTile(
//                             leading: _myRadioButton(
//                               value: index,
//                               onChanged: (newValue) => setState(() {
//                                 _groupValue = newValue;
//                                 _selectedSubcritpion = item;
//                               }),
//                             ),
//                             trailing: Text(
//                               item.price.toString() +
//                                   '/' +
//                                   item.interval.toString(),
//                               style: FiatStyles.body3().copyWith(
//                                 fontSize: 14,
//                               ),
//                             ),
//                             title: Text(item.name!,
//                                 style:
//                                     FiatStyles.body3().copyWith(fontSize: 14)),
//                           ),
//                           divider()
//                         ],
//                       );
//                     }),
//               ),
//             ),
//             //SizedBox(height: 140),
//             Expanded(
//               child: Container(),
//             ),
//             FmSubmitButton(
//                 text: 'Continue to check out',
//                 onPressed: () {
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => PaymentPlanAdd(
//                                 selectedSubscription: _selectedSubcritpion ??
//                                     widget.subscriptions.first,
//                                 selectedplan: widget.plan,
//                               )));
//                 },
//                 showOutlinedButton: false),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Column _listHeader() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 20, top: 8),
//           child: Text(
//             'Billing Cycle',
//             style: FiatStyles.body2()
//                 .copyWith(fontSize: 16, fontWeight: FontWeight.w600),
//           ),
//         ),
//         divider()
//       ],
//     );
//   }
//
//   Widget _myRadioButton({int value = 0, required Function onChanged}) {
//     return Radio(
//       value: value,
//       groupValue: _groupValue,
//       onChanged: (value) {
//         onChanged(value!);
//       },
//     );
//   }
//
//   AppBar buildAppBar() {
//     return AppBar(
//       title: Text('Billing Cycles'),
//       leadingWidth: SizeConfig.resizeWidth(26),
//       titleTextStyle: TextStyle(
//           fontWeight: FontWeight.w500,
//           fontSize: SizeConfig.resizeFont(11.22),
//           color: Theme.of(context).appBarTheme.foregroundColor),
//     );
//   }
// }
