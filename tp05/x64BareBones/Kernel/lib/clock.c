#include <time.h>
#include <utils.h>
#include <stdint.h>

// RTC Register Addresses
#define RTC_SECONDS_REG 0x00
#define RTC_MINUTES_REG 0x02
#define RTC_HOURS_REG   0x04
#define RTC_DAY_OF_WEEK_REG 0x06
#define RTC_DAY_OF_MONTH_REG 0x07
#define RTC_MONTH_REG   0x08
#define RTC_YEAR_REG    0x09
#define RTC_CENTURY_REG 0x32
// Note: Add other registers if needed, e.g., status registers

int get_seconds() {
  return bcd_to_bin(time(RTC_SECONDS_REG));
}

int get_minutes() {
  return bcd_to_bin(time(RTC_MINUTES_REG));
}

int get_hours() {
  // RTC might store hours in 12-hour or 24-hour format,
  // and might have a bit to indicate PM.
  // Assuming direct BCD conversion for now.
  return bcd_to_bin(time(RTC_HOURS_REG));
}

int get_day_of_week() {
  return bcd_to_bin(time(RTC_DAY_OF_WEEK_REG)); // Sunday=1, ..., Saturday=7 or similar
}

int get_day() {
  return bcd_to_bin(time(RTC_DAY_OF_MONTH_REG));
}

int get_month() {
  return bcd_to_bin(time(RTC_MONTH_REG));
}

int get_year() {
  return bcd_to_bin(time(RTC_YEAR_REG)); // e.g., 23 for 2023
}

int get_century() {
  return bcd_to_bin(time(RTC_CENTURY_REG)); // e.g., 20 for 20xx
}


// Utility function to get current time as a string (HH:MM:SS)
void get_time_string(char* buffer) {
  int hours = get_hours();
  int minutes = get_minutes();
  int seconds = get_seconds();
  
  buffer[0] = (hours / 10) + '0';
  buffer[1] = (hours % 10) + '0';
  buffer[2] = ':';
  buffer[3] = (minutes / 10) + '0';
  buffer[4] = (minutes % 10) + '0';
  buffer[5] = ':';
  buffer[6] = (seconds / 10) + '0';
  buffer[7] = (seconds % 10) + '0';
  buffer[8] = '\0';
}

// Utility function to get current date as a string (DD/MM/YYYY)
void get_date_string(char* buffer) {
  int day = get_day();
  int month = get_month();
  int year_yy = get_year();
  int century = get_century();
  
  int full_year = century * 100 + year_yy;

  buffer[0] = (day / 10) + '0';
  buffer[1] = (day % 10) + '0';
  buffer[2] = '/';
  buffer[3] = (month / 10) + '0';
  buffer[4] = (month % 10) + '0';
  buffer[5] = '/';
  buffer[6] = (full_year / 1000) + '0';
  buffer[7] = ((full_year / 100) % 10) + '0';
  buffer[8] = ((full_year / 10) % 10) + '0';
  buffer[9] = (full_year % 10) + '0';
  buffer[10] = '\0';
}