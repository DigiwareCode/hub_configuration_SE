import '../models/hub.dart';
import '../utils/result.dart';

abstract class HubRepository {
  Future<Result<Hub>> findBySerialNumber(String serialNumber);

  Future<Result<void>> configure(Hub hub);

  Future<Result> configureWifi(
      {required String wifiName, required String wifiPassword});
}
