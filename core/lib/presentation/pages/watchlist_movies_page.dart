import 'package:core/core.dart';
import 'package:core/utils/utils.dart';
import '../../presentation/provider/movie/watchlist_movie_notifier.dart';
import '../../presentation/provider/tv_show/watchlist_tv_show_notifier.dart';
import '../../presentation/widgets/movie_card_list.dart';
import '../../presentation/widgets/tv_show_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware, SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    Future.microtask(() =>
        Provider.of<WatchlistMovieNotifier>(context, listen: false)
            .fetchWatchlistMovies());
    Future.microtask(() =>
        Provider.of<WatchlistTvShowNotifier>(context, listen: false)
            .fetchWatchlistTvShows());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    Provider.of<WatchlistMovieNotifier>(context, listen: false)
        .fetchWatchlistMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Watchlist'),
          bottom: TabBar(
            tabs: [
              const Tab(text: 'Movie'),
              const Tab(text: 'Tv Show'),
            ],
            controller: controller,
          ),
        ),
        body: TabBarView(
          controller: controller,
          children: [
            _movieWatchlistSection(),
            _tvShowsWatchlistSection(),
          ],
        ));
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  Widget _movieWatchlistSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer<WatchlistMovieNotifier>(
        builder: (context, data, child) {
          if (data.watchlistState == RequestState.Loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (data.watchlistState == RequestState.Loaded) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final movie = data.watchlistMovies[index];
                return MovieCard(movie);
              },
              itemCount: data.watchlistMovies.length,
            );
          } else {
            return Center(
              key: const Key('error_message'),
              child: Text(data.message),
            );
          }
        },
      ),
    );
  }

  Widget _tvShowsWatchlistSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer<WatchlistTvShowNotifier>(
        builder: (context, data, child) {
          if (data.watchlistState == RequestState.Loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (data.watchlistState == RequestState.Loaded) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final tvShow = data.watchlistTvshows[index];
                return TvShowCard(tvShow);
              },
              itemCount: data.watchlistTvshows.length,
            );
          } else {
            return Center(
              key: const Key('error_message'),
              child: Text(data.message),
            );
          }
        },
      ),
    );
  }
}
