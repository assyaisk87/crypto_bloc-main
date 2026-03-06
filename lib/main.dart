import 'package:crypto_bloc/bloc/crypto_bloc.dart';
import 'package:crypto_bloc/bloc/crypto_event.dart';
import 'package:crypto_bloc/crypto_page.dart';
import 'package:crypto_bloc/crypto_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: BlocProvider(
        create: (_) => CryptoBloc(CryptoRepository())..add(LoadCryptoData()),
        child: CryptoPage(),
      ),
    );
  }
}
