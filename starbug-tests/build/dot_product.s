	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_a2p1_c2p0_zmmul1p0_zaamo1p0_zalrsc1p0_zca1p0"
	.file	"dot_product.c"
	.text
	.globl	dot_product_i32                 # -- Begin function dot_product_i32
	.p2align	1
	.type	dot_product_i32,@function
dot_product_i32:                        # @dot_product_i32
# %bb.0:
	blez	a2, .LBB0_6
# %bb.1:
	addi	sp, sp, -128
	sw	ra, 124(sp)                     # 4-byte Folded Spill
	sw	s0, 120(sp)                     # 4-byte Folded Spill
	sw	s1, 116(sp)                     # 4-byte Folded Spill
	sw	s2, 112(sp)                     # 4-byte Folded Spill
	sw	s3, 108(sp)                     # 4-byte Folded Spill
	sw	s4, 104(sp)                     # 4-byte Folded Spill
	sw	s5, 100(sp)                     # 4-byte Folded Spill
	sw	s6, 96(sp)                      # 4-byte Folded Spill
	sw	s7, 92(sp)                      # 4-byte Folded Spill
	sw	s8, 88(sp)                      # 4-byte Folded Spill
	sw	s9, 84(sp)                      # 4-byte Folded Spill
	sw	s10, 80(sp)                     # 4-byte Folded Spill
	c.li	zero, 3
	sw	s11, 76(sp)                     # 4-byte Folded Spill
	mv	a4, a0
	srli	a3, a2, 5
	andi	a5, a2, 31
	beqz	a3, .LBB0_7
# %bb.2:
	c.li	zero, 4
	sw	a5, 16(sp)                      # 4-byte Folded Spill
	li	a2, 0
	li	a0, 0
	slli	a3, a3, 6
	c.li	zero, 2
	sw	a1, 12(sp)                      # 4-byte Folded Spill
	addi	a5, a1, 64
	srli	a1, a3, 1
	neg	a1, a1
	sw	a1, 20(sp)                      # 4-byte Folded Spill
	c.li	zero, 2
	sw	a4, 8(sp)                       # 4-byte Folded Spill
	addi	a3, a4, 64
