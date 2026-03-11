import 'package:flutter/foundation.dart';
import 'package:jabber/models/address.dart';

class AppData extends ChangeNotifier {
  Address _pickUpLocation, _dropOffLocation;

  Address get pickUpLocation => _pickUpLocation;
  Address get dropOffLocation => _dropOffLocation;

  void updatePickUpLocationAddress(Address pickUpAddress) {
    _pickUpLocation = pickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Address dropOffAddress) {
    _dropOffLocation = dropOffAddress;
    notifyListeners();
  }
}
