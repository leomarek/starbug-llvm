	.file	"dp_scalar.c"
	.option nopic
	.attribute arch, "rv32i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0_zifencei2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
# GNU C17 () version 14.2.0 (riscv64-unknown-elf)
#	compiled by GNU C version 11.4.0, GMP version 6.2.1, MPFR version 4.1.0, MPC version 1.2.1, isl version none
# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -mabi=ilp32 -mtune=rocket -misa-spec=20191213 -march=rv32imafdc_zicsr_zifencei -O3 -funroll-loops -ffast-math -fno-math-errno -ftree-vectorize
	.text
	.align	1
	.globl	dot_product
	.type	dot_product, @function
dot_product:
# dp_scalar.c:5:     for (uint64_t i = 0; i < len; i++) {
	or	a4,a3,a4	# tmp248, len, len
	beq	a4,zero,.L1	#, len,,
	slli	a3,a3,2	#, _24, len
	addi	a6,a3,-4	#, tmp173, _24
	srli	t0,a6,2	#, tmp171, tmp173
	addi	t1,t0,1	#, tmp174, tmp171
	andi	t2,t1,3	#, tmp175, tmp174
	add	a7,a0,a3	# _24, _14, ivtmp.7
# dp_scalar.c:4:     int64_t acc = 0;
	li	a5,0		# acc,
	beq	t2,zero,.L4	#, tmp175,,
	li	t3,1		# tmp177,
	beq	t2,t3,.L17	#, tmp175, tmp177,
	li	t4,2		# tmp176,
	beq	t2,t4,.L18	#, tmp175, tmp176,
# dp_scalar.c:6:           acc += (int64_t)input_1[i] * input_2[i];
	lw	a5,0(a0)		# MEM[(const int32_t *)_32], MEM[(const int32_t *)_32]
	lw	t5,0(a1)		# MEM[(const int32_t *)_31], MEM[(const int32_t *)_31]
# dp_scalar.c:5:     for (uint64_t i = 0; i < len; i++) {
	addi	a0,a0,4	#, ivtmp.7, ivtmp.7
	addi	a1,a1,4	#, ivtmp.8, ivtmp.8
# dp_scalar.c:6:           acc += (int64_t)input_1[i] * input_2[i];
	mul	a5,a5,t5	# acc, MEM[(const int32_t *)_32], MEM[(const int32_t *)_31]
# dp_scalar.c:5:     for (uint64_t i = 0; i < len; i++) {
	addi	a2,a2,4	#, ivtmp.9, ivtmp.9
# dp_scalar.c:7:           output[i] = (int32_t) acc;
	sw	a5,-4(a2)	# acc, MEM[(int32_t *)_30]
.L18:
# dp_scalar.c:6:           acc += (int64_t)input_1[i] * input_2[i];
	lw	t6,0(a0)		# MEM[(const int32_t *)_32], MEM[(const int32_t *)_32]
	lw	a4,0(a1)		# MEM[(const int32_t *)_31], MEM[(const int32_t *)_31]
# dp_scalar.c:5:     for (uint64_t i = 0; i < len; i++) {
	addi	a0,a0,4	#, ivtmp.7, ivtmp.7
	addi	a1,a1,4	#, ivtmp.8, ivtmp.8
# dp_scalar.c:6:           acc += (int64_t)input_1[i] * input_2[i];
	mul	a3,t6,a4	# tmp230, MEM[(const int32_t *)_32], MEM[(const int32_t *)_31]
# dp_scalar.c:5:     for (uint64_t i = 0; i < len; i++) {
	addi	a2,a2,4	#, ivtmp.9, ivtmp.9
# dp_scalar.c:6:           acc += (int64_t)input_1[i] * input_2[i];
	add	a5,a5,a3	# tmp230, acc, acc
# dp_scalar.c:7:           output[i] = (int32_t) acc;
	sw	a5,-4(a2)	# acc, MEM[(int32_t *)_30]
.L17:
# dp_scalar.c:6:           acc += (int64_t)input_1[i] * input_2[i];
	lw	t0,0(a0)		# MEM[(const int32_t *)_32], MEM[(const int32_t *)_32]
	lw	a6,0(a1)		# MEM[(const int32_t *)_31], MEM[(const int32_t *)_31]
# dp_scalar.c:5:     for (uint64_t i = 0; i < len; i++) {
	addi	a0,a0,4	#, ivtmp.7, ivtmp.7
	addi	a1,a1,4	#, ivtmp.8, ivtmp.8
