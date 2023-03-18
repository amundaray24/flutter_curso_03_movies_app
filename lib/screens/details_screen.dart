import 'package:flutter/material.dart';
import 'package:flutter_curso_03_movies_app/models/movie.dart';
import 'package:flutter_curso_03_movies_app/widgets/widgets.dart';

class DetailsScreen extends StatelessWidget {
   
  const DetailsScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _CustomAppBar(
            tittle: movie.title,
            image: movie.fullBackdropPath,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _PosterAndTittle(movie: movie),
              _OverView(overViewText: movie.overview),
              CastingCards(movieId: movie.id)
            ])
          )
        ],
      )
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  
  final String tittle;
  final String image;

  const _CustomAppBar({
    required this.tittle, 
    required this.image
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.all(0),
        title: Container(
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 10),
          color: Colors.black12,
          child: Text(
            tittle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          )
        ),
        background: FadeInImage(
          placeholder: const AssetImage('assets/loading.gif'), 
          image: NetworkImage(image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _PosterAndTittle extends StatelessWidget {

  final Movie movie;
  
  const _PosterAndTittle({
    required this.movie
  });

  @override
  Widget build(BuildContext context) {
    
    final TextTheme theme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'), 
                image: NetworkImage(movie.fullPosterImg),
                height: 150,
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title, 
                  style: theme.headlineSmall, 
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Text(
                  movie.originalTitle, 
                  style: theme.bodyMedium, 
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Row(
                  children: [
                    const Icon(Icons.star_border_outlined, size: 15, color: Colors.grey),
                    const SizedBox(width: 5,),
                    Text(
                      movie.voteAverage.toString(),
                      style: theme.bodySmall, 
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _OverView extends StatelessWidget {
  
  final String overViewText;
  
  const _OverView({
    required this.overViewText
  });

  @override
  Widget build(BuildContext context) {

    final TextTheme theme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(
        overViewText,
        textAlign: TextAlign.justify,
        style: theme.titleMedium,
      ),
    );
  }
}