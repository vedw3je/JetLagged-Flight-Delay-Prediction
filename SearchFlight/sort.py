
import pandas as pd
from datetime import datetime

def get_valid_date_input():
    while True:
        try:
            date_str = input("Enter date (DD-MM-YYYY): ")
            selected_date = datetime.strptime(date_str, "%d-%m-%Y")
            return selected_date
        except ValueError:
            print("Invalid date format. Please use DD-MM-YYYY format.")

flight_delay_data = pd.read_csv('Dataset.csv')
flight_price_data = pd.read_csv('goibibo_flights_data.csv')


flight_delay_data = flight_delay_data.rename(columns={
    'From': 'from',
    'To': 'to',
    'Airline': 'airline'
})

flight_delay_data['Used Date'] = pd.to_datetime(flight_delay_data['Used Date'], errors='coerce')
flight_price_data['flight date'] = pd.to_datetime(flight_price_data['flight date'], errors='coerce')
flight_delay_data['DayOfWeek'] = flight_delay_data['Used Date'].dt.dayofweek
flight_price_data['DayOfWeek'] = flight_price_data['flight date'].dt.dayofweek
flight_delay_data['Month'] = flight_delay_data['Used Date'].dt.month
flight_price_data['Month'] = flight_price_data['flight date'].dt.month

flight_delay_data['price'] = flight_price_data['price'].iloc[:len(flight_delay_data)].values
flight_delay_data['price'] = flight_delay_data['price'].str.replace(',', '').astype(float)

flight_delay_data['Total Delay'] = flight_delay_data['Departure Delay'] + flight_delay_data['Arrival Delay']

user_input_from = input("Enter departure airport code")
user_input_to = input("Enter arrival airport code")
user_input_date = get_valid_date_input()

selected_date = pd.to_datetime(user_input_date, dayfirst=True)
selected_dayofweek = selected_date.dayofweek
selected_month = selected_date.month
relevant_flights = flight_delay_data[
    (flight_delay_data['from'] == user_input_from) &
    (flight_delay_data['to'] == user_input_to)
]

grouped = relevant_flights.groupby(['airline', 'from', 'to']).agg({
    'Total Delay': 'mean',
    'price': 'mean'
}).reset_index()
grouped['price'] = grouped['price'].round(2)
grouped['Total Delay'] = grouped['Total Delay'].round(2)
sorted_flights = grouped.sort_values(by='price')
print(sorted_flights[['airline', 'from', 'to', 'Total Delay', 'price']])

























