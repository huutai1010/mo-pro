class Favorite {
  final int placeId;
  final String url;

  const Favorite({
    required this.placeId,
    required this.url,
  });

  factory Favorite.fromJson(Map<String, dynamic> jsonData) => Favorite(
        placeId: jsonData['placeId'],
        url: jsonData['url'],
      );
}
