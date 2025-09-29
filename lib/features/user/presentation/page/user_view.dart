import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_call_app/features/user/presentation/bloc/users_cubit.dart';
import 'package:video_call_app/features/user/presentation/bloc/users_state.dart';
import 'package:video_call_app/service_locator.dart';

class UserView extends StatefulWidget {
  const UserView({super.key});

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Users")),
      body: BlocProvider(
        create: (_) => sl<UsersCubit>()..users(),
        child: BlocBuilder<UsersCubit, UsersState>(
          builder: (context, state) {
            switch (state) {
              case UsersInitialState():
                return SizedBox.shrink();
              case UsersLoadingState():
                return Center(child: CircularProgressIndicator());
              case UsersSuccessState():
                return RefreshIndicator(
                  onRefresh: () async {
                    await context.read<UsersCubit>().users();
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: state.usersList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, index) {
                      final user = state.usersList[index];
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(10),
                              ),
                              child: CachedNetworkImage(
                                height: 100,
                                width: 100,
                                imageUrl: "${user.avatar}",
                                fit: BoxFit.cover,
                                fadeInDuration: const Duration(
                                  milliseconds: 300,
                                ),
                                placeholder: (context, url) => const Center(
                                  child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                    ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Text(
                                  "${user.firstName} ${user.lastName}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow
                                      .ellipsis, // ✅ prevents overflow
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );

              case UsersFailureState():
                return Center(
                  child: SizedBox.shrink(child: Text(state.message)),
                );
            }
          },
        ),
      ),
    );
  }
}
