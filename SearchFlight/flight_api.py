from flask import Flask, request, jsonify
import pandas as pd
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # Enable CORS to allow requests from your Flutter app


# Load datasets once when the server starts to improve performance
def load_datasets():
    try:
        flight_delay_data = pd.read_csv('Dataset.csv')
        flight_price_data = pd.read_csv('goibibo_flights_data.csv')

        # Rename columns to match
        flight_delay_data = flight_delay_data.rename(columns={
            'From': 'from',
            'To': 'to',
            'Airline': 'airline'
        })

        # Convert dates
        flight_delay_data['Used Date'] = pd.to_datetime(flight_delay_data['Used Date'], errors='coerce')
        flight_price_data['flight date'] = pd.to_datetime(flight_price_data['flight date'], errors='coerce')

        # Add DayOfWeek and Month
        flight_delay_data['DayOfWeek'] = flight_delay_data['Used Date'].dt.dayofweek
        flight_price_data['DayOfWeek'] = flight_price_data['flight date'].dt.dayofweek

        flight_delay_data['Month'] = flight_delay_data['Used Date'].dt.month
        flight_price_data['Month'] = flight_price_data['flight date'].dt.month

        # Merge price
        flight_delay_data['price'] = flight_price_data['price'].iloc[:len(flight_delay_data)].values
        flight_delay_data['price'] = flight_delay_data['price'].str.replace(',', '').astype(float)

        # Calculate total delay
        flight_delay_data['Total Delay'] = flight_delay_data['Departure Delay'] + flight_delay_data['Arrival Delay']

        return flight_delay_data
    except Exception as e:
        print(f"Error loading datasets: {e}")
        return None


flight_data = load_datasets()


@app.route('/api/flights', methods=['GET'])
def get_flights():
    try:
        # Get parameters from request
        from_airport = request.args.get('from')
        to_airport = request.args.get('to')
        date_str = request.args.get('date')  # Expected format: DD-MM-YYYY

        if not from_airport or not to_airport or not date_str:
            return jsonify({
                'success': False,
                'error': 'Missing parameters. Required: from, to, date'
            }), 400

        # Convert date string to datetime
        try:
            selected_date = pd.to_datetime(date_str, dayfirst=True)
            selected_dayofweek = selected_date.dayofweek
            selected_month = selected_date.month
        except:
            return jsonify({
                'success': False,
                'error': 'Invalid date format. Use DD-MM-YYYY'
            }), 400

        # Filter flights
        relevant_flights = flight_data[
            (flight_data['from'] == from_airport) &
            (flight_data['to'] == to_airport)
            ]

        if relevant_flights.empty:
            return jsonify({
                'success': True,
                'flights': [],
                'message': 'No flights found for the given criteria'
            })

        # Group by airline, from, to and calculate mean Total Delay and mean price
        grouped = relevant_flights.groupby(['airline', 'from', 'to']).agg({
            'Total Delay': 'mean',
            'price': 'mean'
        }).reset_index()

        # Round to 2 decimal places
        grouped['price'] = grouped['price'].round(2)
        grouped['Total Delay'] = grouped['Total Delay'].round(2)

        # Sort by price in ascending order
        sorted_flights = grouped.sort_values(by='price')

        # Convert to list of dictionaries for JSON response
        flights_list = sorted_flights.to_dict(orient='records')

        return jsonify({
            'success': True,
            'flights': flights_list
        })

    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500


# Add endpoint to get available airports (optional)
@app.route('/api/airports', methods=['GET'])
def get_airports():
    try:
        from_airports = flight_data['from'].unique().tolist()
        to_airports = flight_data['to'].unique().tolist()

        return jsonify({
            'success': True,
            'from_airports': from_airports,
            'to_airports': to_airports
        })
    except Exception as e:
        return jsonify({
            'success': False,
            'error': str(e)
        }), 500


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)