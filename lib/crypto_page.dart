import 'package:crypto_bloc/bloc/crypto_bloc.dart';
import 'package:crypto_bloc/bloc/crypto_event.dart';
import 'package:crypto_bloc/bloc/crypto_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive_ce.dart';

class CryptoPage extends StatelessWidget {
  const CryptoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crypto App'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<CryptoBloc>().add(ClearCache());
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: BlocConsumer<CryptoBloc, CryptoState>(
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Ошибка')));
          }
        },
        builder: (context, state) {
          final lastUpdate = Hive.box(
            'settingsBox',
          ).get('last_update', defaultValue: 'Никогда не обновлялось');

          if (state.isLoading && state.cryptoList.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              if (state.isLoading && state.cryptoList.isNotEmpty)
                LinearProgressIndicator(),
              SizedBox(height: 20),

              Wrap(
                spacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<CryptoBloc>().add(FilterGainers());
                    },
                    child: Text('Рост'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CryptoBloc>().add(ResetFilter());
                    },
                    child: Text('Сброс'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CryptoBloc>().add(FilterDrops());
                    },
                    child: Text('Падение'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CryptoBloc>().add(Top10());
                    },
                    child: Text('Top 10'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text('Последнее обновление: $lastUpdate'),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: state.cryptoList.length,
                  itemBuilder: (context, index) {
                    final crypto = state.cryptoList[index];
                    return Card(
                      child: ListTile(
                        title: Text(crypto.name),
                        subtitle: Text('${crypto.priceUsd}\$'),
                        trailing: Text(
                          '${crypto.percentChange24h}%',
                          style: TextStyle(
                            color: double.parse(crypto.percentChange24h) >= 0
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
