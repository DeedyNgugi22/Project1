class Propertytype {
  String id;
  String name;
  String price;
  String location;
  String description;
  String image;
  String create_at;
  String update_at;

  Propertytype({
    required this.id,
    required this.name,
    required this.price,
    required this.location,
    required this.description,
    required this.image,
    required this.create_at,
    required this.update_at,
  });
  factory Propertytype.fromJson(Map<String, dynamic> json) {
    return Propertytype(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      location: json['location'],
      description: json['description'],
      image: json['image'],
      create_at: json['create_at'],
      update_at: json['update_at'],
    );
  }
}
