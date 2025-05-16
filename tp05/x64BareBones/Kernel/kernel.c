#include <stdint.h>
#include <string.h>
#include <module_loader.h>
#include <naive_console.h>
#include <cpu_vendor.h>
#include <time.h>
#include <idt_loader.h>
#include <drivers/rtc.h>
#include <interrupts.h>

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
	nc_print_styled("Arquitectura de Computadores", 0x0, 0x5);
	nc_newline();

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

	/*
	
	
	nc_print("Testing syscall write with int 80h...");
	nc_newline();
	
	char test_message[] = "Hello from syscall write using int 80h!\n";
	
	// Using int 80h to call write syscall
	// rax = syscall number (1 for write)
	// rdi = file descriptor (2 for stderr)
	// rsi = buffer address
	// rdx = count
	__asm__ __volatile__(
		"mov $1, %%rax\n\t"    // syscall number for write
		"mov $2, %%rdi\n\t"    // stderr file descriptor
		"mov %0, %%rsi\n\t"    // buffer address
		"mov %1, %%rdx\n\t"    // count
		"int $0x80\n\t"        // trigger syscall
		:
		: "r" (test_message), "r" (sizeof(test_message) - 1)
		: "rax", "rdi", "rsi", "rdx"
	);
	
	nc_print("Syscall write test completed");
	nc_newline();
	*/



	_hlt();

	return 0;
}