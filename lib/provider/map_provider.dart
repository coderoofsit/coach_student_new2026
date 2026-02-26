import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_places_flutter/model/prediction.dart';

class MapProvider extends ChangeNotifier {
  List<Prediction> _predictionList = [];
  bool isLoadingLatLang = false;

  Future<Map<String, dynamic>?> getLatLngFromAddress(
    String address,
  ) async {
    isLoadingLatLang = true;
    notifyListeners();
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        double latitude = location.latitude;
        double longitude = location.longitude;
        return {
          "lattitude": latitude,
          "longitude": longitude,
        };
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoadingLatLang = false;
      notifyListeners();
    }
    return null;
  }

  Future<List<Prediction>> searchLocation(
      BuildContext context, String text) async {
    // Note: google_places_flutter uses a widget-based approach
    // This method signature is kept for compatibility but the actual
    // implementation is now in the SelectAddress widget
    return _predictionList;
  }

  void updatePredictions(List<Prediction> predictions) {
    _predictionList = predictions;
    notifyListeners();
  }
}

final mapProvider = ChangeNotifierProvider<MapProvider>((ref) {
  return MapProvider();
});
