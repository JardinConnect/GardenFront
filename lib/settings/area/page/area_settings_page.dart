import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:garden_ui/ui/design_system.dart';
import 'package:go_router/go_router.dart';

import '../../../areas/bloc/area_bloc.dart';
import '../../../areas/models/area.dart';
import '../../../auth/utils/auth_extension.dart';
import '../../../common/widgets/global_stat_card_widget.dart';
import '../../../common/widgets/generic_list_item.dart';
 import '../../../common/widgets/page_header.dart';

class _LevelCard extends StatefulWidget {
  final int level;
  final int count;
  final bool isSelected;
  final VoidCallback onTap;

  const _LevelCard({
    required this.level,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_LevelCard> createState() => _LevelCardState();
}

class _LevelCardState extends State<_LevelCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            boxShadow: _hovered ? GardenShadow.shadowMd : null,
            border: widget.isSelected
                ? Border.all(color: primary, width: 1)
                : null,
            borderRadius: GardenRadius.radiusSm,
          ),
          child: GlobalStatCardWidget(
            title: 'Niveau ${widget.level}',
            icon: Icons.location_on,
            data: '${widget.count}',
            level: widget.level,
          ),
        ),
      ),
    );
  }
}

class AreaSettingsPage extends StatefulWidget {
  const AreaSettingsPage({super.key});

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

    // Recharger les areas à chaque affichage de la page

    return Builder(
        builder: (context) {
          final areaState = context.watch<AreaBloc>().state;

          if (areaState is AreasLoaded) {
            final areasByLevel = Area.countAreasByLevel(areaState.areas);

            return Scaffold(
              body: Padding(
                padding: EdgeInsets.all(GardenSpace.paddingMd),
                child: Column(
                  children: [
                    PageHeader(
                      title: 'Bonjour ${user.firstName}',
                      actions: [
                        IconButton.filled(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            context.go('/settings/areas/add');
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        ...areasByLevel.entries.map(
                          (entry) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: _LevelCard(
                                level: entry.key,
                                count: entry.value,
                                isSelected: _selectedLevel == entry.key,
                                onTap: () => _onLevelSelected(entry.key),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: GardenSpace.gapMd),
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
                    SizedBox(height: GardenSpace.gapMd),
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
                                        SizedBox(width: GardenSpace.gapSm),
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
                                                '/settings/areas/${area.id}?view=true',
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
                                  SizedBox(height: GardenSpace.gapMd),
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
    );
  }
}
