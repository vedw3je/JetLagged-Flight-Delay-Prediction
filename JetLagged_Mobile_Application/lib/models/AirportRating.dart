Map<String, double> airportRatingMap = {
  // Indian Airports
  'DEL': 0.9, // Indira Gandhi International Airport (Delhi)
  'MUM': 0.85, // Chhatrapati Shivaji Maharaj International Airport (Mumbai)
  'HYD': 0.8, // Rajiv Gandhi International Airport (Hyderabad)
  'BLR': 0.88, // Kempegowda International Airport (Bangalore)
  'CCU': 0.75, // Netaji Subhas Chandra Bose International Airport (Kolkata)

  // International Airports (US & Dubai)
  'JFK': 0.82, // John F. Kennedy International Airport (New York)
  'LAX': 0.78, // Los Angeles International Airport
  'SFO': 0.81, // San Francisco International Airport
  'ORD': 0.76, // O'Hare International Airport (Chicago)
  'DXB': 0.92, // Dubai International Airport
};

double? getAirportRating(String airportCode) {
  return airportRatingMap[airportCode];
}
