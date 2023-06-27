class Books {
  final String id;
  final String title;
  final String writer;
  final String imagePath;
  final String description;
  final String language;
  final String publish;
  final int page;
  final int stock;

  Books({
    this.id = '',
    this.title = '',
    this.writer = '',
    this.imagePath = '',
    this.description = '',
    this.language = '',
    this.publish = '',
    this.page = 0,
    this.stock = 0,
  });

  factory Books.fromJson(Map<String, dynamic> json) {
    return Books(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      writer: json['writer'] ?? '',
      imagePath: json['image'] ?? '',
      description: json['description'] ?? '',
      language: json['lang'] == 'id' ? 'Indonesia' : '',
      publish: json['publish'] ?? '',
      page: json['total_page'] ?? 0,
      stock: json['stock'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'writer': writer,
        'stock': stock,
        'imagePath': imagePath,
      };
}
