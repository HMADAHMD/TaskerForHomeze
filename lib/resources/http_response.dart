import 'package:geolocator/geolocator.dart';
import 'package:homezetasker/models/directions.dart';
import 'package:homezetasker/provider/tasker_provider.dart';
import 'package:homezetasker/resources/http_request.dart';
import 'package:homezetasker/utils/constants.dart';
import 'package:provider/provider.dart';

class HttpResponse {
  static Future<String> responseGot(Position position, context) async {
    String apiUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${map_keys}";
    String readableAddress = '';

    var reqResponse = await RequestAssistant.receiveRequest(apiUrl);
    if (reqResponse != 'Error Occured') {
      readableAddress = reqResponse['results'][0]['formatted_address'];

      Directions userAddress = Directions();
      userAddress.locationLatitude = position.latitude;
      userAddress.locationLongitude = position.longitude;
      userAddress.locationName = readableAddress;
      Provider.of<TaskerProvider>(context, listen: false)
          .updateUserAddress(userAddress);
    }

    return readableAddress;
  }
}
