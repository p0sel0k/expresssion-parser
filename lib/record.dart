class Record<K, V> {
  final List<Pair<K, V>> record;

  Record() : record = [];
  Record.fromList(this.record);

  void add({required K key, required V val}) {
    record.add(Pair(key: key, value: val));
  }

  Record<K, V> addPair(Pair<K, V> pair) {
    record.add(pair);
    return this;
  }

  int? containsAfter(K elem, int currPos) {
    int index = 0;
    for (var p in record) {
      if (p.key == elem && index >= currPos) {
        return index;
      }
      index++;
    }
    return null;
  }

  Record<K, V> getSubRec(int start, int end) {
    Record<K, V> rec = Record();
    rec = Record.fromList(record.getRange(start, end).toList());
    return rec;
  }

  Pair<K, V> get(int index) {
    return record[index];
  }

  int get len {
    return record.length;
  }
}

class Pair<K, V> {
  final K key;
  final V value;

  Pair({required this.key, required this.value});
}
