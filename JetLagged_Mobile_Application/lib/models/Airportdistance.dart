Map<List<String>, int> airportDistanceMap = {
  // Domestic Distances (India)
  ['DEL', 'MUM']: 1150, // Delhi to Mumbai
  ['DEL', 'HYD']: 1250, // Delhi to Hyderabad
  ['DEL', 'BLR']: 1740, // Delhi to Bangalore
  ['DEL', 'CCU']: 1300, // Delhi to Kolkata
  ['MUM', 'HYD']: 620, // Mumbai to Hyderabad
  ['MUM', 'BLR']: 845, // Mumbai to Bangalore
  ['MUM', 'CCU']: 1660, // Mumbai to Kolkata
  ['HYD', 'BLR']: 510, // Hyderabad to Bangalore
  ['HYD', 'CCU']: 1170, // Hyderabad to Kolkata
  ['BLR', 'CCU']: 1550, // Bangalore to Kolkata

  // International Distances (India to US/Dubai)
  ['DEL', 'JFK']: 11750, // Delhi to New York (JFK)
  ['MUM', 'JFK']: 12540, // Mumbai to New York (JFK)
  ['BLR', 'JFK']: 13500, // Bangalore to New York (JFK)
  ['HYD', 'JFK']: 13340, // Hyderabad to New York (JFK)

  ['DEL', 'DXB']: 2200, // Delhi to Dubai
  ['MUM', 'DXB']: 1900, // Mumbai to Dubai
  ['BLR', 'DXB']: 2700, // Bangalore to Dubai
  ['HYD', 'DXB']: 2550, // Hyderabad to Dubai

  // Domestic Distances (US)
  ['JFK', 'LAX']: 3970, // New York (JFK) to Los Angeles (LAX)
  ['JFK', 'SFO']: 4140, // New York (JFK) to San Francisco (SFO)
  ['JFK', 'ORD']: 1180, // New York (JFK) to Chicago (ORD)
  ['LAX', 'SFO']: 550, // Los Angeles to San Francisco
  ['LAX', 'ORD']: 2800, // Los Angeles to Chicago
  ['SFO', 'ORD']: 2970, // San Francisco to Chicago
};

int? getDistanceBetweenAirports(String airport1, String airport2) {
  List<String> key1 = [airport1, airport2];
  List<String> key2 = [airport2, airport1]; // To handle both directions

  if (airportDistanceMap.containsKey(key1)) {
    return airportDistanceMap[key1];
  } else if (airportDistanceMap.containsKey(key2)) {
    return airportDistanceMap[key2];
  } else {
    return null; // Distance not found for this pair
  }
}
