class ChatDetail {
  final String role;
  final String message;
  final String time;

  ChatDetail({
    required this.role,
    required this.message,
    String? time,
  }) : time = time ?? DateTime.now().toIso8601String();

  factory ChatDetail.fromJson(Map<String, dynamic> json) {
    return ChatDetail(
      role: json['role'],
      message: json['message'],
      time: json['time'] ?? DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() => {
        'role': role,
        'message': message,
        'time': time,
      };
}

class Dosen {
  final int id;
  final String name;
  final String img;
  final List<ChatDetail> details;
  int unreadCount;

  Dosen({
    required this.id,
    required this.name,
    required this.img,
    required this.details,
    this.unreadCount = 0,
  });

  factory Dosen.fromJson(Map<String, dynamic> json) {
    // parsing detail chat
    List<ChatDetail> detailsList = (json['details'] as List).map((e) {
      return ChatDetail.fromJson(e);
    }).toList();

    // hitung jumlah pesan dosen yang belum dibalas
    int unread = 0;
    for (int i = detailsList.length - 1; i >= 0; i--) {
      if (detailsList[i].role == "dosen") {
        unread++;
      } else {
        break;
      }
    }

    return Dosen(
      id: json['id'],
      name: json['name'],
      img: json['img'],
      details: detailsList,
      unreadCount: json['unreadCount'] ?? unread,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'img': img,
        'details': details.map((e) => e.toJson()).toList(),
        'unreadCount': unreadCount,
      };
}


class DataSaya {
  static String nama = "siti aisyah";

  static String gambar =
      "assets/mahasiswa/aisyah.jpeg";

  // Tambahkan daftar dosen sebagai shared memory
  static List<Dosen> semuaDosen =[];
}
