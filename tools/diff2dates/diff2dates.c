/*
 * by Adam Kandur
 * 
 * Program and library to calculate the number of days,
 * months and years between two dates dates
 */

#include<stdio.h>
#include<stdlib.h>
#include<stdbool.h>

#include "diff2dates.h"

/*
 * verifies that the date is valid
 */
bool
is_date_valid (Date date)
{
  if (date.year >= 1800 && date.year <= 9999) 
    {

      /*
       * checks whether month is between 1 and 12
       */
      if(date.month >= 1 && date.month <= 12)
        {
	  /*
	   * checks for days in February
	   */
	  if (date.month == 2)
            {
	      if (is_year_leap (date.year) && date.day == 29) 
		return true;
	      else if(date.day > 28) 
		return false;
            }

	  /*
	   * check for days in April, June,
	   * September and November
	   */
	  else if (date.month == 4
		   || date.month == 6
		   || date.month == 9
		   || date.month == 11) 
            {
	      if (date.day > 30)
		return false;
            }

	  /*
	   * checks days in the remaining months
	   */
	  else if(date.day > 31)
	    return false;
        }

      else
	return false;

    }
  else
    return false;

  return true;
}

/*
 * checks that year is leap
 */
bool
is_year_leap (int year)
{
  if ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)) 
    return true;

  return false;
}

/*
 * counts difference between two dates
 */
Date
diff_dates (Date date1, Date date2)
{
  Date result;

  if( ! is_date_valid (date1))
    {
      printf("First date is invalid.\n");
      exit (EXIT_FAILURE);
    }

  if( ! is_date_valid (date2))
    {
      printf("Second date is invalid.\n");
      exit (EXIT_FAILURE);
    }       

  if(date2.day < date1.day)
    {      
      // borrow days from february
      if (date2.month == 3)
        {
	  /*
	   * check whether year is a leap year
	   */
	  if (is_year_leap (date2.year)) 
	    date2.day += 29;

	  else
	    date2.day += 28;
        }

      /*
       * borrows days from April or June or September
       * or November
       */
      else if (date2.month == 5
	       || date2.month == 7
	       || date2.month == 10
	       || date2.month == 12)
        {
	  date2.day += 30; 
        }

      /*
       * borrows days from Jan or Mar or May or July
       * or Aug or Oct or Dec
       */
      else
	date2.day += 31;

      date2.month = date2.month - 1;
    }

  if (date2.month < date1.month)
    {
      date2.month += 12;
      date2.year -= 1;
    }

  if (date2.year >= date1.year)
    {
      result.day   = date2.day   - date1.day;
      result.month = date2.month - date1.month;
      result.year  = date2.year  - date1.year;
    }
  else
    {
      printf("First date must be earlier or equal to second.\n");
      exit (EXIT_FAILURE);
    }

  return result;
}
