import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_show/tv_show_detail.dart';
import 'package:ditonton/domain/repositories/tv_show_repository.dart';

class TvShowSaveWatchlist {
  final TvShowRepository repository;

  TvShowSaveWatchlist(this.repository);

  Future<Either<Failure, String>> execute(TvShowDetail tvShowDetail) {
    return repository.saveWatchlist(tvShowDetail);
  }
}