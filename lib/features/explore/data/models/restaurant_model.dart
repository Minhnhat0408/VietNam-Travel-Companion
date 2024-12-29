import 'package:vn_travel_companion/features/explore/domain/entities/restaurant.dart';

class RestaurantModel extends Restaurant {
  RestaurantModel(
      {required super.id,
      required super.name,
      required super.cover,
      required super.price,
      required super.latitude,
      required super.longitude,
      required super.avgRating,
      required super.jumpUrl,
      required super.ratingCount,
      required super.cuisineName,
      super.userNickname,
      super.userAvatar,
      super.userContent});

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['poiId'],
      name: json['poiName'],
      cover: json['coverImgaeUrl'],
      price: json['price'],
      latitude: json['gglat'],
      longitude: json['gglon'],
      avgRating: json['rating'],
      ratingCount: json['reviewCount'],
      cuisineName: json['cuisineName'],
      userNickname: json['commentInfo']['nickname'],
      userAvatar: json['commentInfo']['headPhoto'],
      userContent: json['commentInfo']['content'],
      jumpUrl: json['jumpUrl'],
    );
  }

  factory RestaurantModel.fromGeneralLocationInfo(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['poiId'],
      name: json['name'],
      cover: json['imageUrl'],
      price: json['price'] is int
          ? json['price']
          : json['price'] is String
              ? int.tryParse(json['price'].split('.')[0]) ?? 0
              : json['price'] is double
                  ? json['price'].toInt()
                  : 0,
      latitude: json['gglat'] ?? 0.0,
      longitude: json['gglon'] ?? 0.0,
      avgRating: json['score'],
      ratingCount: json['commentNum'] != null
          ? json['commentNum'] is int
              ? json['commentNum']
              : int.parse(json['commentNum'])
          : 0,
      cuisineName: json['tagList'] != null ? json['tagList'][0] : 'Ẩm thực',
      userNickname: '',
      userAvatar: '',
      userContent: '',
      jumpUrl: json['jumpUrl'],
    );
  }

  RestaurantModel copyWith({
    int? id,
    String? name,
    String? cover,
    int? price,
    double? latitude,
    double? longitude,
    double? avgRating,
    int? ratingCount,
    String? cuisineName,
    String? userNickname,
    String? userAvatar,
    String? userContent,
    String? jumpUrl,
  }) {
    return RestaurantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      cover: cover ?? this.cover,
      price: price ?? this.price,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      avgRating: avgRating ?? this.avgRating,
      ratingCount: ratingCount ?? this.ratingCount,
      cuisineName: cuisineName ?? this.cuisineName,
      userNickname: userNickname ?? this.userNickname,
      userAvatar: userAvatar ?? this.userAvatar,
      userContent: userContent ?? this.userContent,
      jumpUrl: jumpUrl ?? this.jumpUrl,
    );
  }
}