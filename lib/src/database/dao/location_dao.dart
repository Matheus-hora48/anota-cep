import '../../models/location_model.dart';

abstract class LocationDao {
  Future<int> saveLocation(LocationModel location);
  Future<List<LocationModel>> getAllLocations();
  Future<int> deleteLocation(int id);
  Future<bool> getLocationByZipCode(String zipCode);
}
