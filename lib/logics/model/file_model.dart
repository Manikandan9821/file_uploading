class FileModel {
  final int id;
  final String fileName;
  final String fileUrl;

  FileModel({this.id, this.fileName, this.fileUrl});

  factory FileModel.fromMap(Map<String, dynamic> json) => FileModel(
        id: json['id'],
        fileName: json['fileName'],
        fileUrl: json['fileUrl'],
      );

  Map<String, dynamic> toJson() => {
        'fileName': fileName,
        'fileUrl': fileUrl,
      };
}
