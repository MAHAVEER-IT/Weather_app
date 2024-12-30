import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

import 'const.dart';

class Searchcity extends StatefulWidget {
  const Searchcity({super.key});

  @override
  State<Searchcity> createState() => _SearchcityState();
}

class _SearchcityState extends State<Searchcity> {
  final WeatherFactory _wf = WeatherFactory(OPEN_WEATHER_API_KEY);
  final TextEditingController _locationController = TextEditingController();

  Weather? _weather;

  Future<void> _fetchWeather(String cityName) async {
    try {
      Weather w = await _wf.currentWeatherByCityName(cityName);
      setState(() {
        _weather = w;
      });
    } catch (e) {
      print("Weather Calling Error $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not fetch weather for $cityName")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(67, 24, 149, 1.0),
              Color.fromRGBO(86, 65, 201, 1),
              Color.fromRGBO(126, 108, 226, 1.0),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _buildUI(),
        ),
      ),
    );
  }

  Widget _buildUI() {
    return Column(
      children: [
        _searchBar(),
        Expanded(
          child: _weather == null
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.transparent,
                    strokeWidth: 6,
                  ),
                )
              : _buildWeatherDetails(),
        ),
      ],
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: TextField(
        controller: _locationController,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Enter city name",
          hintStyle: TextStyle(color: Colors.white70),
          prefixIcon: Icon(Icons.search, color: Colors.white),
          filled: true,
          fillColor: Colors.indigo.shade400,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            _fetchWeather(value);
          }
        },
      ),
    );
  }

  Widget _buildWeatherDetails() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _locationHeader(),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.02,
          ),
          _dateTimeInfo(),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.04,
          ),
          _weatherIcon(),
          _ExtraInfo(),
        ],
      ),
    );
  }

  Widget _locationHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        Spacer(),
        Expanded(
          child: Text(
            _weather?.areaName?.toUpperCase() ?? "",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontStyle: FontStyle.italic),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Spacer()
      ],
    );
  }

  Widget _dateTimeInfo() {
    DateTime now = _weather!.date!;
    DateTime newDate = DateTime.now();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              DateFormat("EEEE").format(now),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontStyle: FontStyle.italic),
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              DateFormat("d.m.y").format(newDate),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontStyle: FontStyle.italic),
            ),
          ],
        )
      ],
    );
  }

  Widget _weatherIcon() {
    DateTime now = _weather!.date!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.25,
          width: MediaQuery.of(context).size.width * 0.3,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(80),
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(126, 108, 226, 1.0),
                Color.fromRGBO(183, 89, 228, 1.0),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(154, 135, 191, 1.0), // Shadow color
                offset: Offset(4, 4), // Horizontal and vertical offset
                blurRadius: 5, // How blurry the shadow is
                spreadRadius: 2,
              ),
            ],
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      children: [
                        Text(
                          DateFormat("h:mm a").format(now),
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        Text(
                          DateFormat("EEEE").format(now),
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Image.network(
                    "http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png",
                    scale: 2,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${_weather?.temperature?.celsius?.toStringAsFixed(0)}° C",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            _weather?.weatherDescription?.toUpperCase() ?? "",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.indigo.shade100),
          ),
        )
      ],
    );
  }

  Widget _ExtraInfo() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.44,
      width: MediaQuery.of(context).size.width * 0.82,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(8),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1,
        children: [
          _buildInfoTile(
            "MIN TEMP",
            "${_weather?.tempMin?.celsius?.toStringAsFixed(0)}° C",
            "https://cdn-icons-png.flaticon.com/128/5826/5826433.png",
          ),
          _buildInfoTile(
            "MAX TEMP",
            "${_weather?.tempMax?.celsius?.toStringAsFixed(0)}° C",
            "https://cdn-icons-png.flaticon.com/128/5826/5826412.png",
          ),
          _buildInfoTile(
            "WIND",
            "${_weather?.windSpeed?.toStringAsFixed(0)} m/s",
            "https://cdn-icons-png.flaticon.com/128/5532/5532989.png",
          ),
          _buildInfoTile(
            "HUMIDITY",
            "${_weather?.humidity?.toStringAsFixed(0)}%",
            "https://cdn-icons-png.flaticon.com/128/8923/8923690.png",
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.indigo.shade400,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color.fromRGBO(154, 135, 191, 1.0), width: 2),
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(61, 20, 140, 1.0),
            Color.fromRGBO(96, 53, 178, 1),
            Color.fromRGBO(122, 93, 177, 1.0),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              height: 50,
              width: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.error,
                color: Colors.red,
                size: 50,
              ), // Handles broken image links
            ),
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
