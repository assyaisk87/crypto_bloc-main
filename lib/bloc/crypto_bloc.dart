import 'package:crypto_bloc/crypto_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:crypto_bloc/bloc/crypto_event.dart';
import 'package:crypto_bloc/bloc/crypto_state.dart';

class CryptoBloc extends Bloc<CryptoEvent, CryptoState> {
  final CryptoRepository cryptoRepository;

  CryptoBloc(this.cryptoRepository) : super(const CryptoState()) {
    on<LoadCryptoData>((event, emit) async {
      final localData = cryptoRepository.getLocaleCrypyoData();
      final savedFavorites = cryptoRepository.getFavoriteIds();
      if (localData.isNotEmpty) {
        emit(
          state.copyWith(
            cryptoList: localData,
            originalCryptoList: localData,
            favoritesIds: savedFavorites,
            isLoading: false,
            error: null,
          ),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: true,
            favoritesIds: savedFavorites,
            error: null,
          ),
        );
      }

      await Future.delayed(Duration(seconds: 5)); // имитация задержки

      try {
        final data = await cryptoRepository.fetchCryptoData();

        emit(
          state.copyWith(
            cryptoList: data,
            originalCryptoList: data,
            isLoading: false,
          ),
        );
      } catch (e) {
        print('object $e');
        emit(state.copyWith(error: e.toString(), isLoading: false));
      }
    });

    on<FilterGainers>((event, emit) {
      final gainers = state.originalCryptoList.where(
        (item) => double.parse(item.percentChange24h) > 0,
      );

      emit(
        state.copyWith(showOnlyFavorites: false, cryptoList: gainers.toList()),
      );
    });

    on<ResetFilter>((event, emit) {
      emit(
        state.copyWith(
          showOnlyFavorites: false,
          cryptoList: state.originalCryptoList,
        ),
      );
    });

    on<ClearCache>((event, emit) async {
      await cryptoRepository.clearCache();
      emit(state.copyWith(cryptoList: []));
    });

    on<FilterDrops>((event, emit) {
      final drops = state.originalCryptoList.where(
        (item) => double.parse(item.percentChange24h) < 0,
      );

      emit(
        state.copyWith(showOnlyFavorites: false, cryptoList: drops.toList()),
      );
    });

    on<Top10>((event, emit) {
      final gainers = state.originalCryptoList
          .where((item) => double.tryParse(item.percentChange24h) != null)
          .toList();

      // сортируем по убыванию процента роста
      gainers.sort(
        (a, b) => double.parse(
          b.percentChange24h,
        ).compareTo(double.parse(a.percentChange24h)),
      );

      // берём только топ-10
      final top10 = gainers.take(10).toList();

      emit(state.copyWith(showOnlyFavorites: false, cryptoList: top10));
    });

    on<ToggleFavorite>((event, emit) {
      final currentFavorites = Set<String>.from(state.favoritesIds);
      if (currentFavorites.contains(event.id)) {
        currentFavorites.remove(event.id);
      } else {
        currentFavorites.add(event.id);
      }
      cryptoRepository.toggleFavorite(event.id);
      emit(state.copyWith(favoritesIds: currentFavorites));
    });

    on<FilterFavorites>((event, emit) {
      emit(state.copyWith(showOnlyFavorites: !state.showOnlyFavorites));
    });

    on<ClearAllFavorites>((event, emit) async {
      await cryptoRepository.clearAllFavorites();
      emit(state.copyWith(showOnlyFavorites: false, favoritesIds: {}));
    });
  }
}
