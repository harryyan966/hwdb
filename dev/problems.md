# Design problems

- DateTime problem:
    - if DateTimes are stored in the database as DateTimes, it is hard to convert them into json
    - if DateTimes are stored in the database as millisecondsSinceEpoch, int32 won't be enough, and the database will automatically convert them into double, which still need to be converted to int
    - SOL? store DateTimes as Iso Strings and parse them

---

- adding the create assignment function might clog the `ScoreboardCubit` too much
    - `ScoreboardCubit` must make many setter functions that modify the state values, which might be a bit of an issue
        - SOL make another cubit