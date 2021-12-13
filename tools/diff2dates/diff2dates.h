#include<stdbool.h>

typedef struct
{
  int day;
  int month;
  int year;
} Date;

bool is_date_valid (Date date);
bool is_year_leap  (int year);
Date diff_dates (Date date1, Date date2);
