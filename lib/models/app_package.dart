class AppPackage {
  final String id;
  final String name;
  final int priceNaira;
  final String description;
  final List<String> benefits;

  const AppPackage({
    required this.id,
    required this.name,
    required this.priceNaira,
    required this.description,
    required this.benefits,
  });

  String get formattedPrice => '₦${priceNaira.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}';
}
