Map<String, String> airportCityCodeMap = {
  'Chhatrapati Shivaji Maharaj International': 'MUM', // Mumbai
  'Indira Gandhi International': 'DEL', // Delhi
  'Rajiv Gandhi International': 'HYD', // Hyderabad
  'Kempegowda International': 'BLR', // Bangalore
  'Netaji Subhas Chandra Bose International': 'CCU', // Kolkata
  'Sardar Vallabhbhai Patel International': 'AMD', // Ahmedabad

  // US Airports
  'John F. Kennedy International': 'JFK', // New York
  'Los Angeles International': 'LAX', // Los Angeles
  'San Francisco International': 'SFO', // San Francisco
  'O\'Hare International': 'ORD', // Chicago

  // Dubai
  'Dubai': 'DXB', // Dubai
};

String? getAirportCode(String airportName) {
  return airportCityCodeMap[airportName];
}
