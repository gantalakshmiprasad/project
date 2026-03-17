// ignore_for_file: file_names

class Product {
  final String id; // $id (document ID)
  final String itemname; // required text
  final String itemprice; // required text (stored as string in Appwrite)
  final String userid;

  final DateTime? createdAt; // $createdAt (datetime)
  final DateTime? updatedAt; // $updatedAt (datetime)
  final String fileid;
  final bool isavailable;
  Product({
    required this.id,
    required this.itemname,
    required this.itemprice,
    required this.userid,

    this.createdAt,
    this.updatedAt,
    required this.fileid,
    this.isavailable = true,
  });

  // Convert Product to Map (for Appwrite or JSON)
  Map<String, dynamic> toMap() {
    return {
      'itemname': itemname,
      'itemprice': itemprice,
      'userid': userid,
      'fileid': fileid,
      'isavailable': isavailable,
    };
  }

  // Create Product from Map (when reading from Appwrite)
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['\$id'],
      itemname: map['itemname'],
      itemprice: map['itemprice'],
      userid: map['userid'],
      createdAt: map['\$createdAt'] != null
          ? DateTime.parse(map['\$createdAt'])
          : null,
      updatedAt: map['\$updatedAt'] != null
          ? DateTime.parse(map['\$updatedAt'])
          : null,
      fileid: map['fileid'],
      isavailable: map['isavailable'] ?? true,
    );
  }
}
