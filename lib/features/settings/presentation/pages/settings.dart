import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vn_travel_companion/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:vn_travel_companion/core/theme/theme_provider.dart';
import 'package:vn_travel_companion/core/utils/show_snackbar.dart';
import 'package:vn_travel_companion/features/auth/presentation/bloc/auth_bloc.dart';

class SettingsPage extends StatelessWidget {
  static route() {
    return MaterialPageRoute(builder: (context) => const SettingsPage());
  }

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, notifier, child) {
      return BlocConsumer<AppUserCubit, AppUserState>(
        listener: (context, state) {
          if (state is AppUserNotLoggedIn) {
            showSnackbar(context, 'Đăng xuất thành công');
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              _box(
                  title: "Application Theme",
                  subtitle: notifier.isDarkMode ? "Dark Theme" : "Light Theme",
                  leading: Icons.color_lens,
                  context: context),
              _box(
                  title: "Language",
                  subtitle: "English",
                  leading: Icons.language,
                  context: context),
              _box(
                  title: "Settings",
                  subtitle: "System configurations",
                  leading: Icons.settings,
                  context: context),
              _box(
                  title: "Full Name",
                  subtitle: (state is AppUserLoggedIn)
                      ? '${state.user.firstName} ${state.user.lastName}'
                      : "Companion",
                  leading: Icons.settings,
                  context: context),
              _box(
                  title: "Email",
                  subtitle: (state is AppUserLoggedIn)
                      ? state.user.email
                      : "companion@gmail.com",
                  leading: Icons.settings,
                  context: context),
              const SizedBox(height: 15),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * .95,
                height: 60,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                            Theme.of(context).colorScheme.primaryContainer),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)))),
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthLogout());
                    },
                    child: Text(
                      "Đăng xuất",
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer),
                    )),
              )
            ],
          );
        },
      );
    });
  }

  Widget _box({required title, required subtitle, required leading, context}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      height: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.surfaceContainerHigh),
      child: ListTile(
        leading: Icon(leading, size: 30),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
      ),
    );
  }
}
