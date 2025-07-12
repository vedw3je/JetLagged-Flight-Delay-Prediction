// airline_logos.dart

class AirlineLogos {
  static String getLogo(String airlineName) {
    // Mapping airline names to their respective logo assets
    switch (airlineName) {
      case 'Air Asia':
        return 'assets/logo/airasia.png';
      case 'Air India':
        return 'assets/logo/airindia.png';
      case 'Go Air':
        return 'assets/logo/goair.png';
      case 'Indigo':
        return 'assets/logo/indigo.png';
      case 'Vistara':
        return 'assets/logo/vistara.png';
      case 'Spicejet':
        return 'assets/logo/spicejet.png';
      default:
        return 'assets/logo/default.png'; // Default logo if airline is unknown
    }
  }
}
