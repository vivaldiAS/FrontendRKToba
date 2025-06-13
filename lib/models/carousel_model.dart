class CarouselModel {
  final int id;
  final String carouselImage;
  final String? linkCarousel;
  final int openInNewTab;

  CarouselModel({
    required this.id,
    required this.carouselImage,
    this.linkCarousel,
    required this.openInNewTab,
  });

  factory CarouselModel.fromJson(Map<String, dynamic> json) {
    return CarouselModel(
      id: json['id'],
      carouselImage: json['carousel_image'],
      linkCarousel: json['link_carousel'],
      openInNewTab: json['open_in_new_tab'],
    );
  }
}
