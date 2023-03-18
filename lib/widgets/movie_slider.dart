import 'package:flutter/material.dart';
import 'package:flutter_curso_03_movies_app/models/models.dart';

class MovieSlider extends StatefulWidget {

  final String? tittle;
  final List<Movie> movies;
  final Function onNextPage;
   
  const MovieSlider({
    Key? key, 
    required this.movies,
    required this.onNextPage,
    this.tittle,
  }) : super(key: key);

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {

  final ScrollController scrollController = ScrollController();
  bool _getMoreData = false;


  @override
  void initState() {
    super.initState();
    scrollController.addListener( () async {
      if (!_getMoreData && (scrollController.position.pixels >= ( scrollController.position.maxScrollExtent -500 ))) {
        _getMoreData = true;
        widget.onNextPage();
        await Future.delayed(const Duration(seconds: 1));
      } else {
        _getMoreData = false;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [
          if (widget.tittle!=null) 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(widget.tittle!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
            ),
          const SizedBox(height: 5),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.movies.length,
              itemBuilder: (_, index) => _MoviePoster(movie: widget.movies[index], heroId: '${widget.tittle}-$index-${widget.movies[index].id}',)
            ),
          )
        ]
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {

  final Movie movie;
  final String heroId;
  
  const _MoviePoster({
    required this.movie,
    required this.heroId
  });

  @override
  Widget build(BuildContext context) {

    movie.heroId = heroId;

    return Container(
      width: 130,
      height: 190,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children:  [
          GestureDetector(
            onTap: ()=> Navigator.pushNamed(context, 'details', arguments: movie),
            child: Hero(
              tag: heroId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/no-image.jpg'), 
                  image: NetworkImage(movie.fullPosterImg),
                  width: 130,
                  height: 190,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5,),
          Text(
            movie.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}