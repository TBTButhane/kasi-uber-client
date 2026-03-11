// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_credit_card/credit_card_form.dart';
// import 'package:flutter_credit_card/credit_card_model.dart';
// import 'package:flutter_credit_card/flutter_credit_card.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:jabber/assistance/cardsAssistance.dart';
// import 'package:jabber/models/cards.dart';

// import 'package:jabber/widgets/cardWidget.dart';
// import 'package:jabber/widgets/progressIndicator.dart';
// import 'package:provider/provider.dart';

// class AddPayMentScreen extends StatefulWidget {
//   static const String idScreen = "PaymentScreen";
//   String name;

//   AddPayMentScreen({
//     Key key,
//     this.name,
//   }) : super(key: key);

//   @override
//   _AddPayMentScreenState createState() => _AddPayMentScreenState();
// }

// class _AddPayMentScreenState extends State<AddPayMentScreen> {
//   String cardNumber;
//   String expiryDate;
//   String cardHolderName;
//   String cvvCode;
//   bool isCvvFocused;
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Jabber Rider",
//             style: GoogleFonts.oswald(
//                 textStyle: TextStyle(fontSize: 25, color: Colors.white))),
//         centerTitle: true,
//         elevation: 5,
//         backgroundColor: Colors.black,
//       ),
//       body: Consumer<CardAssistace>(
//         builder: (context, value, child) => Container(
//           padding: EdgeInsets.all(20),
//           child: Center(
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: value.cards.length,
//               itemBuilder: (context, index) => Column(
//                 children: [
//                   CardWidget(
//                     cHolder: value.cards[index].cardHolder,
//                     cNumber: "${value.cards[index].cardNumber}",
//                     cExp: "${value.cards[index].expYear}",
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         OutlinedButton(
//                             onPressed: () {
//                               print("Updating card");
//                               cardForm(context, updateCard);
//                               print("updating from method update");
//                             },
//                             child: Text("Update Card")),
//                         SizedBox(
//                           width: 15,
//                         ),
//                         OutlinedButton(
//                             onPressed: () {
//                               print("Detele card");
//                               deleteCard(value.cards[index].id);
//                               print("Deleting from method delete");
//                             },
//                             child: Text("Delete Card")),
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       floatingActionButton: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             elevation: 3,
//             primary: Colors.black,
//           ),
//           onPressed: () {
//             cardForm(context, saveCard);
//             // context.read<CardAssistace>().addCard(Cards(
//             //       cardHolder: "",
//             //       cardNumber: "",
//             //       expYear: "",
//             //     ));
//           },
//           child: Text("Add Card", style: TextStyle(color: Colors.white))),
//     );
//   }

//   void cardForm(BuildContext context, Function function) {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) => Dialog(
//               child: Padding(
//                 padding: const EdgeInsets.all(15.0),
//                 child: Expanded(
//                   child: SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         CreditCardForm(
//                           formKey: formKey,
//                           obscureCvv: true,
//                           obscureNumber: true,
//                           cardNumberDecoration: const InputDecoration(
//                             border: OutlineInputBorder(),
//                             labelText: 'Card Number',
//                             hintText: 'XXXX XXXX XXXX XXXX',
//                           ),
//                           expiryDateDecoration: const InputDecoration(
//                             border: OutlineInputBorder(),
//                             labelText: 'Expired Date',
//                             hintText: 'XX/XX',
//                           ),
//                           cvvCodeDecoration: const InputDecoration(
//                             border: OutlineInputBorder(),
//                             labelText: 'CVV',
//                             hintText: 'XXX',
//                           ),
//                           cardHolderDecoration: const InputDecoration(
//                             border: OutlineInputBorder(),
//                             labelText: 'Card Holder',
//                           ),
//                           onCreditCardModelChange: onCreditCardModelChange,
//                         ),
//                         Row(
//                           children: [
//                             ElevatedButton.icon(
//                               label: const Text(
//                                 'Save',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontFamily: 'halter',
//                                   fontSize: 14,
//                                   package: 'flutter_credit_card',
//                                 ),
//                               ),
//                               icon: Icon(Icons.save),
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                                 function();
//                               },
//                             ),
//                             SizedBox(width: 20),
//                             ElevatedButton.icon(
//                               icon: Icon(Icons.cancel_sharp),
//                               label: const Text(
//                                 'Cancel',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontFamily: 'halter',
//                                   fontSize: 14,
//                                   package: 'flutter_credit_card',
//                                 ),
//                               ),
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                               },
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ));
//   }

//   void onCreditCardModelChange(CreditCardModel creditCardModel) {
//     setState(() {
//       cardNumber = creditCardModel.cardNumber;
//       expiryDate = creditCardModel.expiryDate;
//       cardHolderName = creditCardModel.cardHolderName;
//       cvvCode = creditCardModel.cvvCode;
//       isCvvFocused = creditCardModel.isCvvFocused;
//     });
//   }

//   void saveCard() {
//     if (cardHolderName != null) {
//       context.read<CardAssistace>().addCard(Cards(
//           cardHolder: cardHolderName,
//           cardNumber: cardNumber,
//           expYear: expiryDate));
//       showDialog(
//           context: context,
//           builder: (BuildContext context) => ProgressIndi(
//                 message: "Saving Card, please wait",
//               ));
//       Navigator.of(context).pop();
//     } else {
//       print("wagafa");
//     }
//   }

//   void updateCard() {
//     cardHolderName = cardHolderName;
//     cardNumber = cardNumber;
//     expiryDate = expiryDate;
//     setState(() {});
//     context.read<CardAssistace>().updateCard(Cards(
//         cardHolder: cardHolderName,
//         cardNumber: cardNumber,
//         expYear: expiryDate));
//     print("updating from method update");
//   }

//   void deleteCard(id) {
//     context.read<CardAssistace>().removeCard(id);
//   }
// }
