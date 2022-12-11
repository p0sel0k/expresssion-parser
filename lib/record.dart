class Record<K, V> {
  final List<Pair<K, V>> record = [];

  Record();

  void add({required K key, required V val}) {
    record.add(Pair(key: key, value: val));
  }

  void addPair(Pair<K, V> pair) {
    record.add(pair);
  }

  int? contains_after(K elem, int curr_pos) {
    int index = 0;
    for (var p in record) {
      if (p.key == elem && index > curr_pos) {
        return index;
      }
      index++;
    }
    return null;
  }

  Record<K, V> get_sub_rec(int start, int end) {
    Record<K, V> rec = Record();
    int index = 0;
    for (var p in record) {
      if (index >= start && index <= end) {
        rec.addPair(p);
      }
    }
    return rec;
  }
}

class Pair<K, V> {
  final K key;
  final V value;

  Pair({required this.key, required this.value});
}
