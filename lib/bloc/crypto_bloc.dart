import 'package:crypto_bloc/crypto_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:crypto_bloc/bloc/crypto_event.dart';
import 'package:crypto_bloc/bloc/crypto_state.dart';

class CryptoBloc extends Bloc<CryptoEvent, CryptoState> {
  final CryptoRepository cryptoRepository;

  CryptoBloc(this.cryptoRepository) : super(const CryptoState()) {
    on<LoadCryptoData>((event, emit) async {
      emit(state.copyWith(isLoading: true, error: null));

      try {
        final data = await cryptoRepository.fetchCryptoData();

        emit(state.copyWith(cryptoList: data, isLoading: false));
      } catch (e) {
        print('object $e');
        emit(state.copyWith(error: e.toString(), isLoading: false));
      }
    });

     on<FilterGainers>((event, emit) {
      final gainers = state.cryptoList.where(
        (item) => double.parse(item.percentChange24h) > 0
      );
      
      emit(state.copyWith(cryptoList: gainers.toList()));
    });

    on<ResetFilter>((event, emit) {
         add(LoadCryptoData());
    });

    on<FilterDrops>((event, emit) {     
      final drops = state.cryptoList.where(
        (item) => double.parse(item.percentChange24h) < 0
      );
      
      emit(state.copyWith(cryptoList: drops.toList()));
    });

    on<Top10>((event, emit) {
      final gainers = state.cryptoList
      .where((item) => double.tryParse(item.percentChange24h) != null)
      .toList();

      // сортируем по убыванию процента роста
      gainers.sort((a, b) =>
          double.parse(b.percentChange24h).compareTo(double.parse(a.percentChange24h)));

      // берём только топ-10
      final top10 = gainers.take(10).toList();

      emit(state.copyWith(cryptoList: top10));
    });
   
  }
}

