import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unreal_remote_control/state/remote_control.dart';
import 'package:unreal_remote_control/state/selected_preset_group_field.dart';
import 'package:unreal_remote_control/ui/preset_group_field_overview.dart';
import 'package:unreal_remote_control/ui/preset_group_tile.dart';

class PresetOverview extends StatelessWidget {
  const PresetOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final (groups, selectedField) = context.select(
      (RemoteControl rc) => (
        rc.state.presetGroups,
        rc.state.selectedPresetGroupField,
      ),
    );

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: groups.length,
                  itemBuilder: (_, i) {
                    final group = groups[i];

                    return ExpansionTile(
                      title: Text(group.name),
                      children: [
                        ExpansionTile(
                          title: const Text('Properties'),
                          children: group.exposedProperties.map((property) {
                            return PresetGroupTile(
                              title: property.displayName,
                              isSelected: selectedField is SelectedProperty && selectedField.property == property,
                              onTap: () => context.read<RemoteControl>().selectExposedProperty(property),
                            );
                          }).toList(),
                        ),
                        if (group.exposedFunctions.isNotEmpty)
                          ExpansionTile(
                            title: const Text('Functions'),
                            children: group.exposedFunctions.map((function) {
                              return PresetGroupTile(
                                title: function.displayName,
                                isSelected: selectedField is SelectedFunction && selectedField.function == function,
                                onTap: () => context.read<RemoteControl>().selectExposedFunction(function),
                              );
                            }).toList(),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const VerticalDivider(),
        const Expanded(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: PresetGroupFieldOverview(),
          ),
        )
      ],
    );
  }
}

/**
 * group.exposedProperties.map(
    (property) {

    return Column(
    children: [
    ExpansionTile(title: title)
    ],
    );

    final selected = exposedProperty == property;

    return ListTile(
    title: Text(property.displayName),
    trailing: selected ? const Icon(Icons.check, color: Colors.green) : null,
    onTap: () => context.read<RemoteControl>().selectExposedProperty(property),
    );
    },
    ).toList(),
 */
