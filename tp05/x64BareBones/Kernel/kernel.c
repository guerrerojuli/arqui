#include <stdint.h>
#include <string.h>
#include <module_loader.h>
#include <naive_console.h>
#include <cpu_vendor.h>
#include <input.h>
#include <time.h>
#include <idt_loader.h>
#include <drivers/rtc.h>

extern uint8_t text;
extern uint8_t rodata;
extern uint8_t data;
extern uint8_t bss;
extern uint8_t endOfKernelBinary;
extern uint8_t endOfKernel;

static const uint64_t PAGE_SIZE = 0x1000;

static void * const SAMPLE_CODE_MODULE_ADDRESS = (void*)0x400000;
static void * const SAMPLE_DATA_MODULE_ADDRESS = (void*)0x500000;

typedef int (*entry_point_t)();


void clear_bss(void * bss_address, uint64_t bss_size)
{
	memset(bss_address, 0, bss_size);
}

void * get_stack_base()
{
	return (void*)(
		(uint64_t)&endOfKernel
		+ PAGE_SIZE * 8				//The size of the stack itself, 32KiB
		- sizeof(uint64_t)			//Begin at the top of the stack
	);
}

void * initialize_kernel_binary()
{
	char buffer[10];

	nc_print("[x64BareBones]");
	nc_newline();

	nc_print("CPU Vendor:");
	nc_print(cpu_vendor(buffer));
	nc_newline();

	nc_print("[Loading modules]");
	nc_newline();
	void * module_addresses[] = {
		SAMPLE_CODE_MODULE_ADDRESS,
		SAMPLE_DATA_MODULE_ADDRESS
	};

	load_modules(&endOfKernelBinary, module_addresses);
	nc_print("[Done]");
	nc_newline();
	nc_newline();

	nc_print("[Initializing kernel's binary]");
	nc_newline();

	clear_bss(&bss, &endOfKernel - &bss);

	nc_print("  text: 0x");
	nc_print_hex((uint64_t)&text);
	nc_newline();
	nc_print("  rodata: 0x");
	nc_print_hex((uint64_t)&rodata);
	nc_newline();
	nc_print("  data: 0x");
	nc_print_hex((uint64_t)&data);
	nc_newline();
	nc_print("  bss: 0x");
	nc_print_hex((uint64_t)&bss);
	nc_newline();

	nc_print("[Done]");
	nc_newline();
	nc_newline();

	return get_stack_base();
}

int main()
{	

	nc_print("[Loading IDT]");
	load_idt();
	nc_print("[Done]");
	nc_newline();

	nc_print("[Kernel Main]");
	nc_newline();
	nc_print("  Sample code module at 0x");
	nc_print_hex((uint64_t)SAMPLE_CODE_MODULE_ADDRESS);
	nc_newline();
	nc_print("  Calling the sample code module returned: ");
	nc_print_hex(((entry_point_t)SAMPLE_CODE_MODULE_ADDRESS)());
	nc_newline();
	nc_newline();

	nc_print("  Sample data module at 0x");
	nc_print_hex((uint64_t)SAMPLE_DATA_MODULE_ADDRESS);
	nc_newline();
	nc_print("  Sample data module contents: ");
	nc_print((char*)SAMPLE_DATA_MODULE_ADDRESS);
	nc_newline();

	nc_print("[Finished]");
	nc_newline();

	nc_clear();

	// Ejercicio 1
	//nc_print_styled("Arquitectura de Computadores", 0xF, 0x2);


	// Ejercicio 3
	rtc_time_t time;
	rtc_get_time(&time);
	nc_print("Hora: ");
	nc_print_dec(time.hours);
	nc_print(":");
	nc_print_dec(time.minutes);
	nc_print(":");
	nc_print_dec(time.seconds);
	nc_newline();

	rtc_date_t date;
	rtc_get_date(&date);
	nc_print("Fecha: ");
	nc_print_dec(date.day);
	nc_print("/");
	nc_print_dec(date.month);
	nc_print("/");
	nc_print_dec(date.year);
	nc_newline();
	
	
	// Ejercicio 4
	nc_newline();
	nc_print("Escribe algo");
	nc_newline();

	char tecla;
	do {
		tecla = get_char();
		if (tecla == '\b') {
			nc_backspace();
		} else if (tecla != 0) {
			nc_print_styled_char(tecla, 0xF, 0xD);
		}
	} while (tecla != '\n');

	while (1) ;

	return 0;
}