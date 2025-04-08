class CurrencyData {
  //final int id;
  final String objectId;
  final String usd;
  final String bdt;
  final String inr;
  final String pkr;
  final String idr;
  final String tryValue;
  final String myr;
  final String sar;
  final String zakatId;
  final String timestamp;
  final DateTime createdAt;
  final DateTime updatedAt;

  CurrencyData({
    //required this.id,
    required this.objectId,
    required this.usd,
    required this.bdt,
    required this.inr,
    required this.pkr,
    required this.idr,
    required this.tryValue,
    required this.myr,
    required this.sar,
    required this.zakatId,
    required this.timestamp,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CurrencyData.fromJson(Map<String, dynamic> json) {
    return CurrencyData(
      //id: json['id'],
      objectId: json['_id'],
      usd: json['USD'],
      bdt: json['BDT'],
      inr: json['INR'],
      pkr: json['PKR'],
      idr: json['IDR'],
      tryValue: json['TRY'],
      myr: json['MYR'],
      sar: json['SAR'],
      zakatId: json['zakatId'],
      timestamp: json['timestamp'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}