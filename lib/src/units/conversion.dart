const int microsecondsPerMillisecond = 1000;
const int millisecondsPerSecond = 1000;
const int secondsPerMinute = 60;
const int minutesPerHour = 60;
const int hoursPerDay = 24;

const int microsecondsPerSecond = microsecondsPerMillisecond * millisecondsPerSecond;
const int microsecondsPerMinute = microsecondsPerSecond * secondsPerMinute;
const int microsecondsPerHour = microsecondsPerMinute * minutesPerHour;
const int microsecondsPerDay = microsecondsPerHour * hoursPerDay;

const int millisecondsPerMinute = millisecondsPerSecond * secondsPerMinute;
const int millisecondsPerHour = millisecondsPerMinute * minutesPerHour;
const int millisecondsPerDay = millisecondsPerHour * hoursPerDay;

const int secondsPerHour = secondsPerMinute * minutesPerHour;
const int secondsPerDay = secondsPerHour * hoursPerDay;

const int minutesPerDay = minutesPerHour * hoursPerDay;