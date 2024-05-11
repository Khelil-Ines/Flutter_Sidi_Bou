import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:sidi_bou/HomeScreen.dart';
import 'package:sidi_bou/core/Config.dart';
import 'package:sidi_bou/manager/lang_cubit.dart';
import 'package:sidi_bou/settings/set_account.dart';
import 'package:sidi_bou/widgets/forward_button.dart';
import 'package:sidi_bou/widgets/setting_item.dart';
import 'package:sidi_bou/widgets/setting_switch.dart';
import 'package:sidi_bou/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    ThemeProvider _themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = _themeProvider.currentTheme == ThemeEnum.Dark;

    return BlocBuilder<LangCubit, LangState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
              icon: const Icon(Ionicons.chevron_back_outline),
            ),
            leadingWidth: 80,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Config.Localization["settings"],
                    style: const TextStyle(
                        fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    Config.Localization["account"],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SettingItem(
                    title: Config.Localization["yourAcc"],
                    icon: Ionicons.person,
                    bgColor: Colors.blue.shade100,
                    iconColor: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SetAccount(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    Config.Localization["general"],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SettingItem(
                    title: Config.Localization["lang"],
                    icon: Ionicons.earth,
                    bgColor: Colors.orange.shade100,
                    iconColor: Colors.orange,
                    value: Config.Localization["language"],
                    onTap: () {
                      context.read<LangCubit>().ChangeLang();
                    },
                  ),
                  const SizedBox(height: 20),
                  SettingSwitch(
                    title: Config.Localization["dark"],
                    icon: _themeProvider.currentTheme == ThemeEnum.Light
                        ? Ionicons.sunny
                        : Ionicons.moon,
                    bgColor: Colors.purple.shade100,
                    iconColor: Colors.purple,
                    value: isDarkMode,
                    onTap: (value) {
                      if (value) {
                        _themeProvider.changeTheme(ThemeEnum.Dark);
                      } else {
                        _themeProvider.changeTheme(ThemeEnum.Light);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  SettingItem(
                    title: Config.Localization["help"],
                    icon: Ionicons.nuclear,
                    bgColor: Colors.red.shade100,
                    iconColor: Colors.red,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
