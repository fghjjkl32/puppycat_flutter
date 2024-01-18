part of 'common.dart';

enum ListAPIStatus {
  idle,
  loading,
  loaded,
  error,
}

enum PetGender {
  boy(1, "수컷", ""),
  girl(2, "암컷", ""),
  boyNeutering(3, "수컷 중성화", ""),
  girlNeutering(4, "암컷 중성화", "");

  const PetGender(this.value, this.name, this.icon);

  final int value;
  final String name;
  final String icon;
}

enum PetSize {
  small(1, "작음", ""),
  middle(2, "중간", ""),
  big(3, "큼", "");

  const PetSize(this.value, this.name, this.icon);

  final int value;
  final String name;
  final String icon;
}

enum PetAge {
  puppy(1, "퍼피", ""),
  adult(2, "어덜트", ""),
  senior(3, "시니어", "");

  const PetAge(this.value, this.name, this.icon);

  final int value;
  final String name;
  final String icon;
}

enum PetCharacter {
  kind(1, '착하고 온순해요!'),
  timid(2, '소심하고 겁이 많아요!'),
  barky(3, '사람만 보면 짖어요!'),
  active(4, '활발해요!'),
  sensitive(5, '예민해요!'),
  friendly(6, '친화력이 좋아요!'),
  custom(7, '직접입력(최대 40자)');

  const PetCharacter(this.value, this.name);

  final int value;
  final String name;
}
