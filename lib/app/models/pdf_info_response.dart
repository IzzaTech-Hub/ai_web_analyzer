class PdfInfoResponse {
  final String title;
  final String author;
  final String subject;
  final String keywords;
  final String creator;
  final String producer;
  final int pageCount;
  final String textContent;
  final String fileSize;

  PdfInfoResponse({
    required this.title,
    required this.author,
    required this.subject,
    required this.keywords,
    required this.creator,
    required this.producer,
    required this.pageCount,
    required this.textContent,
    required this.fileSize,
  });
  factory PdfInfoResponse.fromJson(Map<String, dynamic> json) {
    return PdfInfoResponse(
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      subject: json['subject'] ?? '',
      keywords: json['keywords'] ?? '',
      creator: json['creator'] ?? '',
      producer: json['producer'] ?? '',
      pageCount: json['pageCount'] ?? 0,
      textContent: json['textContent'] ?? '',
      fileSize: json['fileSize'] ?? '',
    );
  }
  Map<String, dynamic> toJson() => {
        'title': title,
        'author': author,
        'subject': subject,
        'keywords': keywords,
        'creator': creator,
        'producer': producer,
        'pageCount': pageCount,
        'textContent': textContent,
        'fileSize': fileSize,
      };
}
