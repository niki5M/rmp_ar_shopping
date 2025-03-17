import '../model/filter.dart';

class Filters {
  List<Filter> list() {
    return <Filter>[
      Filter('Vintage',
          [
            1, -0.1, -0.05, 0, 0,
            0, 1, -0.1, 0, 0,
            -0.05, -0.1, 1, 0, 0,
            0, 0, 0, 1, 0
          ]
      ),
      Filter('Soft Blue',
          [
            0.9, 0, 0.1, 0, 0,
            0, 1, 0, 0, 0,
            0, 0, 1.2, 0, 0,
            0, 0, 0, 1, 0
          ]
      ),
      Filter('Warm Glow',
          [
            1.1, 0.1, 0, 0, 0,
            0, 1, 0, 0.1, 0,
            0, 0, 0.9, 0, 0,
            0, 0, 0, 1, 0
          ]
      ),
      Filter('Faded Green',
          [
            0.9, 0, 0, 0, 0,
            0.1, 1, 0.1, 0, 0,
            0, 0.1, 0.9, 0, 0,
            0, 0, 0, 1, 0
          ]
      ),
      Filter('Dusky Pink',
          [
            1, 0, 0.2, 0, 0,
            0, 1, 0.1, 0, 0,
            0.1, 0, 1, 0, 0,
            0, 0, 0, 1, 0
          ]
      ),
    ];
  }
}