.LBB0_3:                                # =>This Inner Loop Header: Depth=1
	sw	a0, 68(sp)                      # 4-byte Folded Spill
	sw	a2, 72(sp)                      # 4-byte Folded Spill
	lw	a0, -64(a3)
	lw	s1, -60(a3)
	lw	s4, -56(a3)
	lw	a7, -52(a3)
	lw	a2, -64(a5)
	lw	t2, -60(a5)
	lw	t3, -56(a5)
	lw	t4, -52(a5)
	lw	t6, -48(a3)
	lw	s8, -44(a3)
	lw	t1, -40(a3)
	lw	s5, -36(a3)
	lw	a1, -48(a5)
	lw	s11, -44(a5)
	lw	s6, -40(a5)
	lw	s9, -36(a5)
	lw	a4, -32(a3)
	lw	s7, -28(a3)
	lw	s2, -24(a3)
	lw	s10, -20(a3)
	lw	s0, -32(a5)
	lw	s3, -28(a5)
	lw	ra, -24(a5)
	c.li	zero, 2
	lw	a6, -20(a5)
	mul	a0, a2, a0
	sw	a0, 64(sp)                      # 4-byte Folded Spill
	lw	a2, -16(a3)
	lw	t0, -12(a3)
	lw	a0, -8(a3)
	c.li	zero, 2
	lw	t5, -4(a3)
	mul	s1, t2, s1
	sw	s1, 60(sp)                      # 4-byte Folded Spill
	mul	s1, t3, s4
	sw	s1, 52(sp)                      # 4-byte Folded Spill
	mul	s1, t4, a7
	c.li	zero, 2
	sw	s1, 48(sp)                      # 4-byte Folded Spill
	mul	a1, a1, t6
	sw	a1, 44(sp)                      # 4-byte Folded Spill
	lw	a7, -16(a5)
	lw	t2, -12(a5)
	lw	t3, -8(a5)
	c.li	zero, 2
	lw	t4, -4(a5)
	mul	a1, s11, s8
	sw	a1, 56(sp)                      # 4-byte Folded Spill
	mul	a1, s6, t1
	sw	a1, 36(sp)                      # 4-byte Folded Spill
	mul	a1, s9, s5
	sw	a1, 32(sp)                      # 4-byte Folded Spill
	mul	a1, s0, a4
	sw	a1, 40(sp)                      # 4-byte Folded Spill
	lw	s0, 0(a3)
	lw	s6, 4(a3)
	lw	s11, 8(a3)
	c.li	zero, 2
	lw	t6, 12(a3)
	mul	a1, s3, s7
	c.li	zero, 4
	sw	a1, 28(sp)                      # 4-byte Folded Spill
	mul	s9, ra, s2
	mul	s10, a6, s10
	mul	s5, a7, a2
	lw	a2, 0(a5)
	lw	a6, 4(a5)
	lw	a7, 8(a5)
	c.li	zero, 3
	lw	s7, 12(a5)
	mul	t2, t2, t0
	mul	a0, t3, a0
	c.li	zero, 3
	sw	a0, 24(sp)                      # 4-byte Folded Spill
	mul	t3, t4, t5
	mul	ra, a2, s0
	lw	a2, 16(a3)
	lw	a0, 20(a3)
	lw	s0, 24(a3)
	c.li	zero, 4
	lw	s1, 28(a3)
	mul	a6, a6, s6
	mul	t5, a7, s11
	mul	t4, s7, t6
	lw	a7, 16(a5)
	lw	t6, 20(a5)
	lw	s6, 24(a5)
	c.li	zero, 4
	lw	s7, 28(a5)
	mul	s11, a7, a2
	mul	t6, t6, a0
	mul	s6, s6, s0
	mul	a7, s7, s1
	lw	s7, 32(a3)
	lw	a2, 36(a3)
	lw	a0, 40(a3)
	lw	s0, 44(a3)
	lw	s1, 32(a5)
	lw	s2, 36(a5)
	lw	s3, 40(a5)
	c.li	zero, 2
	lw	t1, 44(a5)
	mul	s1, s1, s7
	mul	s7, s2, a2
	c.li	zero, 2
	mul	s2, s3, a0
	mul	t1, t1, s0
	lw	s3, 48(a3)
	lw	a4, 52(a3)
	lw	a2, 56(a3)
	lw	s0, 60(a3)
	lw	s4, 48(a5)
	lw	s8, 52(a5)
	lw	a0, 56(a5)
	c.li	zero, 3
	lw	a1, 60(a5)
	mul	s3, s4, s3
	mul	a4, s8, a4
	c.li	zero, 2
	mul	s8, a0, a2
	mul	s4, a1, s0
	lw	a2, 68(sp)                      # 4-byte Folded Reload
	lw	a0, 64(sp)                      # 4-byte Folded Reload
	add	a2, a2, a0
	lw	s0, 60(sp)                      # 4-byte Folded Reload
	lw	a0, 52(sp)                      # 4-byte Folded Reload
	add	s0, s0, a0
	lw	a1, 48(sp)                      # 4-byte Folded Reload
	lw	a0, 44(sp)                      # 4-byte Folded Reload
	add	a1, a1, a0
	lw	a0, 36(sp)                      # 4-byte Folded Reload
	lw	t0, 32(sp)                      # 4-byte Folded Reload
	c.li	zero, 4
	add	a0, a0, t0
	add	s9, s9, s10
	add	t3, t3, ra
	add	t6, t6, s6
	c.li	zero, 2
	add	a4, a4, s3
	add	a2, a2, s0
	lw	s0, 56(sp)                      # 4-byte Folded Reload
	add	a1, a1, s0
	lw	s0, 40(sp)                      # 4-byte Folded Reload
	c.li	zero, 4
	add	s0, s0, a0
	add	s5, s5, s9
	add	a6, a6, t3
	add	a7, a7, t6
	c.li	zero, 2
	add	a4, a4, s8
	add	a1, a1, a2
	lw	a2, 72(sp)                      # 4-byte Folded Reload
	lw	a0, 28(sp)                      # 4-byte Folded Reload
	c.li	zero, 4
	add	a0, a0, s0
	add	t2, t2, s5
	add	a6, a6, t5
	add	a7, a7, s1
	c.li	zero, 2
	add	a4, a4, s4
	add	a0, a0, a1
	lw	t0, 24(sp)                      # 4-byte Folded Reload
	c.li	zero, 3
	add	t0, t0, t2
	add	a6, a6, t4
	add	a7, a7, s7
	c.li	zero, 3
	add	a0, a0, t0
	add	a6, a6, s11
	add	a7, a7, s2
	c.li	zero, 4
	add	a0, a0, a6
	addi	a2, a2, -32
	addi	a5, a5, 128
	add	a7, a7, t1
	add	a0, a0, a7
	c.li	zero, 2
	add	a0, a0, a4
	addi	a3, a3, 128
	lw	a1, 20(sp)                      # 4-byte Folded Reload
	bne	a1, a2, .LBB0_3
# %bb.4:
	lw	a5, 16(sp)                      # 4-byte Folded Reload
	beqz	a5, .LBB0_39
