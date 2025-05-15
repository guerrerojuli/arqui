#ifndef TIME_H
#define TIME_H

// Basic time functions
int get_hours();
int get_minutes();
int get_seconds();

// Date functions
int get_day();
int get_month();
int get_year();
int get_century();
int get_day_of_week();

// String formatting functions
void get_time_string(char* buffer);
void get_date_string(char* buffer);

#endif