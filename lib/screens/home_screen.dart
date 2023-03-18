import 'package:flutter/material.dart';
import 'package:flutter_curso_03_movies_app/providers/movies_provider.dart';
import 'package:flutter_curso_03_movies_app/search/movie_search_delegate.dart';
import 'package:provider/provider.dart';

import '../widgets/widgets.dart';


class HomeScreen extends StatelessWidget {
   
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar:  AppBar(
        title: const Text('Movies on Theater'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: MovieSearchDelegate()
              );
            }, 
            icon: const Icon(Icons.search_outlined)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CardSwipe(movies: moviesProvider.onDisplayMovies),
            MovieSlider(
              movies: moviesProvider.popularMovies,
              tittle: 'Popular\'s',
              onNextPage: () => moviesProvider.getPopularMovies(),
            )
          ]
        ),
      ),
    );
  }
}