import 'package:flutter/material.dart';
import 'package:flutter_curso_03_movies_app/providers/movies_provider.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';


class CastingCards extends StatelessWidget {

  final int movieId;

  const CastingCards({
    super.key,
    required this.movieId
  });

  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context,listen: false);

    return FutureBuilder(
      future: moviesProvider.getMovieCast(movieId),
      builder: (_, AsyncSnapshot<List<Cast>> asyncSnapshot) {

        if (!asyncSnapshot.hasData) {
          return Container(
            margin: const EdgeInsets.only(bottom: 30),
            width: double.infinity,
            height: 180,  
            child: const CircularProgressIndicator(),
          );
        }

        final List<Cast> cast = asyncSnapshot.data!;

        return Container(
          margin: const EdgeInsets.only(bottom: 30),
          width: double.infinity,
          height: 210,
          child: ListView.builder(
            itemCount: cast.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_,index) => _CastCard(cast: cast[index])
          ),
        );
      },
    );
  }
}

class _CastCard extends StatelessWidget {

  final Cast cast;
 
  const _CastCard({
    required this.cast
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 110,
      height: 100,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              height: 170,
              placeholder: const AssetImage('assets/no-image.jpg'),
              image: NetworkImage(cast.fullProfilePath),
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 5,),
          Text(
            cast.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}