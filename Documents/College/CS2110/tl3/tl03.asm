;; Timed Lab 3, Spring 2023
;; For this Timed Lab, you will be given a number.
;; Your task will be to compute and the return the digital root of that number.
;; 
;; The digital root of a number is found by repeatedly summing the digits of
;; the original number until it converges into a single digit 
;;
;; For example:
;; Input: 12345
;; Output: 6
;;
;; Explanation:
;; Step 1: 1 + 2 + 3 + 4 + 5 = 15
;; Step 2: 1 + 5 = 6
;; 
;; Since we find a single digit number in step 2, the output is 6



;; The high level flow of this file is as follows
;; 1. We will write out the number as its individual digits as characters (This method is given)
;; 2. We will iterate over the characters to find the sum of the individual digits
;; 3. If the sum is less than 10, we have found the digital root
;; 4. If it is not, we call digital root on the sum until it converges
;; 
;; You will implement steps 3 and 4 in the function digital_root and step 2 in the
;; function sum_digits


.orig x3000

    ; ; One test is at the bottom of this file
    BR TEST_START

;; to_decimal_string function
;; Stores a given positive integer as a string starting at the given memory address, 
;; including the null terminator
;;
;; Parameter address: Value of address to store the string at
;; Parameter num: Value to store as a string
;; Returns: None
;;
;; NOTE #1 (PAY CAREFUL ATTENTION HERE): This function technically returns nothing, but, due to the
;; standard calling convention, the stack pointer will be pointing to a space in memory that was 
;; allocated for the return value when this function returns.
;; 
;; NOTE #2: Parameters are listed in the order they are expected to be found in the stack.
;;          The function will only work correctly if the parameters are given in this order
;;          More specifically, address will be above (lesser address) num on stack
;;
;; NOTE #3: Pay extra attention to the result of this function, it will write
;;          into memory, not numbers. This is because we can use the 
;;          null terminator character to denote the end of the string
;;
;; Examples:
;; * to_decimal_string(x6000, 142)
;; Stores:
;; x6000: '1'
;; x6001: '4'
;; x6002: '2'
;; x6003: 0

TODECIMALSTRING
    .fill x1DB7
    .fill x7F87
    .fill x7B86
    .fill x1BA5
    .fill x7180
    .fill x7381
    .fill x7582
    .fill x7783
    .fill x7984
    .fill x6144
    .fill x6345
    .fill x54A0
    .fill x7400
    .fill x5920
    .fill x1460
    .fill x16B6
    .fill x0803
    .fill x14B6
    .fill x1921
    .fill x0FFB
    .fill x7140
    .fill x6344
    .fill x927F
    .fill x1261
    .fill x1201
    .fill x0804
    .fill x6600
    .fill x7601
    .fill x103F
    .fill x0FF7
    .fill x14AF
    .fill x14AF
    .fill x14AF
    .fill x14A3
    .fill x7401
    .fill x6140
    .fill x1021
    .fill x1320
    .fill x0BE6
    .fill x6180
    .fill x6381
    .fill x6582
    .fill x6783
    .fill x6984
    .fill x1D63
    .fill x6f42
    .fill x6B41
    .fill xC1C0

;; function sum_digits

;; This function takes in an address and returns the sum of the values of each character of the 
;; numeric string contained at that address.
;;
;; Parameter addr: The address of the first character of the numeric string
;;
;; Returns: Sum of all digits found in the numeric string. 
;;
;; Note: The numeric string contains character representations of the numbers, 
;; not the literal number themselves. You must return the sum of the numeric value of the digits.
;;
;; Examples:
;; * sum_digits(x6000)
;; 
;; Memory layout:
;; x6000: '1'
;; x6001: '4'
;; x6002: '2'
;; x6003: 0
;;
;; Returns: 7
;;
;; Psuedocode:
;;
;; sum_digits(int addr) {
;;      int sum = 0;
;;      char curr = mem[addr];
;;      while (curr != 0){
;;          sum += int(curr);
;;          addr += 1;
;;          curr =  mem[addr];
;;      }
;;      return sum;
;; } 

