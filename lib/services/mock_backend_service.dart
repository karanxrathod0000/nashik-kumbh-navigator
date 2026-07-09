import '../models/ghat_location.dart';
import '../models/alert_item.dart';
import '../models/family_member.dart';
import '../models/lost_person.dart';
import '../models/facility_item.dart';

class MockBackendService {
  MockBackendService._();

  static final MockBackendService instance = MockBackendService._();

  bool _isOfflineMode = false;
  bool get isOfflineMode => _isOfflineMode;

  void setOfflineMode(bool val) {
    _isOfflineMode = val;
  }

  // Initial Ghat Locations
  final List<GhatLocation> _locations = [
    const GhatLocation(
      id: 'ghat_ramkund',
      nameEn: 'Ramkund Holy Ghat (Main)',
      nameHi: 'रामकुंड पवित्र घाट (मुख्य)',
      nameMr: 'रामकुंड पवित्र घाट (मुख्य)',
      category: LocationCategory.ghat,
      latitude: 20.0059,
      longitude: 73.7900,
      currentDensity: CrowdDensity.heavy,
      descriptionEn: 'The most sacred bathing ghat where Lord Rama bathed during his exile in Panchavati. Highly crowded during Shahi Snan.',
      descriptionHi: 'सबसे पवित्र स्नान घाट जहां भगवान राम ने पंचवटी में अपने वनवास के दौरान स्नान किया था। शाही स्नान के दौरान अत्यधिक भीड़।',
      descriptionMr: 'सर्वांत पवित्र स्नान घाट जिथे प्रभू रामचंद्रांनी पंचवटीतील वनवासाच्या काळात स्नान केले होते. शाही स्नानावेळी प्रचंड गर्दी असते.',
      distanceMeters: 350,
      facilities: ['Changing Rooms', 'Life Guards', 'Police Booth', 'Medical Camp'],
    ),
    const GhatLocation(
      id: 'ghat_kushavarta',
      nameEn: 'Kushavarta Tirtha (Tryambakeshwer)',
      nameHi: 'कुशावर्त तीर्थ (त्र्यंबकेश्वर)',
      nameMr: 'कुशावर्त तीर्थ (त्र्यंबकेश्वर)',
      category: LocationCategory.ghat,
      latitude: 19.9320,
      longitude: 73.5310,
      currentDensity: CrowdDensity.moderate,
      descriptionEn: 'The origin of the sacred Godavari river and the primary ritual bathing site for Shaiva Akharas.',
      descriptionHi: 'पवित्र गोदावरी नदी का उद्गम स्थल और शैव अखाड़ों के लिए मुख्य अनुष्ठान स्नान स्थल।',
      descriptionMr: 'पवित्र गोदावरी नदीचे उगमस्थान आणि शैव आखाड्यांसाठी प्रमुख शाही स्नान स्थळ.',
      distanceMeters: 1200,
      facilities: ['Cloak Room', 'Drinking Water', 'Restrooms', 'Volunteers'],
    ),
    const GhatLocation(
      id: 'ghat_someshwar',
      nameEn: 'Someshwar Ghat & Temple',
      nameHi: 'सोमेश्वर घाट और मंदिर',
      nameMr: 'सोमेश्वर घाट आणि मंदिर',
      category: LocationCategory.ghat,
      latitude: 20.0240,
      longitude: 73.7550,
      currentDensity: CrowdDensity.light,
      descriptionEn: 'Serene ghat located on the banks of Godavari with lush greenery and an ancient Lord Shiva temple. Ideal for peace.',
      descriptionHi: 'हरियाली और भगवान शिव के प्राचीन मंदिर के साथ गोदावरी के तट पर स्थित शांत घाट। शांति के लिए आदर्श।',
      descriptionMr: 'हिरवळ आणि भगवान शिवाच्या प्राचीन मंदिरासह गोदावरीच्या काठावर असलेला शांत व निसर्गसुंदर घाट.',
      distanceMeters: 2500,
      facilities: ['Free Parking', 'Swachh Toilets', 'Food Stalls'],
    ),
    const GhatLocation(
      id: 'park_tapo_1',
      nameEn: 'Tapovan Grand Parking Zone A',
      nameHi: 'तपोवन विशाल पार्किंग क्षेत्र A',
      nameMr: 'तपोवन महा-पार्किंग झोन A',
      category: LocationCategory.parking,
      latitude: 19.9980,
      longitude: 73.8050,
      currentDensity: CrowdDensity.moderate,
      descriptionEn: 'Primary parking ground for private vehicles and tourist buses coming from Mumbai & Pune highway.',
      descriptionHi: 'मुंबई और पुणे राजमार्ग से आने वाले निजी वाहनों और पर्यटक बसों के लिए मुख्य पार्किंग मैदान।',
      descriptionMr: 'मुंबई आणि पुणे महामार्गावरून येणाऱ्या खाजगी वाहनांसाठी आणि पर्यटक बससाठी मुख्य वाहनतळ.',
      distanceMeters: 800,
      facilities: ['Shuttle Bus', 'Security CCTV', 'EV Charging'],
    ),
    const GhatLocation(
      id: 'med_base_1',
      nameEn: 'Kumbh Main Emergency Medical Camp',
      nameHi: 'कुंभ मुख्य आपातकालीन चिकित्सा शिविर',
      nameMr: 'कुंभ मुख्य तातडीचे वैद्यकीय केंद्र',
      category: LocationCategory.medical,
      latitude: 20.0030,
      longitude: 73.7920,
      currentDensity: CrowdDensity.light,
      descriptionEn: '24/7 Red Cross & AIIMS volunteer hospital tent equipped with ICU ambulances, heatstroke beds, and pharmacy.',
      descriptionHi: 'ICU एम्बुलेंस, हीटस्ट्रोक बेड और फार्मेसी से सुसज्जित 24/7 रेड क्रॉस और एम्स स्वयंसेवक अस्पताल।',
      descriptionMr: 'आयसीयू रुग्णवाहिका, उष्माघात वॉर्ड आणि औषधालयाने सज्ज असलेले २४/७ रेड क्रॉस आणि एम्स स्वयंसेवकांचे रुग्णालय.',
      distanceMeters: 450,
      facilities: ['24/7 Doctors', 'Free Pharmacy', 'Ambulance 108'],
    ),
    const GhatLocation(
      id: 'police_hq',
      nameEn: 'Panchavati Police Control & Helpdesk',
      nameHi: 'पंचवटी पुलिस नियंत्रण व सहायता केंद्र',
      nameMr: 'पंचवटी पोलीस नियंत्रण आणि मदत कक्ष',
      category: LocationCategory.police,
      latitude: 20.0065,
      longitude: 73.7885,
      currentDensity: CrowdDensity.light,
      descriptionEn: 'Central drone monitoring booth and lost child reunification desk operated by Maharashtra Police.',
      descriptionHi: 'महाराष्ट्र पुलिस द्वारा संचालित केंद्रीय ड्रोन निगरानी बूथ और खोए हुए बच्चों का पुनर्मिलन डेस्क।',
      descriptionMr: 'महाराष्ट्र पोलिसांद्वारे संचालित केंद्रीय ड्रोन देखरेख कक्ष आणि हरवलेल्या मुलांचे पुनर्मिलन केंद्र.',
      distanceMeters: 300,
      facilities: ['Lost & Found', 'CCTV Control', 'Women Helpdesk'],
    ),
  ];

