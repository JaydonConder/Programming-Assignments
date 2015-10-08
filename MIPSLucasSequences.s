#############################################
## Name:  Jaydon Conder Lab 3               #
## Email: jaydonrconder@gmail.com           #
#############################################
##                                          #
##  This program produces a Lucas sequence  #
##  of the first (U) or second (V) order,   #
##  given a number N, and constants         #
##  P and Q.                                #
##                                          #
############################################# 

.globl main

#############################################
#                                           #
#                   Data                    #
#                                           #
#############################################
.data
	menuWelcomeMessage:  .asciiz "Lucas Sequence Generator: \n\n"
	menuOption1message:  .asciiz "  (1) U(n, P, Q)\n\n"
	menuOption2message:  .asciiz "  (2) V(n, P, Q)\n\n"
	menuOption3message:  .asciiz "  (3) Exit the program\n\n"	
	selectionMessage:    .asciiz "Enter your selection: "
	requestNmessage:	 .asciiz "Please enter integer  N: "
	requestPmessage:	 .asciiz "Please enter constant P: "
	requestQmessage:	 .asciiz "Please enter constant Q: "	
	newline:             .asciiz "\n"
	notYetImplemented:	 .asciiz "\nThis procedure is not yet implemented!\n"
	exitMessage:         .asciiz "\nThank you, come again!"
	comma:				 .asciiz ", "
	invalidAnswer:		 .asciiz "That number is not valid. Please insert a number greater than or equal to 0: "
	
.text
#############################################
#                                           #
#                  Program                  #
#                                           #
#############################################
main:
	la $a0, newline
	jal printString
	la $a0, menuWelcomeMessage	# load menu introductory message
	jal printString				# print message
	
	la $a0, menuOption1message	# load menu prompt 1
	jal printString				# print message
	
	la $a0, menuOption2message	# load menu prompt 2
	jal printString				# print message
	
	la $a0, menuOption3message	# load menu prompt 3
	jal printString				# print message
		
	la $a0, selectionMessage	# load message for menu selection input
	jal scanInteger			    # print selection prompt and get user input
	addi $a3, $v0, -1			# adjust result to make zero-indexed (0 or 1), 
	                            # and store value in $a3
	
	la $a0, newline          	# print a newline \n
	jal printString			
	
	li $t0, 1					# load temp value for range testing
	blt $t0, $a3, __sysExit		# user entered int > 2; exit program
	blt $a3, $0, __sysExit		# user entered int < 1; exit program
	
	la $a0, requestNmessage   	# load message to enter integer N
	jal scanInteger			    # print selection prompt and get user input
	blt $v0, 0, invalidN		# checks to make sure n is greater than 0. 
	move $s0, $v0				# store n in $s0 (for now)
	move $s0, $v0				# store n in $s0 (for now)
	
	la $a0, requestPmessage   	# load message to enter integer P
	jal scanInteger			    # print selection prompt and get user input
	move $a1, $v0				# store P in $a1
	
	la $a0, requestQmessage   	# load message to enter integer Q
	jal scanInteger			    # print selection prompt and get user input
	move $a2, $v0				# store Q in $a2	
	
	move $a0, $s0				# copy n from $s0 to $a0
	li $t1, 0					# verifies that $t1 starts as zero 
	jal lucasSequenceNumber		# print the lucas sequence for N, P, and Q

invalidN:
	addi $sp, $sp, -4			# moves the stack down to make room to store $ra
	sw $ra, 0($sp)				# stores $ra onto the stack 
	la $a0 invalidAnswer		# prints out a message stating the n value is invalid 
	jal scanInteger				# scans in a new integer for n 
	blt $v0, 0, invalidN		# verifies that the new integer is valid 
	lw $ra, 0($sp)				# load $ra stored on the stack into $ra 
	addi $sp, $sp, 4			# move the stack up by 4 to return it to where it was 
	jr $ra						# return to $ra
	
BaseCheck:						# A method that will make forward base checking to BCU or BCV, depending on 
								# what type of sequence the user is trying to calculate. 
	beq $a3, 0, BCU				# Forwards to BCU when the sequence is a U function 
	beq $a3, 1, BCV				# Forwards to BCV when the sequence is a V function 

BCU:							# A function that checks if the current number is one of the base cases
	blt $a0, 2, Base			# checks to see if n is 0 or 1, and if so, travels to Base 
	jr $ra						
	
BCV:							# A function that checks if the current number is one of the base cases
	beq $a0, $zero, BCVHelper	# branch to BCVHelper if n is 0 
	beq $a0, 1, BCVHelper2		# branch to BCVHelper2 if n is 1 
	jr $ra
		
BCVHelper:						# A helper function for V sequences when n = 0
	li $a0, 2					# stores 2 into $a0 
	li $v0, 2					# stores 2 into $v0 (the value of n is 2 when n = 0)
	j Base						# jump to the Base function
	
BCVHelper2:						# A helper function for the V sequences when n = 1
	move $v0, $a1				# stores the value of P into $v0 (the value of n is P when n = 1)
	j Base
	
