abstract class AbstractFilter<T> {
  bool matches(T model);

  bool withinRange(num value, {num? start, num? end}) {
    if (start != null && value < start) return false;
    if (end != null && value > end) return false;
    return true;
  }
}