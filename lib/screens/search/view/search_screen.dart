import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagram_clone/core/debounce_helper.dart';
import 'package:instagram_clone/core/routes.dart';
import 'package:instagram_clone/screens/search/bloc/search_bloc.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/common_widget.dart';
import 'package:loader_overlay/loader_overlay.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final dBounce = DeBouncerHelper(milliseconds: 900);

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      context.read<SearchBloc>().add(SearchFetchPostEvent());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              height: 50,
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  return TextField(
                    controller: context.read<SearchBloc>().searchController,
                    cursorColor: primaryColor,
                    style: GoogleFonts.roboto()
                        .copyWith(fontSize: 18, color: primaryColor),
                    onChanged: (value) {
                      dBounce.run(() {
                        if (value.isNotEmpty) {
                          context
                              .read<SearchBloc>()
                              .add(SearchUserQueryEvent(query: value));
                        }
                      });
                    },
                    onSubmitted: (value) {},
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.withOpacity(0.3),
                        contentPadding: const EdgeInsets.all(5),
                        hintText: "Search by username",
                        hintStyle: GoogleFonts.roboto().copyWith(
                            fontSize: 18, color: primaryColor.withOpacity(0.7)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: const BorderSide(color: Colors.grey)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: const BorderSide(color: Colors.grey)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: const BorderSide(color: Colors.grey)),
                        disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: const BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: const BorderSide(color: Colors.grey)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(13),
                            borderSide: const BorderSide(color: Colors.grey)),
                        suffixIcon: context
                                .read<SearchBloc>()
                                .searchController
                                .text
                                .isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  context
                                      .read<SearchBloc>()
                                      .add(SearchQueryClearEvent());
                                },
                                child: Icon(
                                  Icons.close,
                                  color: primaryColor.withOpacity(0.7),
                                  size: 30,
                                ),
                              )
                            : const SizedBox(),
                        prefixIcon: Icon(
                          Icons.search,
                          color: primaryColor.withOpacity(0.7),
                          size: 30,
                        )),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state.searchDataHolder.users.isNotEmpty &&
                    context
                        .read<SearchBloc>()
                        .searchController
                        .text
                        .isNotEmpty) {
                  return Expanded(
                      child: ListView.separated(
                          itemBuilder: (context, index) {
                            return const SizedBox(
                              height: 5,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return ListTile(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, Routes.profile, arguments: {
                                  "uid":
                                      state.searchDataHolder.users[index].uid ??
                                          ""
                                });
                              },
                              leading: CommonImageWidget(
                                imageUrl: state
                                    .searchDataHolder.users[index]?.photoUrl,
                                height: 45,
                                width: 45,
                              ),
                              title: Text(
                                state.searchDataHolder.users[index]?.username ??
                                    "",
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor),
                              ),
                              subtitle: Text(
                                state.searchDataHolder.users[index]?.bio ?? "",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    color: primaryColor.withOpacity(0.8)),
                              ),
                            );
                          },
                          itemCount: state.searchDataHolder.users.length));
                } else {
                  return Expanded(
                    child: StaggeredGridView.countBuilder(
                        crossAxisCount: 3,
                        itemCount: state.searchDataHolder.allPosts.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              CommonImageWidget(
                                imageUrl: state.searchDataHolder.allPosts[index]
                                        .postUrl?.first ??
                                    "",
                                radius: 5,
                              ),
                              if ((state.searchDataHolder.allPosts[index]
                                              .postUrl ??
                                          [])
                                      .length >
                                  1) ...[
                                Positioned(
                                    right: 5,
                                    top: 5,
                                    child: Container(
                                      height: 20,
                                      width: 20,
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color:
                                              secondaryColor.withOpacity(0.6),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                    )),
                                Positioned(
                                    right: 2,
                                    top: 9,
                                    child: Container(
                                      height: 20,
                                      width: 20,
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color:
                                              secondaryColor.withOpacity(0.5),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                    ))
                              ]
                            ],
                          );
                        },
                        staggeredTileBuilder: (index) => StaggeredTile.count(
                            (index % 5 == 0) ? 2 : 1,
                            (index % 5 == 0) ? 2 : 1)),
                  );
                }
              },
            ),
            BlocListener<SearchBloc, SearchState>(
              listener: (context, state) {
                if (state is SearchLoadingState) {
                  context.loaderOverlay.show();
                }
                if (state is SearchLoadedState) {
                  context.loaderOverlay.hide();
                }
                if (state is SearchErrorState) {
                  showToast(state.error);
                }
              },
              child: const SizedBox(),
            )
          ],
        ),
      )),
    );
  }
}
