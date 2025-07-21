import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:unreal_remote_control/logic/project.dart';

part 'hive_adapters.g.dart';

/// Automatically generates [Hive] adapters for the given types.
@GenerateAdapters([
  AdapterSpec<Project>(),
])
class HiveAdapters {}
