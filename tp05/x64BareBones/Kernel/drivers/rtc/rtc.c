#include <stdint.h>
#include <rtc.h>
#include <io.h>

static uint8_t bcd2bin(uint8_t value) {
    return (value & 0x0F) + ((value >> 4) * 10);
}

static void wait_rtc_update() {
  do {
    outb(0x70, 0x0A);
  } while (inb(0x71) & 0x80);
}

static uint8_t read_cmos(uint8_t reg) {
  outb(0x70, reg);
  return inb(0x71);
}

void rtc_get_time(rtc_time_t *time) {
  uint8_t sec, min, hr, status_b;

  wait_rtc_update();

  sec = read_cmos(0x00);
  min = read_cmos(0x02);
  hr = read_cmos(0x04);

  status_b = read_cmos(0x0B);

  if (!(status_b & 0x04)) {
    sec = bcd2bin(sec);
    min = bcd2bin(min);
    hr = bcd2bin(hr);
  }

  time->seconds = sec;
  time->minutes = min;
  time->hours = hr;
}

void rtc_get_date(rtc_date_t *date) {
  uint8_t day, month, year, status_b;

  wait_rtc_update();

  day = read_cmos(0x07);
  month = read_cmos(0x08);
  year = read_cmos(0x09);

  status_b = read_cmos(0x0B);

  if (!(status_b & 0x04)) {
    day = bcd2bin(day);
    month = bcd2bin(month);
    year = bcd2bin(year);
  }

  date->day = day;
  date->month = month;
  date->year = year;
}
