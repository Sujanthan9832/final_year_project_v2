import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stacked/stacked.dart';

class TipsViewModel extends BaseViewModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, String>> _tips = [];

  List<Map<String, String>> get tips => _tips;

  Future<void> fetchAllTips() async {
    setBusy(true);
    try {
      QuerySnapshot querySnapshot = await _firestore.collection("tips").get();

      _tips = querySnapshot.docs.expand((doc) {
        Map<String, dynamic> testMap = doc["test2"]; // Fetch the map
        return testMap.entries
            .map((entry) => {
                  "title": entry.key, // Key (e.g., "tip1", "tip2")
                  "description": entry.value.toString() // Value (actual tip)
                })
            .toList();
      }).toList();
    } catch (e) {
      print("❌ Error fetching data: $e");
    }
    setBusy(false);
    notifyListeners();
  }
}
