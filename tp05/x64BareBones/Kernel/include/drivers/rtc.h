#ifndef RTC_H
#define RTC_H

#include <stdint.h>

typedef struct {
  uint8_t seconds;
  uint8_t minutes;
  uint8_t hours;
} rtc_time_t;

typedef struct {
  uint8_t day;
  uint8_t month;
  uint8_t year;
} rtc_date_t;

void rtc_get_time(rtc_time_t *time);
void rtc_get_date(rtc_date_t *date);


#endif
