LOAD DATA
INFILE 'day_calendar.unl'
INTO TABLE name_day_calendar

FIELDS TERMINATED BY '|'
(
  datum,
  meno
)

