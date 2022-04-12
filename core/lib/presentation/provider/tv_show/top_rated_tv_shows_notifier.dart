import '../../../utils/state_enum.dart';
import '../../../domain/entities/tv_show/tv_show.dart';
import '../../../domain/usecases/tv_show/get_top_rated_tv_shows.dart';
import 'package:flutter/cupertino.dart';

class TopRatedTvShowsNotifier extends ChangeNotifier {
  final GetTopRatedTvShows getTopRatedTvShows;

  TopRatedTvShowsNotifier({required this.getTopRatedTvShows});
  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<TvShow> _tvShows = [];
  List<TvShow> get tvShows => _tvShows;

  String _message = '';
  String get message => _message;

  Future<void> fetchTopRatedTvShows() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTvShows.execute();

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