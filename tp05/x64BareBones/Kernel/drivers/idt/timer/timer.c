#include <timer.h>
#include <naive_console.h>

static unsigned long ticks = 0;

static unsigned long last_second = 0;

void timer_handler() {
	ticks++;

	// Print "Viva la vida" every 5 seconds
	if (seconds_elapsed() % 5 == 0 && seconds_elapsed() != last_second) {
		nc_print("Fuiste interrumpido");
		nc_newline();
		last_second = seconds_elapsed();
	}
}

int ticks_elapsed() {
	return ticks;
}

int seconds_elapsed() {
	return ticks / 18;
}
