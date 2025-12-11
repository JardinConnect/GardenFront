import 'package:flutter/material.dart';
import 'package:garden_connect/auth/models/user.dart';
import 'package:garden_connect/auth/utils/auth_extension.dart';
import 'package:garden_connect/settings/widgets/global_stat_card.dart';
import 'package:garden_ui/ui/components.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.currentUser;

    if (user == null) {
      return const Text('Utilisateur non connecté');
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsGeometry.directional(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GlobalStatCard(
                          title: "Total utilisateurs",
                          icon: Icons.group_outlined,
                          data: "8",
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GlobalStatCard(
                          title: "Total Cellules",
                          icon: Icons.sensors,
                          data: "28",
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GlobalStatCard(
                          title: "Total Espaces",
                          icon: Icons.hexagon_outlined,
                          data: "38",
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GlobalStatCard(
                          title: "Activités (24h)",
                          icon: Icons.bar_chart_outlined,
                          data: "840",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ParameterDisplaySection(),
                    ),
                  ),

                  Expanded(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GardenCard(
                            hasShadow: true,
                            hasBorder: true,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10.0,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.person_outline,
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                        size: 32,
                                      ),
                                      Text(
                                        "Mon Profil",
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.headlineSmall,
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Prenom : ",
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                    ),
                                    Text(
                                      "Gaethan",
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Nom : ",
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                    ),
                                    Text(
                                      user.username,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Email : ",
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                    ),
                                    Text(
                                      user.email,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Telephone : ",
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                    ),
                                    Text(
                                      "+33 683654823",
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Role : ",
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                    ),
                                    Text(
                                      user.isAdmin ? "Admin" : "Utilisateur",
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: UserListCard(),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LogCard(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserListCard extends StatelessWidget {
  const UserListCard({super.key});

  @override
  Widget build(BuildContext context) {
    final userList = List<User>.generate(
      8,
      (index) => User(
        id: index,
        email: "user$index@garden.com",
        username: "user$index",
        isAdmin: index % 3 == 0,
        token: null,
      ),
    );

    return GardenCard(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.group_outlined,
                      color: Theme.of(context).colorScheme.primary,
                      size: 32,
                    ),
                    Text(
                      "Utilisateurs",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsetsGeometry.directional(
                    top: 20,
                    start: 60,
                    end: 60,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Nom",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text("Email"),
                          Text("Status"),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsetsGeometry.directional(top: 8.0),
                        child: Column(
                          children: [
                            for (final user in userList)
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      user.username,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    Text(
                                      user.email,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    Text(
                                      user.isAdmin ? 'Admin' : 'Utilisateur',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LogCard extends StatefulWidget {
  const LogCard({super.key});

  @override
  State<LogCard> createState() => _LogCardState();
}

class _LogCardState extends State<LogCard> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logs = [
      "Gaëtan se_connecte au_portail",
      "Fanny pairing capteur#23",
      "Marie modifie Alerte-12",
      "Guy consulte Espace_2",
      "Gaëtan synchronise Capteurs",
      'Fanny met_à_jour le_tableau_de_bord',
      'Fanny supprime Zone_Sud',
      'Fanny réactive capteur#02',
      'Gaëtan désactive capteur#01',
      'Marie associe le_capteur#03 à Zone_B',
      'Marie dissocie le_capteur#02 à Zone_A',
      'Fanny exporte dashboard',
      "Marie télécharge le_rapport_mensuel",
      'Fanny affiche le_statut_des_capteurs',
      'Marie duplique le_plan_standard',
      'Fanny ajoute_surveillance capteur#12',
      'Fanny synchronise Capteurs',
      'Guy ajoute alerte_gel_nocturne',
    ];

    return GardenCard(
      child: SizedBox(
        height: 400,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.bar_chart,
                    color: Theme.of(context).colorScheme.primary,
                    size: 32,
                  ),
                  Text(
                    "Dernieres Activites",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              Expanded(
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Padding(
                      padding: const EdgeInsetsGeometry.directional(
                        top: 20,
                        start: 60,
                        end: 60,
                      ),
                      child: Column(
                        children: [
                          for (final log in logs)
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  log,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontStyle: Theme.of(context).textTheme.bodyMedium?.fontStyle
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
            ],
          ),
        ),
      ),
    );
  }
}

/// Parameter display moved inline for easier API integration.
/// Renamed to ParameterDisplaySection to avoid duplicate symbols.
class ParameterDisplaySection extends StatefulWidget {
  const ParameterDisplaySection({
    super.key,
    this.categories,
    this.categoriesFuture,
    this.initialValues,
    this.onChanged,
    this.onSave,
  });

  final List<ParameterCategory>? categories;
  final Future<List<ParameterCategory>>? categoriesFuture;
  final Map<String, Map<String, bool>>? initialValues;
  final ValueChanged<Map<String, Map<String, bool>>>? onChanged;
  final Future<void> Function(Map<String, Map<String, bool>> values)? onSave;

  @override
  State<ParameterDisplaySection> createState() =>
      _ParameterDisplaySectionState();
}

class _ParameterDisplaySectionState extends State<ParameterDisplaySection> {
  late List<ParameterCategory> _categories;
  final Map<String, Map<String, bool>> _values = {};
  bool _loadingSave = false;

  List<ParameterCategory> get _fallbackCategories => [
    ParameterCategory(
      id: 'general',
      title: 'Général',
      items: [
        ParameterItem(
          id: 'help_tooltips',
          label: 'Afficher les bulles d’aide contextuelles',
          defaultValue: true
        ),
        ParameterItem(
          id: 'show_offline_cells',
          label: 'Afficher les cellules déconnectées',
        ),
        ParameterItem(
          id: 'show_thresholds',
          label: 'Afficher les seuils d’alerte sur les graphiques',
            defaultValue: true
        ),
        ParameterItem(id: 'show_units', label: 'Afficher les unités de mesure'),
      ],
    ),
    ParameterCategory(
      id: 'notifications',
      title: 'Notifications et alertes',
      items: [
        ParameterItem(
          id: 'allow_alert_edit',
          label: 'Autoriser la modification des alertes',
            defaultValue: true
        ),
        ParameterItem(
          id: 'confirm_before_delete_alert',
          label: 'Demander une confirmation avant suppression',
        ),
        ParameterItem(
          id: 'night_silent_mode',
          label: 'Mode silencieux nocturne',
        ),
      ],
    ),
    ParameterCategory(
      id: 'nodes',
      title: 'Gestion des cellules',
      items: [
        ParameterItem(
          id: 'allow_rename_node',
          label: 'Autoriser le renommage des cellules',
        ),
        ParameterItem(
          id: 'allow_delete_node',
          label: 'Autoriser la suppression d’une cellule',
        ),
        ParameterItem(
          id: 'allow_move_node',
          label: 'Autoriser le déplacement d’une cellule',
            defaultValue: true
        ),
        ParameterItem(
          id: 'confirm_before_delete_node',
          label: 'Demander une confirmation avant suppression',
            defaultValue: true
        ),
        ParameterItem(
          id: 'show_battery',
          label: 'Afficher le niveau de batterie des cellules',
        ),
        ParameterItem(
          id: 'node_show_units',
          label: 'Afficher les unités de mesure',
        ),
      ],
    ),
    ParameterCategory(
      id: 'spaces',
      title: 'Gestion des espaces',
      items: [
        ParameterItem(
          id: 'show_empty_spaces',
          label: 'Afficher les espaces sans données',
        ),
        ParameterItem(
          id: 'allow_delete_space',
          label: 'Autoriser la suppression d’un espace',
        ),
        ParameterItem(
          id: 'allow_move_space',
          label: 'Autoriser le déplacement d’un espace',
            defaultValue: true
        ),
        ParameterItem(
          id: 'confirm_before_delete_space',
          label: 'Demander une confirmation avant suppression',
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _categories = widget.categories ?? _fallbackCategories;

    if (widget.initialValues != null) {
      for (final entry in widget.initialValues!.entries) {
        _values[entry.key] = Map.from(entry.value);
      }
    }

    _ensureValuesForCategories(_categories);
  }

  void _ensureValuesForCategories(List<ParameterCategory> categories) {
    for (final c in categories) {
      _values.putIfAbsent(c.id, () => {});
      for (final p in c.items) {
        _values[c.id]!.putIfAbsent(p.id, () => p.defaultValue);
      }
    }
  }

  void _onToggle(String categoryId, String paramId, bool value) {
    setState(() {
      _values[categoryId]![paramId] = value;
    });
    widget.onChanged?.call(_deepCopy(_values));
  }

  Map<String, Map<String, bool>> _deepCopy(Map<String, Map<String, bool>> src) {
    return {
      for (final e in src.entries) e.key: Map<String, bool>.from(e.value),
    };
  }

  Future<void> _onSavePressed() async {
    if (widget.onSave == null) return;
    setState(() => _loadingSave = true);
    try {
      await widget.onSave!(_deepCopy(_values));
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Paramètres enregistrés')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    } finally {
      if (mounted) setState(() => _loadingSave = false);
    }
  }

  Widget _buildCard(List<ParameterCategory> categories) {
    _ensureValuesForCategories(categories);

    return GardenCard(
      hasShadow: true,
      hasBorder: true,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.settings_outlined),
                const SizedBox(width: 8),
                const Text('Paramètres', style: TextStyle(fontSize: 18)),
                const Spacer(),
                if (widget.onSave != null)
                  IconButton(
                    icon:
                        _loadingSave
                            ? const CircularProgressIndicator()
                            : const Icon(Icons.save_outlined),
                    onPressed: _loadingSave ? null : _onSavePressed,
                  ),
              ],
            ),
            const SizedBox(height: 10),
            for (final category in categories)
              ExpansionTile(
                initiallyExpanded: true,
                shape: const Border(),
                title: Row(
                  children: [
                    Text(category.title, style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
                children: [Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child:

                Column(
                  children: [
                    for (final param in category.items)
                      CheckboxListTile(
                        value: _values[category.id]![param.id]!,
                        onChanged:
                            (v) => _onToggle(category.id, param.id, v ?? false),
                        title: Text(
                          param.label,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                  ],
                ),)],
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.categoriesFuture != null) {
      return FutureBuilder<List<ParameterCategory>>(
        future: widget.categoriesFuture,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return GardenCard(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('Erreur: ${snap.error}'),
              ),
            );
          }
          final categories = snap.data ?? _fallbackCategories;
          return _buildCard(categories);
        },
      );
    }

    return _buildCard(_categories);
  }
}

class ParameterItem {
  final String id;
  final String label;
  final bool defaultValue;

  ParameterItem({
    required this.id,
    required this.label,
    this.defaultValue = false,
  });
}

class ParameterCategory {
  final String id;
  final String title;
  final List<ParameterItem> items;

  ParameterCategory({
    required this.id,
    required this.title,
    required this.items,
  });
}
