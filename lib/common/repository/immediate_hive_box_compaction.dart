/// A predicate that triggers a Hive box compaction whenever the given number
/// of [deleted] entries is >= 1.
bool immediateHiveBoxCompaction(int _, int deleted) => deleted >= 1;