SUMDIGITS
        ;; todo
        ADD R6, R6, #-4     ;; Make space for RV, RA, old FP, LV1
        STR R7, R6, #2      ;; Save RA
        STR R5, R6, #1      ;; Save old FP
        ADD R5, R6, #0      ;; Assign new FP to location of LV1
        ADD R6, R6, #-5     ;; Make space for a total of 1 local variables
        STR R0, R6, #0      ;; Save R0
        STR R1, R6, #1      ;; Save R1
        STR R2, R6, #2      ;; Save R2
        STR R3, R6, #3      ;; Save R3
        STR R4, R6, #4      ;; Save R4

        ; R0 = SUM, R1 = mem[ADDR], R2 = curr, R4 = ADDR
        AND R0, R0, 0
        LDR R4, R5, 4
        LDR R1, R4, 0
        AND R2, R2, 0
        ADD R2, R2, R1

        BRz ENDLOOP

        STARTLOOP
        ; R3 = int(curr)
        LD R3, ASCIIOffset
        ADD R3, R3, R2
        ; SUM += INT(CURR)
        ADD R0, R0, R3
        ; ADDR++
        ADD R4, R4, 1
        ; CURR = MEM[ADDR]
        LDR R2, R4, 0
        ADD R2, R2, 0
        BRnzp STARTLOOP

        ENDLOOP

        STR R0, R5, 3

        LDR R0, R6, #0      ;; Restore R0
        LDR R1, R6, #1      ;; Restore R1
        LDR R2, R6, #2      ;; Restore R2
        LDR R3, R6, #3      ;; Restore R3
        LDR R4, R6, #4      ;; Restore R4
        ADD R6, R5, #0      ;; Pop off all registers R0-R4, and LVs except the first LV
        LDR R5, R6, #1      ;; Restore old FP
        LDR R7, R6, #2      ;; Restore RA
        ADD R6, R6, #3      ;; Pop off LV1, old FP, RA 

        RET

;; Function digital_root
;; Takes a number and returns the digital root of that number. You are given an address
;; stored in label WRITE_SPACE. This address contains space allocated for up to 10 characters to 
;; store the string representations of your number.
;; 
;;
;; Parameter num: The number we would like to take the digital root of
;;
;; Returns: The digital root of the num
;;
;; Examples:
;;    digital_root(15) returns 6
;;    digital_root(12) returns 3
;;    digital_root(17) returns 3

;; Pseudocode:
;; digital_root(int num) {
;;         int addr = mem[WRITE_SPACE]
;;         to_decimal_string(addr, num);
;;         int sum = sum_digits(addr);
;;         if (sum >= 10){
;;             return digital_root(sum);
;;         }
;;         return sum;
;;     }

DIGITALROOT
		;; todo
        ADD R6, R6, #-4     ;; Make space for RV, RA, old FP, LV1
        STR R7, R6, #2      ;; Save RA
        STR R5, R6, #1      ;; Save old FP
        ADD R5, R6, #0      ;; Assign new FP to location of LV1
        ADD R6, R6, #-5     ;; Make space for a total of 1 local variables
        STR R0, R6, #0      ;; Save R0
        STR R1, R6, #1      ;; Save R1
        STR R2, R6, #2      ;; Save R2
        STR R3, R6, #3      ;; Save R3
        STR R4, R6, #4      ;; Save R4
        ; R0 = NUM
        LDR R0, R5, 4
        ; R1 = MEM[WRITE_SPACE] = ADDR
        LDI R1, WRITE_SPACE
        ; PUSH NUM, THEN ADDR
        ADD R6, R6, -1
        STR R0, R6, 0
        ADD R6, R6, -1
        STR R1, R6, 0

        JSR TODECIMALSTRING

        ; POP RV, ARG1, ARG2
        ADD R6, R6, 3
        
        ; PUSH ADDR
        ADD R6, R6, -1
        STR R1, R6, 0

        JSR SUMDIGITS
        ; R2 = SUM
        LDR R2, R6, 0

        ADD R6, R6, 2

        ; R3 = SUM - 10
        AND R3, R3, 0
        ADD R3, R3, -10
        ADD R3, R3, R2

        BRn ENDIF

        IF
        ADD R6, R6, -1
        STR R2, R6, 0
        JSR DIGITALROOT
        ; R4 = DIGITAL_ROOT(SUM)
        LDR R4, R6, 0
        ADD R6, R6, 2
        ; RV = R4
        STR R4, R5, 3
        BRnzp ENDELSE
        ENDIF

        ELSE
        STR R2, R5, 3
        ENDELSE

        LDR R0, R6, #0      ;; Restore R0
        LDR R1, R6, #1      ;; Restore R1
        LDR R2, R6, #2      ;; Restore R2
        LDR R3, R6, #3      ;; Restore R3
        LDR R4, R6, #4      ;; Restore R4
        ADD R6, R5, #0      ;; Pop off all registers R0-R4, and LVs except the first LV
        LDR R5, R6, #1      ;; Restore old FP
        LDR R7, R6, #2      ;; Restore RA
        ADD R6, R6, #3      ;; Pop off LV1, old FP, RA 

		RET



;; Test case
;; Runs digital_root(1234)
;; Expected return value: 7
;; Stores return value in R0
TEST_START
        LD R6, STACK
        LD R0, INPUT
        ADD R6, R6, -1
		STR R0, R6, 0
        STR R0, R6, 0
        JSR DIGITALROOT
        LDR R0, R6, 0 ;; Read return value in R0
        ADD R6, R6, 2
        HALT

ASCIIOffset .fill #-48 ; ASCII offset to convert an ASCII string to decimal
INPUT .fill 1234 ; number to calculate the digital root of
WRITE_SPACE .fill x5000 ; address where the string rep. of the number can be stored, DO NOT CHANGE THIS VALUE
STACK .fill x6000
.end

.orig	x5000
    .blkw 10
.end