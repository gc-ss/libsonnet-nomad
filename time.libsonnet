// go package "time"

{
  nanosecond: 1,
  microsecond: 1000 * self.nanosecond,
  millisecond: 1000 * self.microsecond,
  second: 1000 * self.millisecond,
  minute: 60 * self.second,
  hour: 60 * self.hour,
}
