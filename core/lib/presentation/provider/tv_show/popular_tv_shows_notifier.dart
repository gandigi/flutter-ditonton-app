import '../../../utils/state_enum.dart';
import '../../../domain/entities/tv_show/tv_show.dart';
import '../../../domain/usecases/tv_show/get_popular_tv_shows.dart';
import 'package:flutter/cupertino.dart';

class PopularTvShowsNotifier extends ChangeNotifier {
  final GetPopularTvShows getPopularTvShows;

  PopularTvShowsNotifier(this.getPopularTvShows);
  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<TvShow> _tvShows = [];
  List<TvShow> get tvShows => _tvShows;

  String _message = '';
  String get message => _message;

  Future<void> fetchPopularTvShows() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTvShows.execute();

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (tvShowData) {
        _tvShows = tvShowData;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}