# dp_scalar.c:6:           acc += (int64_t)input_1[i] * input_2[i];
	mul	t1,t0,a6	# tmp238, MEM[(const int32_t *)_32], MEM[(const int32_t *)_31]
# dp_scalar.c:5:     for (uint64_t i = 0; i < len; i++) {
	addi	a2,a2,4	#, ivtmp.9, ivtmp.9
# dp_scalar.c:6:           acc += (int64_t)input_1[i] * input_2[i];
	add	a5,a5,t1	# tmp238, acc, acc
# dp_scalar.c:7:           output[i] = (int32_t) acc;
	sw	a5,-4(a2)	# acc, MEM[(int32_t *)_30]
# dp_scalar.c:5:     for (uint64_t i = 0; i < len; i++) {
	beq	a7,a0,.L23	#, _14, ivtmp.7,
.L4:
	

	
# Bundle 1: Load Input 1A, Update all pointers immediately to free up ALU slots later
c.li x0,4         # Hint (VLIW 4)
	lw	t2,0(a0)	# MEM: Load Elem 1 (Stream A)
	addi	a0,a0,16	# ALU: Pre-increment Pointer A
	addi	a1,a1,16	# ALU: Pre-increment Pointer B
	addi	a2,a2,16	# ALU: Pre-increment Pointer Out
	


# Bundle 2: Load Input 1B (Adjusted offset -16 due to increment)
lw	t3,-16(a1)	# MEM: Load Elem 1 (Stream B)



# Bundle 3: Load Input 2A, Calculate Math 1
c.li x0,2         # Hint (VLIW 2)
	lw	t6,-12(a0)	# MEM: Load Elem 2 (Stream A)
	mul	t4,t2,t3	# ALU: Math Elem 1 (t2*t3)
	

	
# Bundle 4: Load Input 2B, Accumulate 1
c.li x0,2         # Hint (VLIW 2)
	lw	a4,-12(a1)	# MEM: Load Elem 2 (Stream B)
	add	t5,a5,t4	# ALU: Acc Elem 1 (acc + math1)
	

	
# Bundle 5: Store Result 1, Calculate Math 2
c.li x0,2         # Hint (VLIW 2)
	sw	t5,-16(a2)	# MEM: Store Elem 1 (Offset -16 due to inc)
	mul	a3,t6,a4	# ALU: Math Elem 2 (t6*a4)



# Bundle 6: Load Input 3A, Accumulate 2
c.li x0,2         # Hint (VLIW 2)
	lw	t1,-8(a0)	# MEM: Load Elem 3 (Stream A)
	add	t0,t5,a3	# ALU: Acc Elem 2 (acc1 + math2)


	
lw	a6,-8(a1)	# MEM: Load Elem 3 (Stream B)



# Bundle 8: Store Result 2, Calculate Math 3
c.li x0,2         # Hint (VLIW 2)
	sw	t0,-12(a2)	# MEM: Store Elem 2
	mul	a5,t1,a6	# ALU: Math Elem 3 (t1*a6) - Note: overwrites old accumulator a5



# Bundle 9: Load Input 4A, Accumulate 3
c.li x0,2         # Hint (VLIW 2)
	lw	t3,-4(a0)	# MEM: Load Elem 4 (Stream A)
	add	t2,t0,a5	# ALU: Acc Elem 3 (acc2 + math3)



lw	t4,-4(a1)	# MEM: Load Elem 4 (Stream B)	



# Bundle 11: Store Result 3, Calculate Math 4
c.li x0,2         # Hint (VLIW 2)
	sw	t2,-8(a2)	# MEM: Store Elem 3
	mul	t5,t3,t4	# ALU: Math Elem 4 (t3*t4)



# Bundle 12: Accumulate 4 (No MEM op here)
add	a5,t2,t5	# ALU: Acc Elem 4 (acc3 + math4) - Sets up a5 for next loop



# Bundle 13: Store Result 4, Branch
sw	a5,-4(a2)	# MEM: Store Elem 4



bne	a7,a0,.L4	# BRANCH: Loop check


.L1:
# dp_scalar.c:10: }
	ret	
.L23:
	ret	
	.size	dot_product, .-dot_product
	.ident	"GCC: () 14.2.0"
	.section	.note.GNU-stack,"",@progbits