# %bb.5:
	neg	a2, a2
	lw	a1, 12(sp)                      # 4-byte Folded Reload
	lw	a4, 8(sp)                       # 4-byte Folded Reload
	j	.LBB0_8
.LBB0_6:
	li	a0, 0
	ret
.LBB0_7:
	c.li	zero, 2
	li	a2, 0
	li	a0, 0
.LBB0_8:
	slli	a2, a2, 2
	c.li	zero, 2
	add	a3, a4, a2
	add	a1, a1, a2
	lw	a2, 0(a3)
	lw	a4, 0(a1)
	mul	a2, a4, a2
	c.li	zero, 2
	li	a4, 1
	add	a0, a0, a2
	beq	a5, a4, .LBB0_39
# %bb.9:
	lw	a2, 4(a3)
	lw	a4, 4(a1)
	mul	a2, a4, a2
	c.li	zero, 2
	li	a4, 2
	add	a0, a0, a2
	beq	a5, a4, .LBB0_39
# %bb.10:
	lw	a2, 8(a3)
	lw	a4, 8(a1)
	mul	a2, a4, a2
	c.li	zero, 2
	li	a4, 3
	add	a0, a0, a2
	beq	a5, a4, .LBB0_39
# %bb.11:
	lw	a2, 12(a3)
	lw	a4, 12(a1)
	mul	a2, a4, a2
	c.li	zero, 2
	li	a4, 4
	add	a0, a0, a2
	beq	a5, a4, .LBB0_39
# %bb.12:
	lw	a2, 16(a3)
	lw	a4, 16(a1)
	mul	a2, a4, a2
	c.li	zero, 2
	li	a4, 5
	add	a0, a0, a2
	beq	a5, a4, .LBB0_39
# %bb.13:
	lw	a2, 20(a3)
	lw	a4, 20(a1)
	mul	a2, a4, a2
	c.li	zero, 2
	li	a4, 6
	add	a0, a0, a2
	beq	a5, a4, .LBB0_39
# %bb.14:
	lw	a2, 24(a3)
	lw	a4, 24(a1)
	mul	a2, a4, a2
	c.li	zero, 2
	li	a4, 7
	add	a0, a0, a2
	beq	a5, a4, .LBB0_39
# %bb.15:
	lw	a2, 28(a3)
	lw	a4, 28(a1)
	mul	a2, a4, a2
	c.li	zero, 2
	li	a4, 8
	add	a0, a0, a2
	beq	a5, a4, .LBB0_39
# %bb.16:
	lw	a2, 32(a3)
	lw	a4, 32(a1)
	mul	a2, a4, a2
	c.li	zero, 2
	li	a4, 9
	add	a0, a0, a2
	beq	a5, a4, .LBB0_39
# %bb.17:
	lw	a2, 36(a3)
	lw	a4, 36(a1)
	mul	a2, a4, a2
	c.li	zero, 2
	li	a4, 10
	add	a0, a0, a2
	beq	a5, a4, .LBB0_39
# %bb.18:
	lw	a2, 40(a3)
	lw	a4, 40(a1)
	mul	a2, a4, a2
	c.li	zero, 2
	li	a4, 11
	add	a0, a0, a2
	beq	a5, a4, .LBB0_39
# %bb.19:
	lw	a2, 44(a3)
	lw	a4, 44(a1)
	mul	a2, a4, a2
	c.li	zero, 2
	li	a4, 12
	add	a0, a0, a2
	beq	a5, a4, .LBB0_39
# %bb.20:
	lw	a2, 48(a3)
	lw	a4, 48(a1)
	mul	a2, a4, a2
	c.li	zero, 2
	li	a4, 13
	add	a0, a0, a2
	beq	a5, a4, .LBB0_39
# %bb.21:
	lw	a2, 52(a3)
	lw	a4, 52(a1)
	mul	a2, a4, a2
	c.li	zero, 2
	li	a4, 14
	add	a0, a0, a2
	beq	a5, a4, .LBB0_39
# %bb.22:
	mv	s1, a5
	lw	a2, 56(a3)
	lw	a4, 56(a1)
	mul	a2, a4, a2
	c.li	zero, 2
	li	a4, 15
	add	a0, a0, a2
	beq	a5, a4, .LBB0_39
# %bb.23:
	lw	a2, 60(a3)
	lw	a4, 60(a1)
	mul	a2, a4, a2
	c.li	zero, 2
	li	a4, 16
	add	a0, a0, a2
	beq	s1, a4, .LBB0_39
# %bb.24:
	lw	a2, 64(a3)
	lw	a4, 64(a1)
	mul	a2, a4, a2
	c.li	zero, 2
	li	a4, 17
	add	a0, a0, a2
	beq	s1, a4, .LBB0_39
