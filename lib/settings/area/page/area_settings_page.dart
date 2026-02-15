import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_ui/ui/foundation/color/color_design_system.dart';
import 'package:garden_ui/ui/foundation/typography/typography_design_system.dart';
import 'package:go_router/go_router.dart';

import '../../../areas/bloc/area_bloc.dart';
import '../../../areas/models/area.dart';
import '../../../auth/utils/auth_extension.dart';
import '../../../common/widgets/global_stat_card_widget.dart';
import '../../../common/widgets/generic_list_item.dart';

class AreaSettingsPage extends StatefulWidget {
  const AreaSettingsPage({Key? key}) : super(key: key);

  @override
  State<AreaSettingsPage> createState() => _AreaSettingsPageState();
}

class _AreaSettingsPageState extends State<AreaSettingsPage> {
  int? _selectedLevel;

  _onSearch(BuildContext context, String text) {
    context.read<AreaBloc>().add(SearchAreas(search: text));
  }

  void _onLevelSelected(int level) {
    setState(() {
      // Si on clique sur le même niveau, on le désélectionne
      _selectedLevel = _selectedLevel == level ? null : level;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.currentUser;
    if (user == null) {
      return const Text('Utilisateur non connecté');
    }

    return BlocProvider(
      create: (context) => AreaBloc()..add(LoadAreas()),
      child: Builder(
        builder: (context) {
          final areaState = context.watch<AreaBloc>().state;

          if (areaState is AreasLoaded) {
            final areasByLevel = Area.countAreasByLevel(areaState.areas);

            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Bonjour ${user.firstName}',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        IconButton.filled(
                          icon: const Icon(Icons.add),
                          style: IconButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            context.go('/settings/areas/add');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ...areasByLevel.entries.map(
                          (entry) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () => _onLevelSelected(entry.key),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: _selectedLevel == entry.key
                                        ? Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            width: 1,
                                          )
                                        : null,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: GlobalStatCardWidget(
                                    title: 'Niveau ${entry.key}',
                                    icon: Icons.location_on,
                                    data: '${entry.value}',
                                    level: entry.key,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      onChanged: (text) => _onSearch(context, text),
                      decoration: InputDecoration(
                        hintText: 'Rechercher',
                        prefixIcon: Icon(Icons.search),
                        hintStyle: GardenTypography.bodyLg.copyWith(
                          color: GardenColors.typography.shade200,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView(
                        children:
                            areasByLevel.entries
                                .where((entry) =>
                                    _selectedLevel == null ||
                                    entry.key == _selectedLevel)
                                .map((entry) {
                              final level = entry.key;
                              final areasForLevel =
                                  areaState.filteredAreas
                                      .where((area) => area.level == level)
                                      .toList();

                              // Si aucune zone pour ce niveau, ne rien afficher
                              if (areasForLevel.isEmpty) {
                                return const SizedBox.shrink();
                              }

                              for (var area in areasForLevel) {
                                debugPrint(
                                  'Area: ${area.name}, niveau: ${area.level}',
                                );
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),

                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.hexagon_outlined,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                          size: 32,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Niveau $level',
                                          style: GardenTypography.headingSm,
                                        ),
                                      ],
                                    ),
                                  ),
                                  GenericListWidget(
                                    items:
                                        areasForLevel.map((area) {
                                          return GenericListItem(
                                            label: area.name,
                                            icon: Icons.edit,
                                            onTap: () {
                                              // Clic sur la ligne -> mode vue
                                              context.go(
                                                '/settings/areas/${area.id}?pages=true',
                                              );
                                            },
                                            onEdit: () {
                                              // Clic sur l'icône -> mode édition
                                              context.go(
                                                '/settings/areas/${area.id}',
                                              );
                                            },
                                          );
                                        }).toList(),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              );
                            }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