  // Initial Alerts
  final List<AlertItem> _alerts = [
    AlertItem(
      id: 'alert_1',
      authorityName: 'Nashik Municipal Corporation (NMC)',
      isVerified: true,
      severity: AlertSeverity.heavy,
      category: AlertCategory.route,
      titleEn: 'Route 4 Closed near Ramkund for Royal Bath Procession',
      titleHi: 'शाही स्नान जुलूस के लिए रामकुंड के पास मार्ग 4 बंद',
      titleMr: 'शाही स्नानाच्या मिरवणुकीसाठी रामकुंड जवळ मार्ग ४ बंद करण्यात आला आहे',
      descriptionEn: 'Due to the Sadhus\' royal procession, Route 4 from Panchavati circle is closed until 2:00 PM. Pilgrims are advised to use alternate pedestrian route via Tapovan bridge.',
      descriptionHi: 'साधुओं के शाही जुलूस के कारण, पंचवटी सर्कल से मार्ग 4 दोपहर 2:00 बजे तक बंद है। तीर्थयात्रियों को तपोवन पुल के रास्ते वैकल्पिक पैदल मार्ग का उपयोग करने की सलाह दी जाती है।',
      descriptionMr: 'साधूंच्या शाही मिरवणुकीमुळे पंचवटी सर्कलपासून मार्ग ४ दुपारी २:०० वाजेपर्यंत बंद आहे. भाविकांनी तपोवन पुलावरून पर्यायी पायी मार्गाचा वापर करावा.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 18)),
      viewCount: 3420,
      likeCount: 210,
      shareCount: 95,
    ),
    AlertItem(
      id: 'alert_2',
      authorityName: 'Kumbh Mela Police Control Room',
      isVerified: true,
      severity: AlertSeverity.moderate,
      category: AlertCategory.crowd,
      titleEn: 'Moderate Crowd Surge at Kushavarta Entry Gate 2',
      titleHi: 'कुशावर्त प्रवेश द्वार 2 पर मध्यम भीड़ बढ़ रही है',
      titleMr: 'कुशावर्त प्रवेशद्वार २ वर मध्यम प्रमाणात गर्दी वाढली आहे',
      descriptionEn: 'Waiting time at Gate 2 is currently approx 45 mins. Pilgrims with elderly family members are advised to rest at shaded canopy areas.',
      descriptionHi: 'गेट 2 पर प्रतीक्षा समय वर्तमान में लगभग 45 मिनट है। बुजुर्ग परिवार के सदस्यों वाले तीर्थयात्रियों को छायादार क्षेत्रों में आराम करने की सलाह दी जाती है।',
      descriptionMr: 'गेट २ वर सध्या साधारण ४५ मिनिटे प्रतीक्षा वेळ आहे. वृद्ध नागरिक असलेल्या भाविकांनी सावलीच्या मंडपात विश्रांती घ्यावी.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 55)),
      viewCount: 1890,
      likeCount: 120,
      shareCount: 42,
    ),
    AlertItem(
      id: 'alert_3',
      authorityName: 'IMD Weather Advisory & Health Unit',
      isVerified: true,
      severity: AlertSeverity.light,
      category: AlertCategory.weather,
      titleEn: 'Pleasant Weather at Ghats — Drink Sufficient Water',
      titleHi: 'घाटों पर सुहावना मौसम — पर्याप्त जल ग्रहण करें',
      titleMr: 'घाटांवर आल्हाददायक हवामान — पुरेसे पाणी प्यावे',
      descriptionEn: 'Temperature is 26°C with light breeze. Hydration stations (Jal Sewa) are fully stocked across all 12 zones.',
      descriptionHi: 'हल्की हवा के साथ तापमान 26°C है। सभी 12 क्षेत्रों में जल सेवा केंद्र पूर्णतः चालू हैं।',
      descriptionMr: 'हलक्या वाऱ्यासह तापमान २६°से आहे. सर्व १२ झोनमधील जल सेवा केंद्रांवर पिण्याचे पाणी मुबलक प्रमाणात उपलब्ध आहे.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      viewCount: 980,
      likeCount: 64,
      shareCount: 15,
    ),
  ];

