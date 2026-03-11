final String tableName = 'storeCards';

class CardFields {
  static final List<String> values = [id, cardHolder, cardNumber, expYear, cvs];
  static final String id = '_id';
  static final String cardHolder = 'cardHolder';
  static final String cardNumber = 'cardNumber';
  static final String expYear = 'expYear';
  static final String cvs = 'cvs';
}

class Cards {
  int id;
  // String cardHolder, cardNumber, expYear, cvs;
  String cardHolder;
  int cardNumber, expYear, cvs;

  Cards({this.id, this.cardHolder, this.cardNumber, this.expYear, this.cvs});

  Cards copy({
    int id,
    String cardHolder,
    int cardNumber,
    expYear,
    cvs,
  }) =>
      Cards(
        id: id ?? this.id,
        cardHolder: cardHolder ?? this.cardHolder,
        cardNumber: cardNumber ?? this.cardNumber,
        expYear: expYear ?? this.expYear,
        cvs: cvs ?? this.cvs,
      );

  static Cards fromJson(Map<String, Object> json) => Cards(
        id: json[CardFields.id] as int,
        cardHolder: json[CardFields.cardHolder] as String,
        cardNumber: json[CardFields.cardNumber] as int,
        expYear: json[CardFields.expYear] as int,
        cvs: json[CardFields.cvs] as int,
      );

  Map<String, Object> toJson() => {
        CardFields.id: id,
        CardFields.cardHolder: cardHolder,
        CardFields.cardNumber: cardNumber,
        CardFields.expYear: expYear,
        CardFields.cvs: cvs,
      };
}
