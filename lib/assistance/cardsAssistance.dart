// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:jabber/models/cards.dart';

// class CardAssistace extends ChangeNotifier {
//   //Create an emptyList of cards
//   List<Cards> cards = [];
//   FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//   FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
//   addCard(Cards card) {
//     cards.add(card);
//     firebaseFirestore.collection(firebaseAuth.currentUser.uid).add({
//       "Cardholder": card.cardHolder,
//       "CardNumber": card.cardNumber,
//       "cvvs": card.cvs,
//       "cardExpYear": card.expYear
//     }).then((value) {
//       card.id = "${value.id}";
//     });
//     notifyListeners();
//   }

//   removeCard(id) {
//     var index = cards.indexWhere((el) => el.id == id);
//     if (index != -1) {
//       cards.removeAt(index);
//     }
//     notifyListeners();
//   }

//   updateCard(Cards card) {
//     var index = cards.indexWhere((el) => el.id == card.id);
//     if (index != -1) {
//       cards[index] = card;
//     }
//     notifyListeners();
//   }
// }
