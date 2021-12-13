/*
 * by Adam Kandur
 * 
 * Program and library to calculate the number of days,
 * months and years between two dates dates
 */

#include<stdio.h>
#include<stdlib.h>

#include "diff2dates.h"

int
main(void)
{
  Date date1, date2, date_diff;

  printf("Enter start date (MM/DD/YYYY): ");
  scanf("%d/%d/%d", &date1.month, &date1.day, &date1.year);
  printf("Enter end date (MM/DD/YYYY): ");
  scanf("%d/%d/%d", &date2.month, &date2.day, &date2.year);

  date_diff = diff_dates (date1, date2);

  printf("Difference: %d years %02d months and %02d days.\n",
	 date_diff.year, date_diff.month, date_diff.day);

  return EXIT_SUCCESS;
}
