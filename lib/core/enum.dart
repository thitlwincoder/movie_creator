enum FileType {
  asset,
  file;

  bool get isAsset => this == asset;
  bool get isFile => this == file;
}