  // Initial Family Members
  final List<FamilyMember> _familyMembers = [
    FamilyMember(
      id: 'fam_1',
      name: 'Ramesh Kulkarni (Father)',
      relation: 'Guardian',
      phoneNumber: '+91 98230 12345',
      latitude: 20.0055,
      longitude: 73.7895,
      batteryLevel: 84,
      isOnline: true,
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 2)),
      qrCodeData: 'KUMBH_ID_98230_RAMESH',
    ),
    FamilyMember(
      id: 'fam_2',
      name: 'Sunita Kulkarni (Mother)',
      relation: 'Elderly Visitor',
      phoneNumber: '+91 98230 54321',
      latitude: 20.0052,
      longitude: 73.7898,
      batteryLevel: 62,
      isOnline: true,
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 4)),
      qrCodeData: 'KUMBH_ID_98230_SUNITA',
    ),
    FamilyMember(
      id: 'fam_3',
      name: 'Aarav (Son)',
      relation: 'Child',
      phoneNumber: '+91 98230 11111',
      latitude: 20.0048,
      longitude: 73.7905,
      batteryLevel: 91,
      isOnline: true,
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 1)),
      qrCodeData: 'KUMBH_ID_98230_AARAV',
    ),
  ];

  // Initial Lost & Found
  final List<LostPersonItem> _lostFound = [
    LostPersonItem(
      id: 'lf_1',
      type: ReportType.lostPerson,
      titleEn: 'Missing Boy (Age 7) wearing yellow kurta',
      titleHi: 'पीला कुर्ता पहने 7 वर्षीय बच्चा लापता',
      titleMr: 'पिवळा कुर्ता घातलेला ७ वर्षांचा मुलगा बेपत्ता',
      description: 'Name: Rohan. Speaks Marathi & Hindi. Last seen near Ramkund Clock Tower around 11:30 AM.',
      contactName: 'Sanjay Shinde (Father)',
      contactPhone: '+91 94222 88888',
      lastSeenLocation: 'Ramkund Main Steps',
      timestamp: DateTime.now().subtract(const Duration(minutes: 40)),
      isResolved: false,
    ),
    LostPersonItem(
      id: 'lf_2',
      type: ReportType.foundItem,
      titleEn: 'Found Brown Leather Bag with Medicines & Glasses',
      titleHi: 'दवाइयों और चश्मे से भरा भूरा चमड़े का बैग मिला',
      titleMr: 'औषधे आणि चष्मा असलेली तपकिरी रंगाची चामडी पिशवी सापडली',
      description: 'Found sitting near Someshwar temple bench. Deposited at Police Helpdesk Booth 4.',
      contactName: 'Constable Patil (Helpdesk 4)',
      contactPhone: '1070',
      lastSeenLocation: 'Someshwar Ghat Bench',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      isResolved: false,
    ),
  ];

  // Initial Facilities
  final List<FacilityItem> _facilities = [
    const FacilityItem(
      id: 'fac_1',
      type: FacilityType.water,
      nameEn: 'Jal Sewa Drinking Water Booth 12',
      nameHi: 'जल सेवा पेयजल केंद्र 12',
      nameMr: 'जल सेवा पिण्याच्या पाण्याचे केंद्र १२',
      locationName: 'Near Panchavati Bus Stop',
      distanceMeters: 120,
      additionalInfo: '24/7 Filtered RO Water & Disposable Paper Cups',
    ),
    const FacilityItem(
      id: 'fac_2',
      type: FacilityType.toilet,
      nameEn: 'Swachh Bharat Mobile Toilets Zone B',
      nameHi: 'स्वच्छ भारत मोबाइल शौचालय क्षेत्र B',
      nameMr: 'स्वच्छ भारत फिरती स्वच्छतागृहे झोन B',
      locationName: 'Opposite Tapovan Gate 3',
      distanceMeters: 280,
      additionalInfo: 'Separate for Ladies, Gents & Divyangjan (Accessible)',
    ),
    const FacilityItem(
      id: 'fac_3',
      type: FacilityType.charging,
      nameEn: 'Solar Mobile Charging Hub',
      nameHi: 'सौर मोबाइल चार्जिंग हब',
      nameMr: 'सौर ऊर्जा मोबाईल चार्जिंग केंद्र',
      locationName: 'Ramkund Main Square',
      distanceMeters: 340,
      additionalInfo: 'Free Type-C and Lightning cables available',
    ),
  ];

  List<GhatLocation> getLocations({LocationCategory? category}) {
    if (category == null) return _locations;
    return _locations.where((l) => l.category == category).toList();
  }

  List<AlertItem> getAlerts({AlertSeverity? severity}) {
    if (severity == null) return _alerts;
    return _alerts.where((a) => a.severity == severity).toList();
  }

  List<FamilyMember> getFamilyMembers() => _familyMembers;

  List<LostPersonItem> getLostFound() => _lostFound;

  List<FacilityItem> getFacilities({FacilityType? type}) {
    if (type == null) return _facilities;
    return _facilities.where((f) => f.type == type).toList();
  }

  void addLostFoundItem(LostPersonItem item) {
    _lostFound.insert(0, item);
  }

  void triggerEmergencySOS({required double lat, required double lng}) {
    // Simulate broadcasting emergency SOS
    _alerts.insert(0, AlertItem(
      id: 'sos_${DateTime.now().millisecondsSinceEpoch}',
      authorityName: 'EMERGENCY SOS ALERT SYSTEM',
      isVerified: true,
      severity: AlertSeverity.heavy,
      category: AlertCategory.emergency,
      titleEn: 'EMERGENCY SOS Triggered by Pilgrim near Ramkund',
      titleHi: 'रामकुंड के पास तीर्थयात्री द्वारा आपातकालीन SOS सक्रिय किया गया',
      titleMr: 'रामकुंड जवळ भाविकाकडून तातडीची मदत (SOS) सक्रिय करण्यात आली आहे',
      descriptionEn: 'Live location broadcast to police control & nearest ambulance. Volunteer rescue team dispatched.',
      descriptionHi: 'पुलिस नियंत्रण और निकटतम एम्बुलेंस को लाइव स्थान भेजा गया। स्वयंसेवक बचाव दल भेजा गया।',
      descriptionMr: 'पोलीस नियंत्रण आणि जवळच्या रुग्णवाहिकेला थेट लोकेशन पाठवले. स्वयंसेवक बचाव पथक रवाना झाले आहे.',
      timestamp: DateTime.now(),
    ));
  }
}
