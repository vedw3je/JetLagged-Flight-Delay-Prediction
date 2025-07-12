// models.dart

class FlightResponse {
  final List<FlightData> data;

  FlightResponse({required this.data});

  factory FlightResponse.fromJson(Map<String, dynamic> json) {
    return FlightResponse(
      data: (json['data'] as List)
          .map((item) => FlightData.fromJson(item))
          .toList(),
    );
  }
}

class FlightData {
  final String flightDate;
  final String flightStatus;
  final Departure departure;
  final Arrival arrival;
  final Airline airline;
  final Flight flight;
  final Aircraft aircraft;
  final Live? live;

  FlightData({
    required this.flightDate,
    required this.flightStatus,
    required this.departure,
    required this.arrival,
    required this.airline,
    required this.flight,
    required this.aircraft,
    this.live,
  });

  factory FlightData.fromJson(Map<String, dynamic> json) {
    return FlightData(
      flightDate: json['flight_date'],
      flightStatus: json['flight_status'],
      departure: Departure.fromJson(json['departure']),
      arrival: Arrival.fromJson(json['arrival']),
      airline: Airline.fromJson(json['airline']),
      flight: Flight.fromJson(json['flight']),
      aircraft: Aircraft.fromJson(json['aircraft']),
      live: json['live'] != null ? Live.fromJson(json['live']) : null,
    );
  }
}

class Departure {
  final String airport;
  final String timezone;
  final String iata;
  final String icao;
  final String terminal;
  final String? gate;
  final int delay;
  final String scheduled;
  final String estimated;
  final String? actual;
  final String? estimatedRunway;
  final String? actualRunway;

  Departure({
    required this.airport,
    required this.timezone,
    required this.iata,
    required this.icao,
    required this.terminal,
    this.gate,
    required this.delay,
    required this.scheduled,
    required this.estimated,
    this.actual,
    this.estimatedRunway,
    this.actualRunway,
  });

  factory Departure.fromJson(Map<String, dynamic> json) {
    return Departure(
      airport: json['airport'],
      timezone: json['timezone'],
      iata: json['iata'],
      icao: json['icao'],
      terminal: json['terminal'],
      gate: json['gate'],
      delay: json['delay'],
      scheduled: json['scheduled'],
      estimated: json['estimated'],
      actual: json['actual'],
      estimatedRunway: json['estimated_runway'],
      actualRunway: json['actual_runway'],
    );
  }
}

class Arrival {
  final String airport;
  final String timezone;
  final String iata;
  final String icao;
  final String terminal;
  final String? gate;
  final String? baggage;
  final int? delay;
  final String scheduled;
  final String estimated;
  final String? actual;
  final String? estimatedRunway;
  final String? actualRunway;

  Arrival({
    required this.airport,
    required this.timezone,
    required this.iata,
    required this.icao,
    required this.terminal,
    this.gate,
    this.baggage,
    this.delay,
    required this.scheduled,
    required this.estimated,
    this.actual,
    this.estimatedRunway,
    this.actualRunway,
  });

  factory Arrival.fromJson(Map<String, dynamic> json) {
    return Arrival(
      airport: json['airport'],
      timezone: json['timezone'],
      iata: json['iata'],
      icao: json['icao'],
      terminal: json['terminal'],
      gate: json['gate'],
      baggage: json['baggage'],
      delay: json['delay'],
      scheduled: json['scheduled'],
      estimated: json['estimated'],
      actual: json['actual'],
      estimatedRunway: json['estimated_runway'],
      actualRunway: json['actual_runway'],
    );
  }
}

class Airline {
  final String name;
  final String iata;
  final String icao;

  Airline({required this.name, required this.iata, required this.icao});

  factory Airline.fromJson(Map<String, dynamic> json) {
    return Airline(
      name: json['name'],
      iata: json['iata'],
      icao: json['icao'],
    );
  }
}

class Flight {
  final String number;
  final String iata;
  final String icao;
  final String? codeshared;

  Flight(
      {required this.number,
      required this.iata,
      required this.icao,
      this.codeshared});

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      number: json['number'],
      iata: json['iata'],
      icao: json['icao'],
      codeshared: json['codeshared'],
    );
  }
}

class Aircraft {
  final String registration;
  final String iata;
  final String icao;
  final String icao24;

  Aircraft(
      {required this.registration,
      required this.iata,
      required this.icao,
      required this.icao24});

  factory Aircraft.fromJson(Map<String, dynamic> json) {
    return Aircraft(
      registration: json['registration'],
      iata: json['iata'],
      icao: json['icao'],
      icao24: json['icao24'],
    );
  }
}

class Live {
  final String updated;
  final double latitude;
  final double longitude;
  final double altitude;
  final int direction;
  final double speedHorizontal;
  final double speedVertical;
  final bool isGround;

  Live({
    required this.updated,
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.direction,
    required this.speedHorizontal,
    required this.speedVertical,
    required this.isGround,
  });

  factory Live.fromJson(Map<String, dynamic> json) {
    return Live(
      updated: json['updated'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      altitude: json['altitude'],
      direction: json['direction'],
      speedHorizontal: json['speed_horizontal'],
      speedVertical: json['speed_vertical'],
      isGround: json['is_ground'],
    );
  }
}
