import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:vote/blocobserver.dart';
import 'package:vote/cubit/student_cubit.dart';
import 'package:vote/cubit/vote_cubit.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );

  Bloc.observer = AppBlocObserver(showInfo: false);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          builder: (context, child) => ResponsiveBreakpoints.builder(
            child: child!,
            breakpoints: [
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1920, name: DESKTOP),
              const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
            ],
          ),
          debugShowCheckedModeBanner: false,
          title: 'School e-Voting System',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => VoteCubit(),
              ),
              BlocProvider(
                create: (context) => StudentCubit(),
              ),
            ],
            child: const MyHomePage(
              title:
                  'St. Paul\'s School, Rourkela (SPL & DSPL Election 2024-25)',
            ),
          ),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isVisible = true;

  AudioPlayer clickPlay = AudioPlayer();
  AudioPlayer thankyouPlay = AudioPlayer();
  AudioPlayer welcomePlay = AudioPlayer();

  @override
  initState() {
    audio();
    super.initState();
  }

  Future<void> audio() async {
    try {
      await clickPlay.setPlayerMode(PlayerMode.lowLatency);
      await thankyouPlay.setPlayerMode(PlayerMode.lowLatency);
      await welcomePlay.setPlayerMode(PlayerMode.lowLatency);

      await clickPlay.setSourceAsset("audio/click.mp3");
      await thankyouPlay.setSourceAsset("audio/thankyou.mp3");
      await welcomePlay.setSourceAsset("audio/welcome.mp3");
      // ignore: empty_catches
    } catch (e) {}
  }

  void playClick() async {
    await clickPlay.resume();
  }

  void playThankyou() async {
    await thankyouPlay.resume();
  }

  void playWelcome() async {
    await welcomePlay.resume();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VoteCubit, VoteState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Stack(
            alignment: Alignment.center,
            children: [
              const Image(
                image: AssetImage('assets/school.jpg'),
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
                alignment: Alignment.center,
              ),
              Positioned(
                top: 1.h,
                child: Visibility(
                  visible: isVisible,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        Text(
                          "CHOOSE ",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "ONE SPL CANDIDATE ",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple,
                          ),
                        ),
                        // Icon(
                        //   Icons.woman,
                        //   size: 48,
                        //   color: Colors.pinkAccent,
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 9.h,
                child: SizedBox(
                  height: 400,
                  width: 97.w,
                  child: Visibility(
                    visible: isVisible,
                    child: GridView.count(
                      // shrinkWrap: true,
                      // Create a grid with 2 columns. If you change the scrollDirection to
                      // horizontal, this produces 2 rows.
                      crossAxisCount:
                          state.candidateMap.where((c) => c.forSPL).length,
                      // Generate 100 widgets that display their index in the List.
                      children: List.generate(
                          state.candidateMap.where((c) => c.forSPL).length,
                          (index) {
                        String name = state.candidateMap
                            .where((c) => c.forSPL)
                            .elementAt(index)
                            .name;

                        bool clickValue = state.candidateMap
                            .where((c) => c.forSPL)
                            .elementAt(index)
                            .click;

                        bool hoverValue = state.candidateMap
                            .where((c) => c.forSPL)
                            .elementAt(index)
                            .hover;

                        String logo = state.candidateMap
                            .where((c) => c.forSPL)
                            .elementAt(index)
                            .logo;

                        bool isMale = state.candidateMap
                            .where((c) => c.forSPL)
                            .elementAt(index)
                            .isMale;

                        return GestureDetector(
                          onTap: () => context
                              .read<VoteCubit>()
                              .toggleClick(index, true),
                          child: MouseRegion(
                            onEnter: (e) => context
                                .read<VoteCubit>()
                                .toggleHover(index, true),
                            onExit: (e) => context
                                .read<VoteCubit>()
                                .toggleHover(index, true),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Opacity(
                                opacity: 0.95,
                                child: Card(
                                  color: clickValue || hoverValue
                                      ? isMale
                                          ? Colors.blueAccent
                                          : Colors.pinkAccent
                                      : Colors.blueGrey.shade100,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: EdgeInsets.all(
                                      hoverValue ? 15 : 20,
                                    ),
                                    child: Column(
                                      // mainAxisAlignment: AlignmentDirectional.topCenter,
                                      children: [
                                        ElevatedButton.icon(
                                          // onHover: (val) {
                                          //   context
                                          //       .read<VoteCubit>()
                                          //       .toggleHover(index, true);
                                          // },
                                          icon: (!isMale)
                                              ? Icon(
                                                  Icons.woman,
                                                  size: 14.sp,
                                                  color: Colors.pinkAccent,
                                                )
                                              : Icon(
                                                  Icons.man,
                                                  size: 14.sp,
                                                  color: Colors.blueAccent,
                                                ),
                                          onPressed: () {
                                            context
                                                .read<VoteCubit>()
                                                .toggleClick(index, true);
                                          },
                                          label: Text(
                                            name,
                                            style: TextStyle(
                                                color: (!isMale)
                                                    ? Colors.pinkAccent
                                                    : Colors.blueAccent,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Material(
                                          // needed
                                          color: Colors.transparent,
                                          child: InkWell(
                                            // onHover: (val) {
                                            //   context
                                            //       .read<VoteCubit>()
                                            //       .toggleHover(index, true);
                                            // },
                                            onTap: () {
                                              context
                                                  .read<VoteCubit>()
                                                  .toggleClick(index, true);
                                              // _incrementCounter(student[index]);
                                            }, // needed
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image(
                                                width: 20.h,
                                                height: 20.h,
                                                fit: BoxFit.cover,
                                                image:
                                                    AssetImage('assets/$logo'),
                                                alignment: Alignment.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 47.h,
                child: Visibility(
                  visible: isVisible,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        Text(
                          "CHOOSE ",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "ONE DSPL CANDIDATE ",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        // Icon(
                        //   Icons.man,
                        //   size: 48,
                        //   color: Colors.blueAccent,
                        // )
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 55.h,
                child: SizedBox(
                  height: 400,
                  width: 97.w,
                  child: Visibility(
                    visible: isVisible,
                    child: GridView.count(
                      // shrinkWrap: true,
                      // Create a grid with 2 columns. If you change the scrollDirection to
                      // horizontal, this produces 2 rows.
                      crossAxisCount: state.candidateMap
                          .where((c) => c.forSPL == false)
                          .length,
                      // Generate 100 widgets that display their index in the List.
                      children: List.generate(
                          state.candidateMap
                              .where((c) => c.forSPL == false)
                              .length, (index) {
                        String name = state.candidateMap
                            .where((c) => c.forSPL == false)
                            .elementAt(index)
                            .name;

                        bool clickValue = state.candidateMap
                            .where((c) => c.forSPL == false)
                            .elementAt(index)
                            .click;

                        bool hoverValue = state.candidateMap
                            .where((c) => c.forSPL == false)
                            .elementAt(index)
                            .hover;

                        String logo = state.candidateMap
                            .where((c) => c.forSPL == false)
                            .elementAt(index)
                            .logo;

                        bool isMale = state.candidateMap
                            .where((c) => c.forSPL == false)
                            .elementAt(index)
                            .isMale;

                        return GestureDetector(
                          onTap: () => context
                              .read<VoteCubit>()
                              .toggleClick(index, false),
                          child: MouseRegion(
                            onEnter: (e) => context
                                .read<VoteCubit>()
                                .toggleHover(index, false),
                            onExit: (e) => context
                                .read<VoteCubit>()
                                .toggleHover(index, false),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Opacity(
                                opacity: 0.95,
                                child: Card(
                                  color: clickValue || hoverValue
                                      ? isMale
                                          ? Colors.blueAccent
                                          : Colors.pinkAccent
                                      : Colors.blueGrey.shade100,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: EdgeInsets.all(
                                      hoverValue ? 15 : 20,
                                    ),
                                    child: Column(
                                      // mainAxisAlignment: AlignmentDirectional.topCenter,
                                      children: [
                                        ElevatedButton.icon(
                                          // onHover: (val) {
                                          //   context
                                          //       .read<VoteCubit>()
                                          //       .toggleHover(index, true);
                                          // },
                                          icon: (!isMale)
                                              ? Icon(
                                                  Icons.woman,
                                                  size: 14.sp,
                                                  color: Colors.pinkAccent,
                                                )
                                              : Icon(
                                                  Icons.man,
                                                  size: 14.sp,
                                                  color: Colors.blueAccent,
                                                ),
                                          onPressed: () {
                                            context
                                                .read<VoteCubit>()
                                                .toggleClick(index, false);
                                          },
                                          label: Text(
                                            name,
                                            style: TextStyle(
                                                color: (!isMale)
                                                    ? Colors.pinkAccent
                                                    : Colors.blueAccent,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Material(
                                          // needed
                                          color: Colors.transparent,
                                          child: InkWell(
                                            // onHover: (val) {
                                            //   context
                                            //       .read<VoteCubit>()
                                            //       .toggleHover(index, true);
                                            // },
                                            onTap: () {
                                              context
                                                  .read<VoteCubit>()
                                                  .toggleClick(index, false);
                                              // _incrementCounter(student[index]);
                                            }, // needed
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              child: Image(
                                                width: 20.h,
                                                height: 20.h,
                                                fit: BoxFit.cover,
                                                image:
                                                    AssetImage('assets/$logo'),
                                                alignment: Alignment.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => context.read<VoteCubit>().reset(),
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
