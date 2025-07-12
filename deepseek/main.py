import re
import requests
import json
from flask import Flask, request, jsonify
import ollama

app = Flask(__name__)

def extract_flight_number(prompt):
    match = re.search(r'\b[A-Z]{2}\d{3,4}\b', prompt)
    if match:
        flight_number = match.group(0)
        return flight_number
    return None

def query_deepseek_stream(prompt, model="deepseek-v2:16b"):
    try:
        stream = ollama.generate(
            model=model,
            prompt=prompt,
            options={
                "temperature": 0.7,
                "max_tokens": 150
            },
            stream=True
        )
        output = ""
        for chunk in stream:
            chunk_text = chunk['response']
            output += chunk_text
        return output.strip()
    except Exception as e:
        return f"Error querying DeepSeek: {str(e)}"

def get_flight_info(flight_number):
    access_key = "API_KEY"  # Replace with your AviationStack API key
    url = f"https://api.aviationstack.com/v1/flights?access_key={access_key}&flight_iata={flight_number}"
    response = requests.get(url)
    if response.status_code == 200:
        data = response.json()
        if data['data']:
            flight_data = data['data'][0]
            flight_info = {
                "flight_number": flight_data['flight']['iata'],
                "departure": flight_data['departure']['estimated'],
                "arrival": flight_data['arrival']['estimated'],
                "status": flight_data['flight_status'],
                "airline": flight_data['airline']['name'],
                "departure_airport": flight_data['departure']['airport'],
                "arrival_airport": flight_data['arrival']['git airport'],
                "departure_timezone": flight_data['departure']['timezone'],
                "arrival_timezone": flight_data['arrival']['timezone'],
                "estimated_delay": flight_data.get('departure', {}).get('estimated_delay', "Not available"),
                "cancelled": flight_data['flight_status'] == 'Cancelled',
                "cause_of_delay": flight_data.get('arrival', {}).get('delay_reason', "Not available"),
            }
            return flight_info
    return None

@app.route('/get-flight-info', methods=['POST'])
def get_flight_info_from_prompt():
    try:
        user_input = request.json.get("user_prompt")
        flight_number = extract_flight_number(user_input)

        if not flight_number:
            # No flight number: send the user prompt directly to DeepSeek
            deepseek_response = query_deepseek_stream(user_input)
            return jsonify({
                "deepseek_context_response": deepseek_response
            })

        flight_details = get_flight_info(flight_number)
        if not flight_details:
            return jsonify({"error": "Unable to retrieve flight information from the API."}), 400

        context_json = {
            "flight_details": flight_details
        }

        context_prompt = (
            f"The user asked: '{user_input}'\n\n"
            f"Here is the context about flight {flight_number}:\n"
            f"{json.dumps(context_json, indent=2)}\n\n"
            f"Based on this context, provide a detailed response to the user's question, just answer the question dont talk too much"
        )
        deepseek_context_response = query_deepseek_stream(context_prompt)

        return jsonify({
            "deepseek_context_response": deepseek_context_response
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=5001)