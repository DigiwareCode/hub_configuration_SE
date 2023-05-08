import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'business_logic/services/http_hub_repository.dart';
import 'provider_manager/hub_manager.dart';

import 'navigation/app_router.dart';
import 'provider_manager/app_state_manager.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _hubRepository = HttpHubRepository.instance;

  late final AppStateManager _appStateManager;
  late final HubManager _hubManager;

  late final AppRouter _appRouter;

  @override
  void initState() {
    _hubManager = HubManager(_hubRepository);
    _appStateManager = AppStateManager(_hubManager);

    _appRouter = AppRouter(
      appStateManager: _appStateManager,
      hubSettingManager: _hubManager,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => _appStateManager),
        ChangeNotifierProvider(create: (_) => _hubManager),
      ],
      child: Consumer<AppStateManager>(
        builder: (_, __, ___) {
          return MaterialApp(
            title: "Hub App",
            debugShowCheckedModeBanner: false,
            home: Router(
              routerDelegate: _appRouter,
              backButtonDispatcher: RootBackButtonDispatcher(),
            ),
          );
        },
      ),
    );
  }
}
