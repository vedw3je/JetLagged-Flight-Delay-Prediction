# ✈️ JetLagged – Flight Delay Prediction App

JetLagged is a cross-platform mobile application built with Flutter that predicts flight delays using historical flight data, real-time weather information, and live flight data. The app is designed to help travelers plan better, avoid disruptions, and make informed travel decisions.

---

## 🚀 Features

### 1. **Flight Delay Prediction**
- Users can enter the flight IATA number to get predicted delay time.
- The app predicts the **estimated delay duration (in minutes)** using a trained machine learning model.
- The model considers multiple features like distance, airport rating, airline rating, weather conditions, and more.

### 2. **Live Flight Data Integration**
- Integrated with **AviationStack API** to fetch live flight schedules and current flight status.

### 3. **Weather-aware Predictions**
- Uses **OpenWeather API** to collect real-time weather data for both source and destination airports.
- Weather parameters like wind speed, visibility, and cloud cover are used as inputs to the ML model.

### 4. **Smart Flight Suggestions**
- Based on predicted delays and GoIbibo dataset trends, the app suggests alternate flights with lower delay probability and better prices.

### 5. **Interactive Chatbot**
- A chatbot interface helps users understand flight predictions, explore options, and ask questions about their trip.

### 6. **Live Flight Tracking**
- Track flights in real-time on a map (via live coordinates from AviationStack).
- Helpful for monitoring ongoing flights or checking delays for others.

---

## 🤖 Machine Learning

- **Model Used:** LightGBM Regressor (LGBM)
- **Optimization:** Optuna (Bayesian hyperparameter tuning)
- **Performance:** Achieved an R² score of **0.74** on the test dataset
- **Data Sources:**
  - Historical flight and weather data
  - GoIbibo public flight dataset
  - Real-time weather and flight data

- **Model Inputs:**
  - Distance, source/destination, airline, weather parameters, airport ratings, etc.
  
---

## 📱 Tech Stack

- **Frontend:** Flutter (Dart)
- **Backend/Model:** Python (LightGBM, Optuna, Pandas, Scikit-learn)
- **APIs:**
  - AviationStack API (live flight data)
  - OpenWeather API (real-time weather)
- **Others:** DeepSeek R1 (for delay pattern analysis), GoIbibo Dataset, SQLite (optional)

---

## 📊 Architecture Diagram

![Architecture Diagram](https://github.com/vedw3je/JetLagged-Flight-Delay-Prediction/blob/main/Diagram.jpeg?raw=true)

## 🎥 Demo Video

[Watch Demo Video on Google Drive](https://drive.google.com/file/d/1TDM0cVwt4guEX6y6v_Mwpb7v1PGPVgQN/view?usp=sharing)




