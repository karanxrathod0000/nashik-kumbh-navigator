import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/alert_item.dart';

class FirestoreService {
  FirestoreService._();

  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Local in-memory caches for fallback mode when offline / uninitialized
  final List<String> _localSavedPlaces = ['ghat_ramkund', 'ghat_kushavarta'];
  final List<Map<String, String>> _localContacts = [
    {'id': 'c1', 'name': 'Rajesh Sharma (Brother)', 'phone': '+91 98230 11223', 'relation': 'Brother'},
    {'id': 'c2', 'name': 'Sunita Sharma (Spouse)', 'phone': '+91 98230 44556', 'relation': 'Spouse'},
  ];

  // User Profile
  Future<void> createUserProfileIfNeeded({
    required String uid,
    required String name,
    required String? phone,
    required String? email,
    required String authProvider,
    required bool isGuest,
  }) async {
    try {
      final docRef = _db.collection('users').doc(uid);
      final snapshot = await docRef.get();
      if (!snapshot.exists) {
        await docRef.set({
          'uid': uid,
          'name': name,
          'phone': phone ?? '',
          'email': email ?? '',
          'authProvider': authProvider,
          'isGuest': isGuest,
          'createdAt': FieldValue.serverTimestamp(),
          'language': 'en',
        });
        debugPrint('✅ [FirestoreService] Created new user profile for $uid');
      }
    } catch (e) {
      debugPrint('⚠️ [FirestoreService] Could not create user profile (using offline mode): $e');
    }
  }

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      return doc.data();
    } catch (e) {
      debugPrint('⚠️ [FirestoreService] Error fetching user profile: $e');
      return null;
    }
  }

  // Saved Places Subcollection
  Stream<List<String>> savedPlacesStream(String uid) {
    if (uid.isEmpty || uid == 'guest') {
      return Stream.value(_localSavedPlaces);
    }
    return _db
        .collection('users')
        .doc(uid)
        .collection('savedPlaces')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList())
        .handleError((e) {
      debugPrint('⚠️ [FirestoreService] Error streaming saved places: $e');
      return _localSavedPlaces;
    });
  }

  Future<bool> toggleSavedPlace(String uid, String placeId, String placeName) async {
    if (uid.isEmpty || uid == 'guest') {
      if (_localSavedPlaces.contains(placeId)) {
        _localSavedPlaces.remove(placeId);
        return false;
      } else {
        _localSavedPlaces.add(placeId);
        return true;
      }
    }

    try {
      final docRef = _db.collection('users').doc(uid).collection('savedPlaces').doc(placeId);
      final doc = await docRef.get();
      if (doc.exists) {
        await docRef.delete();
        return false;
      } else {
        await docRef.set({
          'placeId': placeId,
          'placeName': placeName,
          'addedAt': FieldValue.serverTimestamp(),
        });
        return true;
      }
    } catch (e) {
      debugPrint('⚠️ [FirestoreService] Error toggling saved place: $e');
      if (_localSavedPlaces.contains(placeId)) {
        _localSavedPlaces.remove(placeId);
        return false;
      } else {
        _localSavedPlaces.add(placeId);
        return true;
      }
    }
  }

  // Emergency Contacts Subcollection
  Stream<List<Map<String, String>>> emergencyContactsStream(String uid) {
    if (uid.isEmpty || uid == 'guest') {
      return Stream.value(_localContacts);
    }
    return _db
        .collection('users')
        .doc(uid)
        .collection('emergencyContacts')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return {
                'id': doc.id,
                'name': data['name']?.toString() ?? '',
                'phone': data['phone']?.toString() ?? '',
                'relation': data['relation']?.toString() ?? '',
              };
            }).toList())
        .handleError((e) {
      debugPrint('⚠️ [FirestoreService] Error streaming emergency contacts: $e');
      return _localContacts;
    });
  }

  Future<void> addEmergencyContact(String uid, String name, String phone, String relation) async {
    if (uid.isEmpty || uid == 'guest') {
      _localContacts.add({
        'id': 'c_${DateTime.now().millisecondsSinceEpoch}',
        'name': name,
        'phone': phone,
        'relation': relation,
      });
      return;
    }
    try {
      await _db.collection('users').doc(uid).collection('emergencyContacts').add({
        'name': name,
        'phone': phone,
        'relation': relation,
        'addedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('⚠️ [FirestoreService] Error adding emergency contact: $e');
      _localContacts.add({
        'id': 'c_${DateTime.now().millisecondsSinceEpoch}',
        'name': name,
        'phone': phone,
        'relation': relation,
      });
    }
  }

  Future<void> deleteEmergencyContact(String uid, String contactId) async {
    if (uid.isEmpty || uid == 'guest') {
      _localContacts.removeWhere((c) => c['id'] == contactId);
      return;
    }
    try {
      await _db.collection('users').doc(uid).collection('emergencyContacts').doc(contactId).delete();
    } catch (e) {
      debugPrint('⚠️ [FirestoreService] Error deleting contact: $e');
      _localContacts.removeWhere((c) => c['id'] == contactId);
    }
  }

  // Alerts Stream & Seeding
  Stream<List<AlertItem>> alertsStream() {
    return _db
        .collection('alerts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final d = doc.data();
              return AlertItem(
                id: doc.id,
                authorityName: d['source'] ?? 'Police HQ',
                category: _parseCategory(d['category']?.toString() ?? 'emergency'),
                titleEn: d['titleEn'] ?? 'Control Room Announcement',
                titleHi: d['titleHi'] ?? 'नियंत्रण कक्ष घोषणा',
                titleMr: d['titleMr'] ?? 'नियंत्रण कक्ष घोषणा',
                descriptionEn: d['descriptionEn'] ?? '',
                descriptionHi: d['descriptionHi'] ?? '',
                descriptionMr: d['descriptionMr'] ?? '',
                severity: _parseSeverity(d['severity']?.toString() ?? 'advisory'),
                timestamp: (d['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
              );
            }).toList())
        .handleError((e) {
      debugPrint('⚠️ [FirestoreService] Alerts stream error: $e');
      return <AlertItem>[];
    });
  }

  AlertSeverity _parseSeverity(String s) {
    if (s.toLowerCase() == 'heavy' || s.toLowerCase() == 'critical') return AlertSeverity.heavy;
    if (s.toLowerCase() == 'moderate' || s.toLowerCase() == 'warning') return AlertSeverity.moderate;
    return AlertSeverity.light;
  }

  AlertCategory _parseCategory(String s) {
    if (s.toLowerCase() == 'crowd') return AlertCategory.crowd;
    if (s.toLowerCase() == 'route') return AlertCategory.route;
    if (s.toLowerCase() == 'weather') return AlertCategory.weather;
    if (s.toLowerCase() == 'missing') return AlertCategory.missing;
    return AlertCategory.emergency;
  }

  // Seeding initial alerts to Firestore if collection is empty
  Future<void> seedInitialAlertsIfEmpty() async {
    try {
      final snap = await _db.collection('alerts').limit(1).get();
      if (snap.docs.isEmpty) {
        debugPrint('🌱 [FirestoreService] Seeding initial alerts into Firestore...');
        await _db.collection('alerts').add({
          'titleEn': 'Gate 2 Temporarily Closed for Shahi Snan Procession',
          'titleHi': 'शाही स्नान जुलूस के लिए गेट 2 अस्थायी रूप से बंद',
          'titleMr': 'शाही स्नानाच्या मिरवणुकीसाठी गेट २ तात्पुरते बंद',
          'descriptionEn': 'Please use Gate 4 or Panchavati East entrance. Crowd density is extremely high at Ramkund.',
          'descriptionHi': 'कृपया गेट 4 या पंचवटी पूर्व प्रवेश द्वार का उपयोग करें। रामकुंड में अत्यधिक भीड़ है।',
          'descriptionMr': 'कृपया गेट ४ किंवा पंचवटी पूर्व प्रवेशद्वाराचा वापर करा. रामकुंड येथे प्रचंड गर्दी आहे.',
          'severity': 'warning',
          'timestamp': FieldValue.serverTimestamp(),
          'zone': 'Sector 1 (Ramkund)',
          'source': 'Nashik Police Control Room',
        });
      }
    } catch (e) {
      debugPrint('⚠️ [FirestoreService] Could not seed alerts (offline): $e');
    }
  }

  // Send SOS Alert to Firestore
  Future<void> sendSosAlert({
    required String uid,
    required String userName,
    required String phone,
    required double latitude,
    required double longitude,
    required String address,
  }) async {
    try {
      await _db.collection('sos_incidents').add({
        'uid': uid,
        'userName': userName,
        'phone': phone,
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'ACTIVE',
      });
      debugPrint('🚨 [FirestoreService] SOS Alert dispatched successfully to Firestore!');
    } catch (e) {
      debugPrint('⚠️ [FirestoreService] Error sending SOS to Firestore (offline fallback active): $e');
    }
  }

  // Update "I'm Safe" check-in
  Future<void> submitSafeCheckin(String uid, String userName, String locationName) async {
    try {
      await _db.collection('safe_checkins').doc(uid).set({
        'uid': uid,
        'userName': userName,
        'locationName': locationName,
        'checkedInAt': FieldValue.serverTimestamp(),
        'status': 'SAFE',
      });
      debugPrint('✅ [FirestoreService] Safe check-in submitted to Firestore!');
    } catch (e) {
      debugPrint('⚠️ [FirestoreService] Safe check-in error: $e');
    }
  }
}
