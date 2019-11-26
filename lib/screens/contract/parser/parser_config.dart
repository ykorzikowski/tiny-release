class ParserConfig {
  static const String MODEL = 'model';
  static const String PHOTOGRAPHER = 'photographer';
  static const String WITNESS = 'witness';
  static const String PARENT = 'parent';
  static const String CONTRACT = 'contract';

  static const String MODEL_FIRSTNAME = '$MODEL.givenName';
  static const String MODEL_LASTNAME = '$MODEL.familyName';

  static const String PHOTOGRAPHER_FIRSTNAME = '$PHOTOGRAPHER.givenName';
  static const String PHOTOGRAPHER_LASTNAME = '$PHOTOGRAPHER.familyName';

  static const String WITNESS_FIRSTNAME = '$WITNESS.givenName';
  static const String WITNESS_LASTNAME = '$WITNESS.familyName';

  static const String PARENT_FIRSTNAME = '$PARENT.givenName';
  static const String PARENT_LASTNAME = '$PARENT.familyName';

  static const String CONTRACT_IMAGES_COUNT = '$CONTRACT.imagesCount';
  static const String CONTRACT_LOCATION = '$CONTRACT.location';
  static const String CONTRACT_DATE = '$CONTRACT.date';
  static const String CONTRACT_SHOOTINGAREAS = '$CONTRACT.shootingareas';

  static const List<String> PLACEHOLDERS = [
    MODEL_FIRSTNAME, MODEL_LASTNAME, PHOTOGRAPHER_FIRSTNAME, PHOTOGRAPHER_LASTNAME, WITNESS_FIRSTNAME, WITNESS_LASTNAME, PARENT_FIRSTNAME, PARENT_LASTNAME,
    CONTRACT_IMAGES_COUNT, CONTRACT_LOCATION, CONTRACT_DATE, CONTRACT_SHOOTINGAREAS
  ];
}
