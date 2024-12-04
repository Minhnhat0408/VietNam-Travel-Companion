import 'package:vn_travel_companion/features/user_preference/domain/entities/preference.dart';
import 'package:vn_travel_companion/features/user_preference/domain/entities/travel_type.dart';

const Map<String, double> travelPrefDf = {
  "Spa": 0,
  "Hồ": 0,
  "Núi": 0,
  "Chợ": 0,
  "Cầu": 0,
  "Làng": 0,
  "Sông": 0,
  "Rừng": 0,
  "Câu Cá": 0,
  "Leo Núi": 0,
  "Bể Bơi": 0,
  "Cáp Treo": 0,
  "Nhà hát": 0,
  "Sân Golf": 0,
  "Sở Thú": 0,
  "Chùa Cổ": 0,
  "Hẻm Núi": 0,
  "Lâu Đài": 0,
  "Bãi Biển": 0,
  "Bảo tàng": 0,
  "Bờ Biển": 0,
  "Thư Viện": 0,
  "Thủy Cung": 0,
  "Đầm Phá": 0,
  "Hang Động": 0,
  "Nghĩa Trang": 0,
  "Nông Trại": 0,
  "Đạo Quán": 0,
  "Đền Chùa": 0,
  "Lướt sóng": 0,
  "Thác Nước": 0,
  "Sân Bóng Đá": 0,
  "Trường Học": 0,
  "Đài Quan Sát": 0,
  "Khu Cắm Trại": 0,
  "Phòng Khiêu Vũ": 0,
  "Quảng Trường": 0,
  "Tour Trên Không": 0,
  "Tour Đi Thuyền": 0,
  "Tòa Thị Chính": 0,
  "Vườn/Hoa Viên": 0,
  "Điểm Tham Quan": 0,
  "Rạp Chiếu Phim": 0,
  "Sân Vận Động": 0,
  "Đài Phun Nước": 0,
  "Đảo/Bán Đảo": 0,
  "Công Viên Nước": 0,
  "Du Lịch Văn Hóa": 0,
  "Khu Nghỉ Dưỡng": 0,
  "Lặn ngoài trời": 0,
  "Ruộng Bậc Thang": 0,
  "Tham Quan Ban Đêm": 0,
  "Đền Thờ/Miếu": 0,
  "Di Tích Lịch Sử": 0,
  "Suối Nước Nóng": 0,
  "Vườn Bách Thảo": 0,
  "Lễ hội âm nhạc": 0,
  "Công Viên Quốc Gia": 0,
  "Khu Vui Chơi Trẻ Em": 0,
  "Nhà Thờ Hồi Giáo": 0,
  "Trung Tâm Giải Trí": 0,
  "Tượng/Điêu Khắc": 0,
  "Công Viên Chủ Đề": 0,
  "Công Viên Giải Trí": 0,
  "Nhà Tắm Công Cộng": 0,
  "Thành Cổ/Cổ Trấn": 0,
  "Đi Bộ Đường Dài": 0,
  "Công Viên Thành Phố": 0,
  "Khu Dân Cư Nổi Bật": 0,
  "Kiến Trúc Lịch Sử": 0,
  "Tour Ngắm Cảnh Khác": 0,
  "Công Trình Thủy Lợi": 0,
  "Thoát Khỏi Phòng Kín": 0,
  "Kiến Trúc Hiện Đại": 0,
  "Thể Thao Dưới Nước": 0,
  "Địa điểm nổi bật": 0,
  "Lớp Học DIY (Tự Làm)": 0,
  "Hoạt Động Với Nước": 0,
  "Khu Bảo Tồn Thiên Nhiên": 0,
  "Nhà Thờ & Thánh Đường": 0,
  "Đi Bộ Đường Dài/Đạp Xe": 0,
  "Buổi biểu diễn đặc trưng": 0,
  "Tượng Đài/Bia Tưởng Niệm": 0,
  "Địa Điểm Thờ Phụng Khác": 0,
  "Kỳ Quan Địa Chất/Địa Mạo": 0,
  "Nhà Máy/Xưởng Sản Xuất Rượu/Bia": 0,
  "Công trình của Kiến trúc sư nổi tiếng": 0,
  "Di Sản Thế Giới UNESCO - Di Sản Văn Hóa": 0
};

class PreferenceModel extends Preference {
  PreferenceModel(
      {required super.budget,
      required super.avgRating,
      required super.ratingCount,
      required super.prefsDF});

  factory PreferenceModel.fromJson(Map<String, dynamic> json) {
    return PreferenceModel(
      budget: json['budget'] ?? 0.0,
      avgRating: json['avg_rating'] ?? 0.0,
      ratingCount: json['rating_count'] ?? 0,
      prefsDF: json['prefs_df'] ?? travelPrefDf,
    );
  }

  static Map<String, double> generatePref({
    Map<String, double> initialPref = travelPrefDf,
    required List<TravelType> travelTypes,
    required double point,
  }) {
    // Create a modifiable copy of the initialPref
    final modifiablePref = Map<String, double>.from(initialPref);

    for (var type in travelTypes) {
      modifiablePref[type.name] = point;
    }
    return modifiablePref;
  }

  Map<String, dynamic> toJson() {
    return {
      'budget': budget,
      'avg_rating': avgRating,
      'rating_count': ratingCount,
      'prefs_df': prefsDF,
    };
  }

  PreferenceModel copyWith({
    double? budget,
    double? avgRating,
    int? ratingCount,
    Map<String, double>? prefsDF,
  }) {
    return PreferenceModel(
      budget: budget ?? this.budget,
      avgRating: avgRating ?? this.avgRating,
      ratingCount: ratingCount ?? this.ratingCount,
      prefsDF: prefsDF ?? this.prefsDF,
    );
  }
}
