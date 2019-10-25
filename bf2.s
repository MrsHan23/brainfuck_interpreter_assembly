.data
ARRAY: .skip 30000


.global brainfuck

format_str: .asciz "We should be executing the following code:\n%s"

# Your brainfuck subroutine will receive one argument:
# a zero termianted string containing the code to execute.
brainfuck:
	enter $0,$0

	movq %rdi, %r10

	movq %rdi, %rsi
	movq $format_str, %rdi
	call printf
	movq $0, %rax

	#initialize ARRAY
	movq $0, %rcx

loop:	movb $0, ARRAY(%rcx)
		incq %rcx
		cmpq $30000, %rcx
		jl loop


# *********************************************INSERT CODE **************************************************************************

	movq $0, %rdx							#set datapointer to 0
	movq $0, %r8							#set number of brackets to 0
	movq $0, %rcx    						#set counter for loop/ iterate each char to 0

	movb (%r10, %rcx, 1), %al				#take first character of brainfuck code



main_loop:	cmpb '+', %al
			je plus

			cmpb '-', %al
			je minus

			cmpb '>', %al
			je pointer_up

			cmpb '<', %al
			je pointer_down

			cmpb '[', %al
			je loop_open

			cmpb ']', %al
			je loop_close

			cmpb '.', %al
			je print

			cmpb ',', %al
			je read

#*******************************

plus:	incb ARRAY(%rdx)
		jmp end_loop

#*************************************

minus:	decb ARRAY(%rdx)
		jmp end_loop

#*******************************

pointer_up:	incq %rdx
			jmp end_loop

#*******************************

pointer_down:	decq %rdx
				jmp end_loop

#********************

print:	mov %al, %r9b
		mov ARRAY(%rdx), %al
		push %rax
		call putchar
		mov %r9b, %al
		jmp end_loop

#************************

read:	call getchar
		mov %al, ARRAY(%rdx)
		jmp end_loop

#*******************

loop_open:	cmpb $0, ARRAY(%rdx)
			je case1
			jmp end_loop

case1:	incq %rcx
		movb (%r10, %rcx, 1), %al

while: 	cmpq $0, %r8
		jg inside_loop

		cmpb ']', %al
		jne inside_loop

		jmp end_loop

inside_loop:	cmpb '[', %al
				je ifcode

				cmpb ']', %al
				je elsecode

				incq %rcx
				movb (%r10, %rcx, 1), %al

				jmp while

ifcode:	incq %r8

		incq %rcx
		movb (%r10, %rcx, 1), %al

		jmp while

elsecode:	decq %r8

			incq %rcx
			movb (%r10, %rcx, 1), %al

			jmp while


#*****************

loop_close:	cmpb $0, ARRAY(%rdx)
			jne case2
			jmp end_loop

case2:	decq %rcx
		movb (%r10, %rcx, 1), %al


while2:	cmpq $0, %r8
		jg inside_loop2

		cmpb '[', %al
		jne inside_loop2

		jmp end_loop_close


inside_loop2:	cmpb ']', %al
				je ifcode2

				cmpb '[', %al
				je elsecode2

				decq %rcx
				movb (%r10, %rcx, 1), %al

				jmp while2

ifcode2:	incq %r8

			decq %rcx
			movb (%r10, %rcx, 1), %al

			jmp while2

elsecode2:	decq %r8

			decq %rcx
			movb (%r10, %rcx, 1), %al

			jmp while2



end_loop_close:	decq %rcx
				movb (%r10, %rcx, 1), %al
				
				jmp end_loop




#*********************
end_loop:	incq %rcx						  #increment counter 
			movb (%r10, %rcx, 1), %al		  # add %rcx to %rsi and multiply by one to get the next character from the string.
			cmpb $0x00, %al
			jne	main_loop
			jmp endsub





endsub:	leave
		ret
