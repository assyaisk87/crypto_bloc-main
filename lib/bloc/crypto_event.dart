abstract class CryptoEvent {}

class LoadCryptoData extends CryptoEvent {}

class FilterGainers extends CryptoEvent {}

class ResetFilter extends CryptoEvent {}

class FilterDrops extends CryptoEvent {}

class Top10 extends CryptoEvent {}

class ClearCache extends CryptoEvent {}
