import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../../../data/model/address_model.dart';
import 'add_address_view.dart';

class AddressController extends GetxController {
  final addressList = <AddressModel>[].obs;
  final isLoading = true.obs;
  final isMapLoading = true.obs;
  final isSaving = false.obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController locationNameController;
  late final TextEditingController buildingController;
  late final TextEditingController flatController;

  final selectedType = "Home".obs;

  GoogleMapController? mapController;
  var currentPosition = const LatLng(23.8103, 90.4125).obs;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    locationNameController = TextEditingController();
    buildingController = TextEditingController();
    flatController = TextEditingController();

    loadAddresses(); // অ্যাপ ওপেন হলেই ক্যাশ থেকে অ্যাড্রেস লোড হবে
  }

  // ✅ Cash Memory (SharedPreferences) থেকে ডাটা রিড
  Future<void> loadAddresses() async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? addressesString = prefs.getString('saved_addresses');

      if (addressesString != null && addressesString.isNotEmpty) {
        List<dynamic> jsonList = jsonDecode(addressesString);
        addressList.assignAll(jsonList.map((e) => AddressModel.fromJson(Map<String, dynamic>.from(e))).toList());
      } else {
        addressList.clear();
      }
    } catch (e) {
      debugPrint("Error loading addresses: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Cash Memory (SharedPreferences) তে ডাটা সেভ
  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(addressList.map((e) => e.toJson()).toList());
    await prefs.setString('saved_addresses', jsonString);
  }

  // --- Map Logic ---
  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void onCameraIdle() {
    _getAddressFromLatLng(currentPosition.value);
  }

  void onCameraMove(CameraPosition position) {
    currentPosition.value = position.target;
  }

  Future<void> getUserCurrentLocation() async {
    HapticFeedback.mediumImpact();
    isMapLoading.value = true;

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!kIsWeb) Get.snackbar("Notice", "Please enable location services.");
        isMapLoading.value = false;
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar("Permission Denied", "Location permissions are required.");
          isMapLoading.value = false;
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      currentPosition.value = LatLng(position.latitude, position.longitude);

      if (mapController != null) {
        mapController!.animateCamera(CameraUpdate.newLatLngZoom(currentPosition.value, 16));
      }

      await _getAddressFromLatLng(currentPosition.value);
    } catch (e) {
      debugPrint("Location error: $e");
    } finally {
      isMapLoading.value = false;
      HapticFeedback.heavyImpact();
    }
  }

  Future<void> _getAddressFromLatLng(LatLng pos) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address = "${place.street}, ${place.subLocality}, ${place.locality}";
        locationNameController.text = address.replaceAll(RegExp(r', ,|, $|^, '), '').trim();
      }
    } catch (e) {
      debugPrint("Address fetch error: $e");
    }
  }

  // --- CRUD Actions ---
  Future<void> saveAddress() async {
    HapticFeedback.lightImpact();

    if (!(formKey.currentState?.validate() ?? false)) {
      Get.snackbar("Missing Info", "Please fill all required fields", backgroundColor: Colors.redAccent, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(16));
      return;
    }

    isSaving.value = true;
    await Future.delayed(const Duration(milliseconds: 600));

    String fullAddress = "";
    if (flatController.text.isNotEmpty) fullAddress += "Flat: ${flatController.text.trim()}, ";
    if (buildingController.text.isNotEmpty) fullAddress += "Bldg: ${buildingController.text.trim()}, ";
    fullAddress += locationNameController.text.trim();

    final newAddress = AddressModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: selectedType.value,
      fullName: nameController.text.trim(),
      phone: phoneController.text.trim(),
      addressLine: fullAddress,
      isSelected: addressList.isEmpty,
    );

    if (newAddress.isSelected) {
      for (var item in addressList) {
        item.isSelected = false;
      }
    }

    addressList.insert(0, newAddress);
    await _saveToPrefs(); // সেভ টু ক্যাশ

    isSaving.value = false;
    Get.back();
    Get.snackbar("Success", "Address saved successfully!", backgroundColor: Colors.green.shade700, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM, margin: const EdgeInsets.all(20));

    _clearForm();
  }

  void selectAddress(int index) async {
    HapticFeedback.selectionClick();
    for (var item in addressList) {
      item.isSelected = false;
    }
    addressList[index].isSelected = true;
    addressList.refresh();
    await _saveToPrefs();
  }

  void deleteAddress(int index) async {
    HapticFeedback.mediumImpact();
    Get.defaultDialog(
        title: "Delete Address",
        middleText: "Are you sure you want to delete this address?",
        textConfirm: "Delete",
        textCancel: "Cancel",
        confirmTextColor: Colors.white,
        buttonColor: Colors.redAccent,
        onConfirm: () async {
          addressList.removeAt(index);
          await _saveToPrefs();
          Get.back();
        }
    );
  }

  void changeType(String type) {
    HapticFeedback.selectionClick();
    selectedType.value = type;
  }

  void goToCheckout() {
    final selected = addressList.firstWhereOrNull((element) => element.isSelected == true);
    if (selected == null) {
      Get.snackbar("Select Address", "Please select a delivery address.");
      return;
    }
    Get.back(result: selected); // রিটার্ন ভ্যালুসহ ব্যাক করবে
  }

  void goToAddAddress() {
    _clearForm();
    Get.to(() => const AddAddressView());
    getUserCurrentLocation();
  }

  void _clearForm() {
    nameController.clear();
    phoneController.clear();
    locationNameController.clear();
    buildingController.clear();
    flatController.clear();
    selectedType.value = "Home";
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    locationNameController.dispose();
    buildingController.dispose();
    flatController.dispose();
    mapController?.dispose();
    super.onClose();
  }
}