# %bb.25:
	lw	a2, 68(a3)
	lw	a4, 68(a1)
	mul	a2, a4, a2
	c.li	zero, 2
	li	a4, 18
	add	a0, a0, a2
	beq	s1, a4, .LBB0_39
# %bb.26:
	lw	a2, 72(a3)
	lw	a4, 72(a1)
	mul	a2, a4, a2
	c.li	zero, 2
	li	a4, 19
	add	a0, a0, a2
	beq	s1, a4, .LBB0_39
# %bb.27:
	lw	a2, 76(a3)
	lw	a4, 76(a1)
	mul	a2, a4, a2
	c.li	zero, 2
	li	a4, 20
	add	a0, a0, a2
	beq	s1, a4, .LBB0_39
# %bb.28:
	lw	a2, 80(a3)
	lw	a4, 80(a1)
	mul	a2, a4, a2
	c.li	zero, 2
	li	a4, 21
	add	a0, a0, a2
	beq	s1, a4, .LBB0_39
# %bb.29:
	lw	a2, 84(a3)
	lw	a4, 84(a1)
	mul	a2, a4, a2
	c.li	zero, 2
	li	a4, 22
	add	a0, a0, a2
	beq	s1, a4, .LBB0_39
# %bb.30:
	lw	a2, 88(a3)
	lw	a4, 88(a1)
	mul	a2, a4, a2
	c.li	zero, 2
	li	a4, 23
	add	a0, a0, a2
	beq	s1, a4, .LBB0_39
# %bb.31:
	lw	a2, 92(a3)
	lw	a4, 92(a1)
	mul	a2, a4, a2
	c.li	zero, 2
	li	a4, 24
	add	a0, a0, a2
	beq	s1, a4, .LBB0_39
# %bb.32:
	lw	a2, 96(a3)
	lw	a4, 96(a1)
	mul	a2, a4, a2
	c.li	zero, 2
	li	a4, 25
	add	a0, a0, a2
	beq	s1, a4, .LBB0_39
# %bb.33:
	lw	a2, 100(a3)
	lw	a4, 100(a1)
	mul	a2, a4, a2
	c.li	zero, 2
	li	a4, 26
	add	a0, a0, a2
	beq	s1, a4, .LBB0_39
# %bb.34:
	lw	a2, 104(a3)
	lw	a4, 104(a1)
	mul	a2, a4, a2
	c.li	zero, 2
	li	a4, 27
	add	a0, a0, a2
	beq	s1, a4, .LBB0_39
# %bb.35:
	lw	a2, 108(a3)
	lw	a4, 108(a1)
	mul	a2, a4, a2
	c.li	zero, 2
	li	a4, 28
	add	a0, a0, a2
	beq	s1, a4, .LBB0_39
# %bb.36:
	lw	a2, 112(a3)
	lw	a4, 112(a1)
	mul	a2, a4, a2
	c.li	zero, 2
	li	a4, 29
	add	a0, a0, a2
	beq	s1, a4, .LBB0_39
# %bb.37:
	lw	a2, 116(a3)
	lw	a4, 116(a1)
	mul	a2, a4, a2
	c.li	zero, 2
	li	a4, 30
	add	a0, a0, a2
	beq	s1, a4, .LBB0_39
# %bb.38:
	lw	a2, 120(a3)
	lw	a1, 120(a1)
	mul	a1, a1, a2
	add	a0, a0, a1
.LBB0_39:
	lw	ra, 124(sp)                     # 4-byte Folded Reload
	lw	s0, 120(sp)                     # 4-byte Folded Reload
	lw	s1, 116(sp)                     # 4-byte Folded Reload
	lw	s2, 112(sp)                     # 4-byte Folded Reload
	lw	s3, 108(sp)                     # 4-byte Folded Reload
	lw	s4, 104(sp)                     # 4-byte Folded Reload
	lw	s5, 100(sp)                     # 4-byte Folded Reload
	lw	s6, 96(sp)                      # 4-byte Folded Reload
	lw	s7, 92(sp)                      # 4-byte Folded Reload
	lw	s8, 88(sp)                      # 4-byte Folded Reload
	lw	s9, 84(sp)                      # 4-byte Folded Reload
	lw	s10, 80(sp)                     # 4-byte Folded Reload
	lw	s11, 76(sp)                     # 4-byte Folded Reload
	addi	sp, sp, 128
	ret
.Lfunc_end0:
	.size	dot_product_i32, .Lfunc_end0-dot_product_i32
                                        # -- End function
	.ident	"clang version 23.0.0git (ssh://git@github.com/llvm/llvm-project.git d3081aafc47eccba242ffc3cc43ecfcb545a51bb)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
