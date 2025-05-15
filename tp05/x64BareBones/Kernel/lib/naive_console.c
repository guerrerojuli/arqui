#include <naive_console.h>

static uint32_t uint_to_base(uint64_t value, char * buffer, uint32_t base);

static char buffer[64] = { '0' };
static uint8_t * const video = (uint8_t*)0xB8000;
static uint8_t * current_video = (uint8_t*)0xB8000;
static const uint32_t width = 80;
static const uint32_t height = 25 ;

void nc_print(const char * string)
{
	int i;

	for (i = 0; string[i] != 0; i++)
		nc_print_char(string[i]);
}

void nc_print_styled(const char * string, char background, char foreground) {
	for (int i = 0; string[i] != 0; i++) {
		nc_print_styled_char(string[i], background, foreground);
	}
}

void nc_print_char(char character)
{
	*current_video = character;
	current_video += 2;
}

void nc_print_styled_char(char character, char background, char foreground) {
	*current_video = character;
	*(current_video + 1) = (background << 4) | (foreground & 0x0F);
	current_video += 2;
}

void nc_newline()
{
	do
	{
		nc_print_char(' ');
	}
	while((uint64_t)(current_video - video) % (width * 2) != 0);
}

void nc_print_dec(uint64_t value)
{
	nc_print_base(value, 10);
}

void nc_print_hex(uint64_t value)
{
	nc_print_base(value, 16);
}

void nc_print_bin(uint64_t value)
{
	nc_print_base(value, 2);
}

void nc_print_base(uint64_t value, uint32_t base)
{
    uint_to_base(value, buffer, base);
    nc_print(buffer);
}

void nc_clear()
{
	int i;

	for (i = 0; i < height * width; i++)
		video[i * 2] = ' ';
	current_video = video;
}

void nc_backspace() {
	// Check if we are at the beginning of the video buffer
	if (current_video <= video) {
		return;
	}

	// Check if we are at the beginning of a line (optional, but good practice)
	// This assumes current_video is always even when pointing to a char
	// (char byte, then attribute byte)
	uint64_t current_offset = (uint64_t)(current_video - video);
	if ((current_offset % (width * 2)) == 0) {
		// Optionally, handle backspacing to previous line here, or just stop
		return; 
	}

	current_video -= 2; // Move back one character position (char + attribute)
	*current_video = ' '; // Erase the character by writing a space
	// Attribute byte *(current_video + 1) is left as is, or can be reset
}

static uint32_t uint_to_base(uint64_t value, char * buffer, uint32_t base)
{
	char *p = buffer;
	char *p1, *p2;
	uint32_t digits = 0;

	//Calculate characters for each digit
	do
	{
		uint32_t remainder = value % base;
		*p++ = (remainder < 10) ? remainder + '0' : remainder + 'A' - 10;
		digits++;
	}
	while (value /= base);

	// Terminate string in buffer.
	*p = 0;

	//Reverse string in buffer.
	p1 = buffer;
	p2 = p - 1;
	while (p1 < p2)
	{
		char tmp = *p1;
		*p1 = *p2;
		*p2 = tmp;
		p1++;
		p2--;
	}

	return digits;
}
