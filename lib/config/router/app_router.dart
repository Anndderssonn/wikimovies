import 'package:go_router/go_router.dart';
import 'package:wiki_movies/presentation/screens/screens.dart';
import 'package:wiki_movies/presentation/views/views.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return HomeScreen(navigationShell: navigationShell);
      },
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/',
              builder: (context, state) => const HomeView(),
              routes: <RouteBase>[
                GoRoute(
                  path: 'movie/:id',
                  name: MovieDetailScreen.name,
                  builder: (context, state) {
                    final movieID = state.pathParameters['id'] ?? 'no-id';
                    return MovieDetailScreen(movieID: movieID);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/categories',
              builder: (context, state) => const CategoriesView(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/favorites',
              builder: (context, state) => const FavoritesView(),
            ),
          ],
        ),
      ],
    ),
  ],
);
