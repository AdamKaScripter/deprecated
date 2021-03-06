#include <stdio.h>
#include <stdbool.h>
#include "diff2dates.h"

bool diff_dates_tests (void);
bool diff_dates_tests_case0 (void);
bool diff_dates_tests_case1 (void);

int
main (void)
{
  printf ("Testing: Date diff_dates (Date date1, Date date2)\n");
  diff_dates_tests ();
}

bool
diff_dates_tests (void)
{
  if (diff_dates_tests_case0 ()
      && diff_dates_tests_case1 ())
    {
      printf ("diff_dates_tests are OK\n");
      return true;
    }

  printf ("diff_dates_tests are NOT ok\n");
  return false;
}

bool
diff_dates_tests_case0 (void)
{
  Date date1, date2, date_diff;

  date1.day   = 29;
  date1.month = 2;
  date1.year  = 1996;
  date2.day   = 29;
  date2.month = 2;
  date2.year  = 2000;

  date_diff = diff_dates (date1, date2);

  if (date_diff.day == 0)
    if (date_diff.month == 0)
      if (date_diff.year == 4)
	{
	  printf ("diff_dates_tests_case0 is OK\n");
	  return true;
	}

  printf ("diff_dates_tests_case0 is NOT ok\n");
  return false;
}

/* bool */
/* diff_dates_tests_case1 (void) */
/* { */
/*   Date date1, date2, date_diff; */

/*   date1.day   = 03; */
/*   date1.month = 30; */
/*   date1.year  = 1998; */
/*   date2.day   = 12; */
/*   date2.month = 12; */
/*   date2.year  = 2021; */

/*   date_diff = diff_dates (date1, date2); */

/*   if (date_diff.day == 23) */
/*     if (date_diff.month == 8) */
/*       if (date_diff.year == 12) */
/* 	{ */
/* 	  printf ("diff_dates_tests_case1 is OK\n"); */
/* 	  return true; */
/* 	} */

/*   printf ("diff_dates_tests_case0 is NOT ok\n"); */
/*   return false; */
/* } */
