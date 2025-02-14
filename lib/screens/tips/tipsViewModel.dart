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
        Map<String, dynamic> testMap = doc["test2"];
        return testMap.entries
            .map((entry) =>
                {"title": entry.key, "description": entry.value.toString()})
            .toList();
      }).toList();
    } catch (e) {
      print("❌ Error fetching data: $e");
    }
    setBusy(false);
    notifyListeners();
  }
}
