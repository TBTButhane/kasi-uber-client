import 'package:jabber/models/nearbyAvailableDrivers.dart';

class GeofireAssistant {
  static List<NearByAvailableDrivers> nearbyAvailableDriversList = [];
  static void removeDriverFromList(String key) {
    int index =
        nearbyAvailableDriversList.indexWhere((element) => element.key == key);
    nearbyAvailableDriversList.removeAt(index);
  }

  static void updateDriverNearbyLocation(NearByAvailableDrivers driver) {
    int index = nearbyAvailableDriversList
        .indexWhere((element) => element.key == driver.key);
    nearbyAvailableDriversList[index].lat = driver.lat;
    nearbyAvailableDriversList[index].lng = driver.lng;
  }
}
