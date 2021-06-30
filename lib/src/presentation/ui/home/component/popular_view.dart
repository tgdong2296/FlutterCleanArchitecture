import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/gen/colors.gen.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_clean_architecture/src/domain/usecase/movie/fetch_movies_usecase.dart';
import 'package:flutter_clean_architecture/src/presentation/base/common_state_view.dart';
import 'package:flutter_clean_architecture/src/presentation/di/view_model_provider.dart';
import 'package:flutter_clean_architecture/src/presentation/model/movie_view_data_model.dart';
import 'package:flutter_clean_architecture/src/presentation/ui/home/component/movie_view_holder.dart';
import 'package:flutter_clean_architecture/src/presentation/ui/extension/build_context.dart';

class PopularView extends HookWidget {
  final Function(MovieViewDataModel) actionOpenMovie;
  final Function() actionLoadAll;

  const PopularView({
    Key? key,
    required this.actionOpenMovie,
    required this.actionLoadAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonStateView<List<MovieViewDataModel>>(
      value: useProvider(
          homeViewModelProvider.select((value) => value.popularMovies)),
      errorRetry: () {
        context.read(homeViewModelProvider).getMovieWithType(MovieType.popular, retry: true);
      },
      child: (movies) {
        return _createPopularView(context, movies);
      },
    );
  }

  Widget _createPopularView(
      BuildContext context, List<MovieViewDataModel> movies) {
    final contentHeight = 4.0 * (MediaQuery.of(context).size.width / 2.4) / 3;
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 20.0, right: 16.0),
          height: 48.0,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  context.res().popular,
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                    color: ColorName.groupTitleColor,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward, color: ColorName.groupTitleColor),
                onPressed: () {},
              )
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(0.0),
          height: contentHeight,
          child: ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return MovieViewHolder(movies[index], actionOpenMovie);
            },
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => const VerticalDivider(
              color: Colors.transparent,
              width: 6.0,
            ),
            itemCount: movies.length,
          ),
        ),
      ],
    );
  }
}
