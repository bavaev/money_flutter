part of 'image_bloc.dart';

abstract class ImageState extends Equatable {
  const ImageState();
}

class ImageInitial extends ImageState {
  @override
  List<Object> get props => [];
}

class GetImageGallery extends ImageState {
  final XFile? image;

  const GetImageGallery(this.image);

  @override
  List<XFile?> get props => [image];
}

class UploadAwait extends ImageState {
  @override
  List<Object> get props => [];
}

class ImageUploaded extends ImageState {
  final String imageUrl;

  const ImageUploaded(this.imageUrl);

  @override
  List<String> get props => [imageUrl];
}
