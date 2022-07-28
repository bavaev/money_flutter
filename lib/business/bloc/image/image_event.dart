part of 'image_bloc.dart';

abstract class ImageEvent extends Equatable {
  const ImageEvent();
}

class ImageUpload extends ImageEvent {
  final String userId;
  final XFile image;

  const ImageUpload(this.userId, this.image);

  @override
  List<Object> get props => [userId, image];
}

class GetImage extends ImageEvent {
  @override
  List<Object> get props => [];
}
