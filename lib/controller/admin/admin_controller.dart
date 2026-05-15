import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Utiles/utiles.dart';
import '../../screens/authentication/signIn_Screen.dart';

class AdminController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // RxList to store requests
  RxList<Map<String, dynamic>> pendingRequests = <Map<String, dynamic>>[].obs;

  // Loading state
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    bindRequestsStream();
  }

  // 1. LISTEN TO DATABASE
  void bindRequestsStream() {
    isLoading.value = true;

    _db.collection("requests")
        .where("status", isEqualTo: "pending")
        .orderBy("timestamp", descending: true)
        .snapshots()
        .listen((snapshot) {

      // Update the list with data from server
      pendingRequests.assignAll(
          snapshot.docs.map((doc) => doc.data()).toList()
      );

      isLoading.value = false;

    }, onError: (e) {
      print("Error fetching requests: $e");
      isLoading.value = false;
    });
  }

  // 2. APPROVE REQUEST (Bulletproof Instant Update)
  Future<void> approveRequest(String requestId) async {
    // --- STEP 1: FORCE UI UPDATE (OPTIMISTIC) ---
    // We create a temporary copy, remove the item, and assign it back.
    // This GUARANTEES the Obx sees the change.
    var tempList = List<Map<String, dynamic>>.from(pendingRequests);
    tempList.removeWhere((req) => req['requestId'] == requestId);
    pendingRequests.assignAll(tempList);

    try {
      // --- STEP 2: UPDATE SERVER ---
      await _db.collection("requests").doc(requestId).update({
        "status": "accepted"
      });
      Utils.toastMessegessuccess("Request Approved!");
    } catch (e) {
      Utils.toastMesseges("Error approving: $e");
    }
  }

  // 3. REJECT REQUEST (Bulletproof Instant Update)
  Future<void> rejectRequest(String requestId) async {
    // --- STEP 1: FORCE UI UPDATE ---
    var tempList = List<Map<String, dynamic>>.from(pendingRequests);
    tempList.removeWhere((req) => req['requestId'] == requestId);
    pendingRequests.assignAll(tempList);

    try {
      // --- STEP 2: UPDATE SERVER ---
      await _db.collection("requests").doc(requestId).delete();
      Utils.toastMessegessuccess("Request Rejected");
    } catch (e) {
      Utils.toastMesseges("Error rejecting: $e");
    }
  }

  // 4. LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
    Get.offAll(() => const SigninScreen());
  }
}