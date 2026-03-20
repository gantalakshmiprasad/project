class Billmodel {
  final String id;
  final String itemname;
  final double itemprice; // Using double is safer for currency
  final int quantity;
  final double amount;

  Billmodel({
    required this.id,
    required this.itemname,
    required this.itemprice,
    required this.quantity,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itemname': itemname,
      'itemprice': itemprice,
      'quantity': quantity,
      'amount': amount,
    };
  }

  factory Billmodel.fromMap(Map<String, dynamic> map) {
    // 1. Safely parse price (handles String or num)
    final double price =
        double.tryParse(map['data']['itemprice'].toString()) ?? 0.0;

    // 2. Safely parse quantity
    final int qty = int.tryParse(map['quantity'].toString()) ?? 0;

    return Billmodel(
      id: map['id'],
      itemname: map['data']['itemname'] ?? 'Unknown Item',
      itemprice: price,
      quantity: qty,
      amount: price * qty, // Calculate amount once here
    );
  }
}
