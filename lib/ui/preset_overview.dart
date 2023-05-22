import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unreal_remote_control/state/remote_control.dart';
import 'package:unreal_remote_control/ui/property_overview.dart';

class PresetOverview extends StatelessWidget {
  const PresetOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final (groups, exposedProperty) = context.select(
      (RemoteControl rc) =>
          (rc.state.presetGroups, rc.state.selectedExposedProperty),
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
                      children: group.exposedProperties.map(
                        (property) {
                          final selected = exposedProperty == property;

                          return ListTile(
                            title: Text(property.displayName),
                            trailing: selected
                                ? const Icon(Icons.check, color: Colors.green)
                                : null,
                            onTap: () => context
                                .read<RemoteControl>()
                                .selectExposedProperty(property),
                          );
                        },
                      ).toList(),
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
            child: ExposedPropertyOverview(),
          ),
        )
      ],
    );
  }
}
