import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),  // Remove Scaffold here
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

 final WeatherFactory _wf = new WeatherFactory("e014a3cc21e43a92dbd545fd36f26934");

  Weather? _weather;


  // @override
  // void initState() {
  //   super.initState();
  //   _wf.currentWeatherByCityName("Mumbai").then((w){
  //     setState(() {
  //       _weather=w;
  //     });
  //   });
  // }

 String _city = "London"; // Default city
 final TextEditingController _cityController = TextEditingController();
 bool _isLoading = true;


 @override
 void initState() {
   super.initState();
   _fetchWeather();
 }



 @override
  Widget build(BuildContext context) {

   return Scaffold(
     body: SafeArea(
       child: SingleChildScrollView(
         child: _buildUI(),
       ),
     ),
   );

 }
  Widget _buildUI(){
    if(_weather==null){
      return const Center(child: CircularProgressIndicator(),);
    }
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: MediaQuery.sizeOf(context).height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
      Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                hintText: 'Enter city name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              if (_cityController.text.isNotEmpty) {
                _city = _cityController.text;
                _fetchWeather();
              }
            },
          ),
        ],
      ),
    ),
    const SizedBox(height: 20),
          _locationHeader(),
          SizedBox(
            height: MediaQuery.sizeOf(context).height*0.08,
          ),
          _dateTimeInfo(),
          SizedBox(
            height: MediaQuery.sizeOf(context).height*0.05,
          ),
          _weatherIcon(),
          SizedBox(
            height: MediaQuery.sizeOf(context).height*0.02,
          ),
          _currentTemp(),
          SizedBox(
            height: MediaQuery.sizeOf(context).height*0.02,
          ),
          _extraInfo(),

        ],
      ),
    );
  }

  Widget _locationHeader(){
    return Text(
      _weather?.areaName??"",
      style: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _dateTimeInfo(){
    DateTime now=_weather!.date!;
    return Column(
      children: [
        Text(DateFormat("h:mm a").format(now),
          style: const TextStyle(
            fontSize: 30,
          ),
        ),
        const SizedBox(
          height: 10,
        ),Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(DateFormat("EEEE").format(now),
            style: const TextStyle(
              fontWeight:FontWeight.w700 ,
            ),
          ),
            Text(
            "  ${DateFormat("d/m/y").format(now)}",
              style: const TextStyle(
                fontWeight:FontWeight.w400 ,
              ),
            ),

          ],
        )
      ],
    );
  }

  Widget _weatherIcon(){
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height*0.20,
          decoration: BoxDecoration(image:DecorationImage(image: NetworkImage("http://openweathermap.org/img/wn/${_weather?.weatherIcon}@4x.png"))),
        ),
        Text(_weather?.weatherDescription??"",
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
        ))
      ],
    );

  }

  Widget _currentTemp(){
    return Text("${_weather?.temperature?.celsius?.toStringAsFixed(0)}°C",
    style: const TextStyle(
      fontSize: 90,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    );
  }

  Widget _extraInfo(){
    return Container(
      height: MediaQuery.sizeOf(context).height*0.15,
      width: MediaQuery.sizeOf(context).width*0.80,
      decoration: BoxDecoration(color: Colors.deepPurpleAccent,
      borderRadius: BorderRadius.circular(20),),
      padding: const EdgeInsets.all(
          8.0,
      ),
      child:Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Max: ${_weather?.tempMax?.celsius?.toStringAsFixed(0)}°C",
    style: const TextStyle(
      color: Colors.white,
      fontSize: 15
    ),
              ),
              Text("Min: ${_weather?.tempMin?.celsius?.toStringAsFixed(0)}°C",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Wind: ${_weather?.windSpeed?.toStringAsFixed(0)}m/s",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15
                ),
              ),
              Text("Humidity: ${_weather?.humidity?.toStringAsFixed(0)}%",
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15
                ),
              ),
            ],
          )
        ],
      ) ,
    );

  }

 void _fetchWeather() {
   setState(() {
     _isLoading = true;
   });
   _wf.currentWeatherByCityName(_city).then((w) {
     setState(() {
       _weather = w;
       _isLoading = false;
     });
   }).catchError((e) {
     debugPrint("❌ Error fetching weather: $e");
     setState(() {
       _isLoading = false;
     });
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
       content: Text("Error: $e"),
     ));
   });
 }

}
