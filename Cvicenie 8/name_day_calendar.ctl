LOAD DATA
INFILE 'name_day_calendar.unl'
INTO TABLE name_day_calendar

FIELDS TERMINATED BY '|'
(
  datum DATE 'MM/DD/YYYY',
  meno
)

