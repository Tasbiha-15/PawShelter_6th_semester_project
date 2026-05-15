import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../Utiles/utiles.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get currentUserId => _auth.currentUser?.uid ?? '';
  String get currentUserEmail => _auth.currentUser?.email ?? '';

  // --- 1. USER INFO ---
  Future<String> getUserName() async {
    if (currentUserId.isEmpty) return "Guest";
    try {
      DocumentSnapshot doc = await _db.collection("users").doc(currentUserId).get();
      if (doc.exists && doc.data() != null) {
        return doc.get('name') ?? "Pet Lover";
      }
      return "Pet Lover";
    } catch (e) {
      return "Pet Lover";
    }
  }

  Future<void> saveUser(String uid, String email, String name) async {
    await _db.collection("users").doc(uid).set({
      "uid": uid,
      "email": email,
      "name": name,
      "createdAt": DateTime.now().toIso8601String(),
    });
  }

  // --- 2. FAVORITES LOGIC ---
  Future<void> savePetToFavorites({
    required String petId,
    required String name,
    required String imageUrl,
    required String origin,
    required bool isCat,
  }) async {
    try {
      if (currentUserId.isEmpty) return;
      await _db.collection("users").doc(currentUserId).collection("favorites").doc(petId).set({
        "petId": petId,
        "name": name,
        "image": imageUrl,
        "origin": origin,
        "isCat": isCat,
        "savedAt": DateTime.now().toIso8601String(),
      });
      Utils.toastMessegessuccess("Added to Favorites!");
    } catch (e) {
      Utils.toastMesseges("Error saving: $e");
    }
  }

  Stream<List<Map<String, dynamic>>> getFavoritePetsStream() {
    if (currentUserId.isEmpty) return const Stream.empty();
    return _db.collection("users").doc(currentUserId).collection("favorites")
        .orderBy("savedAt", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> deleteFavoritePet(String petId) async {
    try {
      if (currentUserId.isEmpty) return;
      await _db.collection("users").doc(currentUserId).collection("favorites").doc(petId).delete();
      Utils.toastMessegessuccess("Removed from Favorites");
    } catch (e) {
      Utils.toastMesseges("Error deleting: $e");
    }
  }

  // --- 3. REQUESTS LOGIC (UPDATED) ---
  Future<void> requestAdoption({
    required String petId,
    required String name,
    required String imageUrl,
    required String origin,
    required bool isCat,
  }) async {
    try {
      if (currentUserId.isEmpty) return;
      final requestRef = _db.collection("requests").doc();
      await requestRef.set({
        "requestId": requestRef.id,
        "uid": currentUserId,
        "userEmail": currentUserEmail,
        "petId": petId,
        "petName": name,
        "petImage": imageUrl,
        "petOrigin": origin,
        "isCat": isCat,
        "status": "pending",
        "timestamp": FieldValue.serverTimestamp(),
      });
      Utils.toastMessegessuccess("Request Sent to Shelter!");
    } catch (e) {
      Utils.toastMesseges("Error requesting: $e");
    }
  }

  // Stream for Specific User's Requests
  Stream<List<Map<String, dynamic>>> getUserRequestsStream() {
    if (currentUserId.isEmpty) return const Stream.empty();
    return _db.collection("requests")
        .where("uid", isEqualTo: currentUserId) // Filter by MY User ID
        .orderBy("timestamp", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> deleteRequest(String requestId) async {
    try {
      await _db.collection("requests").doc(requestId).delete();
      Utils.toastMessegessuccess("Request Cancelled");
    } catch (e) {
      Utils.toastMesseges("Error cancelling: $e");
    }
  }
}