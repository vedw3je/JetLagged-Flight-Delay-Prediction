Map<String, double> airlineRatingMap = {
  'Air India': 0.75,
  'IndiGo': 0.85,
  'SpiceJet': 0.7,
  'GoAir': 0.68,
  'Vistara': 0.88,
  'AirAsia India': 0.72,
  'Emirates': 0.92,
  'Singapore Airlines': 0.95,
  'Qatar Airways': 0.93,
  'Etihad Airways': 0.9,
  'British Airways': 0.87,
  'Delta Airlines': 0.8,
  'American Airlines': 0.78,
  'United Airlines': 0.77,
};

double? getAirlineRating(String airlineName) {
  return airlineRatingMap[airlineName];
}
