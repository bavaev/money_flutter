import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:personal_accounting/data/storage.dart';

part 'image_event.dart';
part 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final RepositoryStorage repository;

  ImageBloc(this.repository) : super(ImageInitial()) {
    on<GetImage>((event, emit) async {
      emit(ImageInitial());
      await repository.getImageFromGallery();
      if (repository.image != null) {
        emit(GetImageGallery(repository.image));
      }
    });
    on<ImageUpload>((event, emit) async {
      emit(UploadAwait());
      String imageUrl = await repository.uploadImage(event.userId, event.image);
      if (repository.isLoading) {
        emit(ImageUploaded(imageUrl));
      }
    });
  }
}
