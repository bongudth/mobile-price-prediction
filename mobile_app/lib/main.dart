import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile app',
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<int, String> screenTypeData = {0: 'LCD', 1: 'OLED'};
  final Map<int, String> osData = {0: 'Android', 1: 'iOS'};
  final Map<int, String> chipsetData = {
    0: 'Apple bionic',
    1: 'Exynos',
    2: 'Mediatek',
    3: 'Snapdragon'
  };
  final Map<int, String> networkData = {4: '4G', 5: '5G'};
  final Map<int, String> resolutionData = {
    307200: 'VGA',
    921600: 'HD',
    2073600: 'Full HD',
    3686400: '2K'
  };

  int? screenType;
  int? chipSet;
  int? os;
  int? mobileNetwork;
  int? screenResolution;
  int ram = 0;
  int rom = 0;
  int battery = 0;
  double price = 0.0;
  String errorMessage = '';

  final _formKey = GlobalKey<FormState>();
  final _formatter = NumberFormat.simpleCurrency(locale: 'vi', name: 'đ');

  Future<double> predictPrice() async {
    final response = await http.Client().post(
      Uri.parse('https://mobile-price-predict.azurewebsites.net/predict/'),
      body: jsonEncode(<String, dynamic>{
        'scr_type': screenType,
        'chip': chipSet,
        'OS': os,
        'RAM': ram * 1024,
        'ROM': rom * 1024,
        'scr_res': screenResolution,
        'battery': battery,
        'net': mobileNetwork,
      }),
      headers: <String, String>{'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Có lỗi xảy ra vui lòng thử lại');
    }
    return jsonDecode(response.body)['price'] * 1000;
  }

  Future<void> predict(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Dự đoán giá'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FutureBuilder<double>(
                  future: predictPrice(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error as String),
                      );
                    } else {
                      return Center(
                        child: Text.rich(
                          TextSpan(
                            text: 'Giá dự đoán là: ',
                            children: [
                              TextSpan(
                                text: _formatter.format(snapshot.data),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              )
                            ],
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Đóng'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
    }
  }

  void resetForm() {
    FocusManager.instance.primaryFocus?.unfocus();
    _formKey.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Dự đoán giá điện thoại',
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  onChanged: (value) {
                    setState(() {
                      screenType = int.parse(value ?? '0');
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Screen type',
                    border: OutlineInputBorder(),
                  ),
                  items: screenTypeData.entries
                      .map<DropdownMenuItem<String>>(
                        (e) => DropdownMenuItem(
                          value: e.key.toString(),
                          child: Text(e.value),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(
                  height: 8,
                ),
                DropdownButtonFormField<String>(
                  onChanged: (value) {
                    setState(() {
                      os = int.parse(value ?? '0');
                    });
                  },
                  validator: (value) {
                    return value?.isEmpty == true
                        ? 'Không được để trống trường này'
                        : null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'OS',
                    border: OutlineInputBorder(),
                  ),
                  items: osData.entries
                      .map<DropdownMenuItem<String>>(
                        (e) => DropdownMenuItem(
                          value: e.key.toString(),
                          child: Text(e.value),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(
                  height: 8,
                ),
                DropdownButtonFormField<String>(
                  onChanged: (value) {
                    setState(() {
                      chipSet = int.parse(value ?? '0');
                    });
                  },
                  validator: (value) {
                    return value?.isEmpty == true
                        ? 'Không được để trống trường này'
                        : null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Chipset',
                    border: OutlineInputBorder(),
                  ),
                  items: chipsetData.entries
                      .map<DropdownMenuItem<String>>(
                        (e) => DropdownMenuItem(
                          value: e.key.toString(),
                          child: Text(e.value),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(
                  height: 8,
                ),
                DropdownButtonFormField<String>(
                  onChanged: (value) {
                    setState(() {
                      mobileNetwork = int.parse(value ?? '0');
                    });
                  },
                  validator: (value) {
                    return value?.isEmpty == true
                        ? 'Không được để trống trường này'
                        : null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Mobile Network',
                    border: OutlineInputBorder(),
                  ),
                  items: networkData.entries
                      .map<DropdownMenuItem<String>>(
                        (e) => DropdownMenuItem(
                          value: e.key.toString(),
                          child: Text(e.value),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(
                  height: 8,
                ),
                DropdownButtonFormField<String>(
                  onChanged: (value) {
                    setState(() {
                      screenResolution = int.parse(value ?? '0');
                    });
                  },
                  validator: (value) {
                    return value?.isEmpty == true
                        ? 'Không được để trống trường này'
                        : null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Screen Resolution',
                    border: OutlineInputBorder(),
                  ),
                  items: resolutionData.entries
                      .map<DropdownMenuItem<String>>(
                        (e) => DropdownMenuItem(
                          value: e.key.toString(),
                          child: Text(e.value),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        ram = int.parse(value);
                      });
                    }
                  },
                  validator: (value) {
                    return value?.isEmpty == true
                        ? 'Không được để trống trường này'
                        : null;
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'RAM',
                    border: OutlineInputBorder(),
                    suffixText: 'GB',
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        rom = int.parse(value);
                      });
                    }
                  },
                  validator: (value) {
                    return value?.isEmpty == true
                        ? 'Không được để trống trường này'
                        : null;
                  },
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'ROM',
                    border: OutlineInputBorder(),
                    suffixText: 'GB',
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        battery = int.parse(value);
                      });
                    }
                  },
                  validator: (value) {
                    return value?.isEmpty == true
                        ? 'Không được để trống trường này'
                        : null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Battery',
                    border: OutlineInputBorder(),
                    suffixText: 'mAh',
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green.shade400,
                        onPrimary: Colors.white,
                      ),
                      onPressed: () async {
                        await predict(context);
                      },
                      child: const Text('Dự đoán'),
                    ),
                    const SizedBox(
                      width: 32,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red.shade400,
                        onPrimary: Colors.white,
                      ),
                      onPressed: resetForm,
                      child: const Text('Reset'),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
