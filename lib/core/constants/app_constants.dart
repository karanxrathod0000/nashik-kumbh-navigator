class AppConstants {
  AppConstants._();

  static const String appName = "Nashik Kumbh Navigator";
  static const String tagline = "Your Safe Path to the Sacred Ghats";

  // Auspicious Shahi Snan Bathing Dates for Nashik Kumbh Mela
  static final List<Map<String, dynamic>> shahiSnanDates = [
    {
      'title': 'First Shahi Snan (Ramkund & Kushavarta)',
      'date': DateTime(2027, 8, 17),
      'significance': 'Simhastha Kumbh Mela Opening Royal Bath on Shravan Amavasya.',
      'expectedCrowd': 'Heavy (3.5M+ Pilgrims)',
    },
    {
      'title': 'Second Shahi Snan (Pramukh Snan)',
      'date': DateTime(2027, 8, 31),
      'significance': 'Bhādrapada Shukla Prathama - Auspicious planetary conjunction in Leo.',
      'expectedCrowd': 'Extreme (5.0M+ Pilgrims)',
    },
    {
      'title': 'Third Shahi Snan (Final Shahi Snan)',
      'date': DateTime(2027, 9, 12),
      'significance': 'Rishi Panchami / Anant Chaturdashi closing holy dip.',
      'expectedCrowd': 'Heavy (4.0M+ Pilgrims)',
    },
  ];

  // Emergency contact numbers
  static const Map<String, String> emergencyNumbers = {
    'Police': '100',
    'Ambulance': '108',
    'Fire Brigade': '101',
    'Kumbh Mela Helpline': '1070',
    'Women\'s Helpline': '1091',
    'Disaster Management': '108',
  };
}