#############################################    
# Procedure: lucasSequence        		    #	
#############################################
#   - produces the Lucas sequence of the    #
#     first (U) or second (V) order for     #
#     given constants P and Q.              #
#                                           #
#     The procedure produces all numbers    #       
#     in the sequence U or V from n=0       #
#	  up to n=N.                     	    #
#                                           #
#   - inputs : $a0-integer N                #
#              $a1-constant P               #
#              $a2-constant Q               #
#              $a3-function U (0) or V (1)  #
#   - outputs: none                         #  
#										    #
#############################################	
lucasSequence:					# The function that produces the numbers in the sequence 
	addi $sp, $sp, -8			# Creates room on the stack 
	sw $ra, 4($sp)				# Saves the current $ra onto the stack 
	move $v0, $a0				# Stores the value of n into $v0, 
	jal BaseCheck				# Checks to make sure it is not at a base case 
	sw $a0, 0($sp)				# stores n onto the stack 
	addi $a0, $a0, -1			# moves the counter down by one 
	
	jal lucasSequence			# lucasSequence(n-1) 
	
	lw $a0, 0($sp)				# loads n from the stack 
	sw $v0, 0($sp)				# saves result of lucasSequence of n-1
	addi $a0, $a0, -2			# n-2
	
	jal lucasSequence			# lucasSequence(n-2)
	
	lw $v1, 0($sp)				# retrieves lucasSequence(n-1)
	mul $v0, $a0, $a2			# multiplies (n-2) by Q
	mul $v1, $v1, $a1			# multiplies (n-1) by P 
	
	jal help					# calls help 
	
Base:							# the general Base case function 
	move $t1, $v0				# stores $v0 into $t1 
	lw $ra, 4($sp)				# loads $ra from the stack 
	addi $sp, $sp, 8			# moves the stack up by 8 
	jr $ra						# jump back to $ra
	
help:							# a helper function that does the subtraction of (P x LN(n-1)) - (Q x LN(n-2))
	sub $a0, $v1, $v0			# the subtraction as stated above
	move $t1, $a0				# stores $a0 into $t1 for later use
	move $v0, $t1				# stores $t1 into $v0 for later use
	lw $ra, 4($sp)				# loads $ra from the stack
	addi $sp, $sp, 8			# moves the stack up by 8
	jr $ra						# jump back to $ra
	

############################################# 
# Procedure: lucasSequenceNumber         	#	
#############################################
#   - produces the Lucas number of the      #
#     first (U) and second (V) order for    #
#     number n, given constants P and Q.    #       
#										    #
#   - inputs : $a0-integer n                #
#              $a1-constant P               #
#              $a2-constant Q               #
#              $a3-function U (0) or V (1)  #
#   - outputs: $v0-value of U(n,P,Q) or     # 
#                  value of V(n,P,Q)        #
#										    #
#############################################	
lucasSequenceNumber:			# use stated above 
	move $a0, $v0				# moves $v0 into $a0 for use as the counter 
	la $a0, newline				# stores newline into $a0 
	jal printString				# prints out a new line 
	li $s1, 0					# stores 0 into $s1 
	j LOOP						# jump to LOOP 
	
LOOP: 							# looping function to print out the sequence in order 
	bgt $s1, $s0, main 			# if $s1 (counter starting at zero) gets higher than n, branch to main 
	move $a0, $s1				# move counter $s1 into $a0 for use as the counter in lucasSequence 
	jal lucasSequence			# call lucasSequence 
	move $a0, $t1				# move $t1 (final value retrieved from lucasSequence) into $a0 to print out 
	li $v0, 1					# readies the system to print an int 
	syscall						# print int $a0 
	la $a0, comma				# loads the comma into $a0
	li $v0, 4					# readies the system to print a string	
	syscall						# prints string ", "
	addi $s1, $s1, 1			# increments the counter by 1 
	j LOOP						# calls itself recursively until it branches 
	
	
############################################# 
# Procedure: scanInteger         		    #	
#############################################
#   - prints a message and gets an integer  #
#     from user                             #
#										    #
#   - inputs : $a0-address of string prompt #
#   - outputs: $v0-integer return value     #  
#										    #
#############################################	
scanInteger:
	addi $sp, $sp, -4			# adjust stack
	sw $ra, 0($sp)				# push return address
	jal printString             # print message prompt
	
	li $v0, 5					# read integer from console
	syscall						

	lw $ra, 0($sp)				# pop return address
	addi $sp, $sp, 4			# adjust stack
	jr $ra						# return
	
############################################# 
# Procedure: printString   				    #	
#############################################
#   - print a string to console             #
#										    #
#   - inputs : $a0 - address of string      #
#   - outputs: none                         #  
#										    #
#############################################
printString:
	li $v0, 4
	syscall
	jr $ra	
	
############################################# 
# Procedure: __sysExit   				    #	
#############################################
#   - exit the program                      #
#										    #
#   - inputs : none                         #
#   - outputs: none                         #  
#										    #
#############################################
__sysExit:
	la $a0, exitMessage		# print exit message
	jal printString
	li $v0, 10				# exit program
	syscall