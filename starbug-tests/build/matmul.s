	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_a2p1_c2p0_zmmul1p0_zaamo1p0_zalrsc1p0_zca1p0"
	.file	"matmul.c"
	.text
	.globl	matmul_i32                      # -- Begin function matmul_i32
	.p2align	1
	.type	matmul_i32,@function
matmul_i32:                             # @matmul_i32
# %bb.0:
	addi	sp, sp, -96
	sw	ra, 92(sp)                      # 4-byte Folded Spill
	sw	s0, 88(sp)                      # 4-byte Folded Spill
	sw	s1, 84(sp)                      # 4-byte Folded Spill
	sw	s2, 80(sp)                      # 4-byte Folded Spill
	sw	s3, 76(sp)                      # 4-byte Folded Spill
	sw	s4, 72(sp)                      # 4-byte Folded Spill
	sw	s5, 68(sp)                      # 4-byte Folded Spill
	sw	s6, 64(sp)                      # 4-byte Folded Spill
	sw	s7, 60(sp)                      # 4-byte Folded Spill
	sw	s8, 56(sp)                      # 4-byte Folded Spill
	sw	s9, 52(sp)                      # 4-byte Folded Spill
	sw	s10, 48(sp)                     # 4-byte Folded Spill
	sw	s11, 44(sp)                     # 4-byte Folded Spill
	sw	a2, 28(sp)                      # 4-byte Folded Spill
	sw	a1, 36(sp)                      # 4-byte Folded Spill
	bgtz	a3, .LBB0_1
	j	.LBB0_389
.LBB0_1:
	mv	t3, a4
	bgtz	a4, .LBB0_2
	j	.LBB0_389
.LBB0_2:
	mv	s9, a3
	bgtz	a5, .LBB0_3
	j	.LBB0_126
.LBB0_3:
	c.li	zero, 2
	mv	s7, a0
	li	a2, 0
	andi	a0, t3, 1
	sw	a0, 8(sp)                       # 4-byte Folded Spill
	lui	a0, 524288
	c.li	zero, 4
	andi	t0, a5, 31
	slli	t1, t3, 7
	addi	t2, s7, 64
	slli	a1, a5, 2
	c.li	zero, 2
	sw	a1, 24(sp)                      # 4-byte Folded Spill
	slli	ra, t3, 2
	lw	a1, 36(sp)                      # 4-byte Folded Reload
	addi	a1, a1, 4
	c.li	zero, 2
	sw	a1, 4(sp)                       # 4-byte Folded Spill
	li	a3, 32
	addi	a1, a0, -4
	c.li	zero, 2
	addi	a0, a0, -32
	addi	a1, a1, 2
	and	a0, a0, a5
	and	a1, t3, a1
	c.li	zero, 2
	sw	a1, 32(sp)                      # 4-byte Folded Spill
	neg	s11, a0
	sw	s9, 16(sp)                      # 4-byte Folded Spill
	sw	s7, 12(sp)                      # 4-byte Folded Spill
	j	.LBB0_8
.LBB0_4:                                #   in Loop: Header=BB0_8 Depth=1
	mv	a2, s10
.LBB0_5:                                #   in Loop: Header=BB0_8 Depth=1
	li	a3, 32
.LBB0_6:                                #   in Loop: Header=BB0_8 Depth=1
	lw	a0, 40(sp)                      # 4-byte Folded Reload
	add	s8, s8, a0
	sw	a7, 0(s8)
.LBB0_7:                                #   in Loop: Header=BB0_8 Depth=1
	addi	a2, a2, 1
	lw	a0, 24(sp)                      # 4-byte Folded Reload
	add	t2, t2, a0
	bne	a2, s9, .LBB0_8
	j	.LBB0_389
.LBB0_8:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_13 Depth 2
                                        #       Child Loop BB0_16 Depth 3
                                        #       Child Loop BB0_54 Depth 3
                                        #     Child Loop BB0_92 Depth 2
	c.li	zero, 2
	mul	a0, a2, a5
	mul	a1, a2, t3
	c.li	zero, 2
	slli	a0, a0, 2
	slli	a1, a1, 2
	add	t6, s7, a0
	lw	a0, 28(sp)                      # 4-byte Folded Reload
	add	a0, a0, a1
	sw	a0, 40(sp)                      # 4-byte Folded Spill
	li	a0, 1
	bne	t3, a0, .LBB0_10
# %bb.9:                                #   in Loop: Header=BB0_8 Depth=1
	li	s8, 0
	j	.LBB0_89
.LBB0_10:                               #   in Loop: Header=BB0_8 Depth=1
	c.li	zero, 2
	sw	a2, 20(sp)                      # 4-byte Folded Spill
	li	s8, 0
	lw	t5, 4(sp)                       # 4-byte Folded Reload
	lw	s9, 36(sp)                      # 4-byte Folded Reload
	j	.LBB0_13
.LBB0_11:                               #   in Loop: Header=BB0_13 Depth=2
	li	a3, 32
.LBB0_12:                               #   in Loop: Header=BB0_13 Depth=2
	c.li	zero, 4
	sw	a6, 4(s7)
	addi	s8, s8, 2
	addi	s9, s9, 8
	addi	t5, t5, 8
	lw	a0, 32(sp)                      # 4-byte Folded Reload
	beq	s8, a0, .LBB0_88
.LBB0_13:                               #   Parent Loop BB0_8 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_16 Depth 3
                                        #       Child Loop BB0_54 Depth 3
	slli	s7, s8, 2
	lw	s6, 36(sp)                      # 4-byte Folded Reload
	add	s6, s6, s7
	bgeu	a5, a3, .LBB0_15
# %bb.14:                               #   in Loop: Header=BB0_13 Depth=2
	c.li	zero, 2
	li	s1, 0
	li	a7, 0
	j	.LBB0_19
.LBB0_15:                               #   in Loop: Header=BB0_13 Depth=2
	c.li	zero, 4
	li	s10, 0
	li	a7, 0
	mv	s1, t2
	mv	s5, s9
.LBB0_16:                               #   Parent Loop BB0_8 Depth=1
                                        #     Parent Loop BB0_13 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	c.li	zero, 2
	lw	a3, 0(s5)
	add	a1, s5, ra
	lw	s3, -64(s1)
	lw	s2, -60(s1)
	lw	s4, -56(s1)
	c.li	zero, 2
	lw	a6, -52(s1)
	add	a2, a1, ra
	c.li	zero, 2
	add	t4, a2, ra
	mul	a3, a3, s3
	c.li	zero, 2
	add	a4, t4, ra
	add	a3, a3, a7
	lw	a1, 0(a1)
	lw	a2, 0(a2)
	lw	a0, 0(t4)
	c.li	zero, 2
	lw	s3, 0(a4)
	mul	a1, a1, s2
	c.li	zero, 2
	add	a1, a1, a3
	mul	a2, a2, s4
	add	a1, a1, a2
	lw	a2, -48(s1)
	lw	a7, -44(s1)
	lw	t4, -40(s1)
	c.li	zero, 3
	lw	s2, -36(s1)
	add	s0, a4, ra
	mul	a0, a0, a6
	c.li	zero, 2
	add	a4, s0, ra
	add	a0, a0, a1
	c.li	zero, 2
	add	a1, a4, ra
	mul	a2, s3, a2
	c.li	zero, 2
	add	a3, a1, ra
	add	a0, a0, a2
	lw	a2, 0(s0)
	lw	a4, 0(a4)
	lw	a1, 0(a1)
	c.li	zero, 2
	lw	a6, 0(a3)
	mul	a2, a2, a7
	add	a0, a0, a2
	mul	a2, a4, t4
	c.li	zero, 2
	add	a0, a0, a2
	mul	a1, a1, s2
	lw	a2, -32(s1)
	lw	t4, -28(s1)
	lw	s0, -24(s1)
	c.li	zero, 3
	lw	a7, -20(s1)
	add	a3, a3, ra
	add	a0, a0, a1
	c.li	zero, 2
	add	a1, a3, ra
	mul	a2, a6, a2
	lw	a3, 0(a3)
	lw	a4, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	add	a0, a0, a2
	c.li	zero, 2
	lw	a2, 0(a1)
	mul	a3, a3, t4
	add	a0, a0, a3
	mul	a3, a4, s0
	add	t4, a3, a0
	lw	s2, -16(s1)
	lw	s3, -12(s1)
	lw	s0, -8(s1)
	c.li	zero, 3
	lw	a6, -4(s1)
	add	a1, a1, ra
	mul	a2, a2, a7
	lw	a0, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	add	a2, a2, t4
	lw	a3, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	mul	a0, a0, s2
	lw	a4, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	add	a0, a0, a2
	c.li	zero, 2
	lw	a2, 0(a1)
	mul	a3, a3, s3
	add	a0, a0, a3
	mul	a3, a4, s0
	add	t4, a3, a0
	lw	s2, 0(s1)
	lw	s3, 4(s1)
	lw	s0, 8(s1)
	c.li	zero, 3
	lw	a7, 12(s1)
	add	a1, a1, ra
	mul	a2, a2, a6
	lw	a0, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	add	a2, a2, t4
	lw	a3, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	mul	a0, a0, s2
	lw	a4, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	add	a0, a0, a2
	c.li	zero, 2
	lw	a2, 0(a1)
	mul	a3, a3, s3
	add	a0, a0, a3
	mul	a3, a4, s0
	add	t4, a3, a0
	lw	s2, 16(s1)
	lw	s3, 20(s1)
	lw	s0, 24(s1)
	c.li	zero, 3
	lw	a6, 28(s1)
	add	a1, a1, ra
	mul	a2, a2, a7
	lw	a0, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	add	a2, a2, t4
	lw	a3, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	mul	a0, a0, s2
	lw	a4, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	add	a0, a0, a2
	c.li	zero, 2
	lw	a2, 0(a1)
	mul	a3, a3, s3
	add	a0, a0, a3
	mul	a3, a4, s0
	add	t4, a3, a0
	lw	s2, 32(s1)
	lw	s3, 36(s1)
	lw	s0, 40(s1)
	c.li	zero, 3
	lw	a7, 44(s1)
	add	a1, a1, ra
	mul	a2, a2, a6
	lw	a0, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	add	a2, a2, t4
	lw	a3, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	mul	a0, a0, s2
	lw	a4, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	add	a0, a0, a2
	c.li	zero, 2
	lw	a6, 0(a1)
	mul	a3, a3, s3
	add	a0, a0, a3
	mul	a3, a4, s0
	add	t4, a3, a0
	lw	s2, 48(s1)
	lw	s4, 52(s1)
	lw	s0, 56(s1)
	c.li	zero, 3
	lw	s3, 60(s1)
	add	a1, a1, ra
	mul	a0, a6, a7
	lw	a3, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	add	a0, a0, t4
	lw	a2, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	mul	a3, a3, s2
	c.li	zero, 3
	lw	a4, 0(a1)
	add	a0, a0, a3
	mul	a2, a2, s4
	add	a0, a0, a2
	c.li	zero, 2
	mul	a2, a4, s0
	add	a1, a1, ra
	c.li	zero, 4
	lw	a1, 0(a1)
	addi	s10, s10, -32
	add	s5, s5, t1
	add	a0, a0, a2
	mul	a7, a1, s3
	c.li	zero, 2
	add	a7, a7, a0
	addi	s1, s1, 128
	bne	s11, s10, .LBB0_16
# %bb.17:                               #   in Loop: Header=BB0_13 Depth=2
	beqz	t0, .LBB0_50
# %bb.18:                               #   in Loop: Header=BB0_13 Depth=2
	c.li	zero, 2
	neg	s1, s10
	li	a3, 32
.LBB0_19:                               #   in Loop: Header=BB0_13 Depth=2
	c.li	zero, 2
	slli	a0, s1, 2
	mul	a1, s1, t3
	c.li	zero, 2
	add	a0, a0, t6
	slli	a1, a1, 2
	c.li	zero, 2
	lw	a0, 0(a0)
	add	a1, a1, s6
	lw	a1, 0(a1)
	mul	a0, a1, a0
	add	a7, a7, a0
	li	a0, 1
	beq	t0, a0, .LBB0_51
# %bb.20:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s1, 1
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 2
	beq	t0, a0, .LBB0_51
# %bb.21:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s1, 2
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 3
	beq	t0, a0, .LBB0_51
# %bb.22:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s1, 3
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 4
	beq	t0, a0, .LBB0_51
# %bb.23:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s1, 4
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 5
	beq	t0, a0, .LBB0_51
# %bb.24:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s1, 5
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 6
	beq	t0, a0, .LBB0_51
# %bb.25:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s1, 6
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 7
	beq	t0, a0, .LBB0_51
# %bb.26:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s1, 7
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 8
	beq	t0, a0, .LBB0_51
# %bb.27:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s1, 8
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 9
	beq	t0, a0, .LBB0_51
# %bb.28:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s1, 9
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 10
	beq	t0, a0, .LBB0_51
# %bb.29:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s1, 10
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 11
	beq	t0, a0, .LBB0_51
# %bb.30:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s1, 11
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 12
	beq	t0, a0, .LBB0_51
# %bb.31:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s1, 12
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 13
	beq	t0, a0, .LBB0_51
# %bb.32:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s1, 13
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 14
	beq	t0, a0, .LBB0_51
# %bb.33:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s1, 14
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 15
	beq	t0, a0, .LBB0_51
# %bb.34:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s1, 15
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 16
	beq	t0, a0, .LBB0_51
# %bb.35:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s1, 16
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 17
	beq	t0, a0, .LBB0_51
# %bb.36:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s1, 17
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 18
	beq	t0, a0, .LBB0_51
# %bb.37:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s1, 18
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 19
	beq	t0, a0, .LBB0_51
# %bb.38:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s1, 19
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 20
	beq	t0, a0, .LBB0_51
# %bb.39:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s1, 20
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 21
	beq	t0, a0, .LBB0_51
# %bb.40:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s1, 21
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 22
	beq	t0, a0, .LBB0_50
# %bb.41:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s1, 22
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 23
	beq	t0, a0, .LBB0_50
# %bb.42:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s1, 23
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 24
	beq	t0, a0, .LBB0_50
# %bb.43:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s1, 24
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 25
	beq	t0, a0, .LBB0_50
# %bb.44:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s1, 25
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 26
	beq	t0, a0, .LBB0_50
# %bb.45:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s1, 26
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 27
	beq	t0, a0, .LBB0_50
# %bb.46:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s1, 27
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 28
	beq	t0, a0, .LBB0_50
# %bb.47:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s1, 28
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 29
	beq	t0, a0, .LBB0_50
# %bb.48:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s1, 29
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 30
	beq	t0, a0, .LBB0_50
# %bb.49:                               #   in Loop: Header=BB0_13 Depth=2
	addi	s1, s1, 30
	c.li	zero, 2
	slli	a0, s1, 2
	mul	a1, s1, t3
	c.li	zero, 2
	add	a0, a0, t6
	slli	a1, a1, 2
	c.li	zero, 2
	lw	a0, 0(a0)
	add	a1, a1, s6
	lw	a1, 0(a1)
	mul	a0, a1, a0
	add	a7, a7, a0
.LBB0_50:                               #   in Loop: Header=BB0_13 Depth=2
	li	a3, 32
.LBB0_51:                               #   in Loop: Header=BB0_13 Depth=2
	lw	a0, 40(sp)                      # 4-byte Folded Reload
	add	s7, s7, a0
	sw	a7, 0(s7)
	bgeu	a5, a3, .LBB0_53
# %bb.52:                               #   in Loop: Header=BB0_13 Depth=2
	c.li	zero, 2
	li	s0, 0
	li	a6, 0
	j	.LBB0_57
.LBB0_53:                               #   in Loop: Header=BB0_13 Depth=2
	c.li	zero, 4
	li	a7, 0
	li	a6, 0
	mv	a2, t2
	mv	t4, t5
.LBB0_54:                               #   Parent Loop BB0_8 Depth=1
                                        #     Parent Loop BB0_13 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	c.li	zero, 2
	lw	a0, 0(t4)
	add	a3, t4, ra
	lw	a4, -64(a2)
	lw	s3, -60(a2)
	lw	s0, -56(a2)
	c.li	zero, 2
	lw	s2, -52(a2)
	add	a1, a3, ra
	c.li	zero, 2
	add	s1, a1, ra
	mul	a0, a0, a4
	c.li	zero, 2
	add	a4, s1, ra
	add	a0, a0, a6
	lw	a3, 0(a3)
	lw	a1, 0(a1)
	lw	s1, 0(s1)
	c.li	zero, 2
	lw	a6, 0(a4)
	mul	a3, a3, s3
	c.li	zero, 2
	add	a0, a0, a3
	mul	a1, a1, s0
	add	a0, a0, a1
	lw	a1, -48(a2)
	lw	s3, -44(a2)
	lw	s4, -40(a2)
	c.li	zero, 3
	lw	s5, -36(a2)
	add	s0, a4, ra
	mul	s1, s1, s2
	c.li	zero, 2
	add	a4, s0, ra
	add	a0, a0, s1
	c.li	zero, 2
	add	s1, a4, ra
	mul	a1, a6, a1
	c.li	zero, 2
	add	a3, s1, ra
	add	a0, a0, a1
	lw	a1, 0(s0)
	lw	a4, 0(a4)
	lw	s1, 0(s1)
	c.li	zero, 2
	lw	a6, 0(a3)
	mul	a1, a1, s3
	add	a0, a0, a1
	mul	a1, a4, s4
	add	a0, a0, a1
	mul	a1, s1, s5
	lw	a4, -32(a2)
	lw	s3, -28(a2)
	lw	s0, -24(a2)
	c.li	zero, 3
	lw	s2, -20(a2)
	add	a3, a3, ra
	add	a0, a0, a1
	c.li	zero, 2
	add	a1, a3, ra
	mul	a4, a6, a4
	lw	a3, 0(a3)
	lw	s1, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	add	a0, a0, a4
	c.li	zero, 2
	lw	a4, 0(a1)
	mul	a3, a3, s3
	add	a0, a0, a3
	mul	a3, s1, s0
	add	s3, a3, a0
	lw	s4, -16(a2)
	lw	s5, -12(a2)
	lw	s0, -8(a2)
	c.li	zero, 3
	lw	a6, -4(a2)
	add	a1, a1, ra
	mul	a4, a4, s2
	lw	a0, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	add	a4, a4, s3
	lw	a3, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	mul	a0, a0, s4
	lw	s1, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	add	a0, a0, a4
	c.li	zero, 2
	lw	a4, 0(a1)
	mul	a3, a3, s5
	add	a0, a0, a3
	mul	a3, s1, s0
	add	s3, a3, a0
	lw	s4, 0(a2)
	lw	s5, 4(a2)
	lw	s1, 8(a2)
	c.li	zero, 3
	lw	s2, 12(a2)
	add	a1, a1, ra
	mul	a4, a4, a6
	lw	a0, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	add	a4, a4, s3
	lw	a3, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	mul	a0, a0, s4
	lw	s0, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	add	a0, a0, a4
	c.li	zero, 2
	lw	a4, 0(a1)
	mul	a3, a3, s5
	add	a0, a0, a3
	mul	a3, s0, s1
	add	s3, a3, a0
	lw	s4, 16(a2)
	lw	s5, 20(a2)
	lw	s0, 24(a2)
	c.li	zero, 3
	lw	a6, 28(a2)
	add	a1, a1, ra
	mul	a4, a4, s2
	lw	a0, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	add	a4, a4, s3
	lw	a3, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	mul	a0, a0, s4
	lw	s1, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	add	a0, a0, a4
	c.li	zero, 2
	lw	a4, 0(a1)
	mul	a3, a3, s5
	add	a0, a0, a3
	mul	a3, s1, s0
	add	s3, a3, a0
	lw	s4, 32(a2)
	lw	s5, 36(a2)
	lw	s1, 40(a2)
	c.li	zero, 3
	lw	s2, 44(a2)
	add	a1, a1, ra
	mul	a4, a4, a6
	lw	a0, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	add	a4, a4, s3
	lw	a3, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	mul	a0, a0, s4
	lw	s0, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	add	a0, a0, a4
	c.li	zero, 2
	lw	a6, 0(a1)
	mul	a3, a3, s5
	add	a0, a0, a3
	mul	a3, s0, s1
	add	s3, a3, a0
	lw	s4, 48(a2)
	lw	s10, 52(a2)
	lw	s0, 56(a2)
	c.li	zero, 3
	lw	s5, 60(a2)
	add	a1, a1, ra
	mul	a0, a6, s2
	lw	a3, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	add	a0, a0, s3
	lw	a4, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	mul	a3, a3, s4
	c.li	zero, 2
	lw	s1, 0(a1)
	add	a0, a0, a3
	mul	a3, a4, s10
	add	a0, a0, a3
	c.li	zero, 2
	mul	a3, s1, s0
	add	a1, a1, ra
	c.li	zero, 4
	lw	a1, 0(a1)
	addi	a7, a7, -32
	add	t4, t4, t1
	add	a0, a0, a3
	mul	a6, a1, s5
	c.li	zero, 2
	add	a6, a6, a0
	addi	a2, a2, 128
	bne	s11, a7, .LBB0_54
# %bb.55:                               #   in Loop: Header=BB0_13 Depth=2
	beqz	t0, .LBB0_11
# %bb.56:                               #   in Loop: Header=BB0_13 Depth=2
	c.li	zero, 2
	neg	s0, a7
	li	a3, 32
.LBB0_57:                               #   in Loop: Header=BB0_13 Depth=2
	c.li	zero, 2
	slli	a0, s0, 2
	mul	a1, s0, t3
	c.li	zero, 2
	add	a0, a0, t6
	slli	a1, a1, 2
	c.li	zero, 2
	lw	a0, 0(a0)
	add	a1, a1, s6
	lw	a1, 4(a1)
	mul	a0, a1, a0
	add	a6, a6, a0
	li	a0, 1
	beq	t0, a0, .LBB0_12
# %bb.58:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s0, 1
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 4(a0)
	mul	a0, a0, a1
	add	a6, a6, a0
	li	a0, 2
	beq	t0, a0, .LBB0_12
# %bb.59:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s0, 2
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 4(a0)
	mul	a0, a0, a1
	add	a6, a6, a0
	li	a0, 3
	beq	t0, a0, .LBB0_12
# %bb.60:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s0, 3
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 4(a0)
	mul	a0, a0, a1
	add	a6, a6, a0
	li	a0, 4
	beq	t0, a0, .LBB0_12
# %bb.61:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s0, 4
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 4(a0)
	mul	a0, a0, a1
	add	a6, a6, a0
	li	a0, 5
	beq	t0, a0, .LBB0_12
# %bb.62:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s0, 5
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 4(a0)
	mul	a0, a0, a1
	add	a6, a6, a0
	li	a0, 6
	beq	t0, a0, .LBB0_12
# %bb.63:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s0, 6
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 4(a0)
	mul	a0, a0, a1
	add	a6, a6, a0
	li	a0, 7
	beq	t0, a0, .LBB0_12
# %bb.64:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s0, 7
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 4(a0)
	mul	a0, a0, a1
	add	a6, a6, a0
	li	a0, 8
	beq	t0, a0, .LBB0_12
# %bb.65:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s0, 8
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 4(a0)
	mul	a0, a0, a1
	add	a6, a6, a0
	li	a0, 9
	beq	t0, a0, .LBB0_12
# %bb.66:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s0, 9
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 4(a0)
	mul	a0, a0, a1
	add	a6, a6, a0
	li	a0, 10
	beq	t0, a0, .LBB0_12
# %bb.67:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s0, 10
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 4(a0)
	mul	a0, a0, a1
	add	a6, a6, a0
	li	a0, 11
	beq	t0, a0, .LBB0_12
# %bb.68:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s0, 11
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 4(a0)
	mul	a0, a0, a1
	add	a6, a6, a0
	li	a0, 12
	beq	t0, a0, .LBB0_12
# %bb.69:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s0, 12
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 4(a0)
	mul	a0, a0, a1
	add	a6, a6, a0
	li	a0, 13
	beq	t0, a0, .LBB0_12
# %bb.70:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s0, 13
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 4(a0)
	mul	a0, a0, a1
	add	a6, a6, a0
	li	a0, 14
	beq	t0, a0, .LBB0_12
# %bb.71:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s0, 14
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 4(a0)
	mul	a0, a0, a1
	add	a6, a6, a0
	li	a0, 15
	beq	t0, a0, .LBB0_12
# %bb.72:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s0, 15
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 4(a0)
	mul	a0, a0, a1
	add	a6, a6, a0
	li	a0, 16
	beq	t0, a0, .LBB0_12
# %bb.73:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s0, 16
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 4(a0)
	mul	a0, a0, a1
	add	a6, a6, a0
	li	a0, 17
	beq	t0, a0, .LBB0_12
# %bb.74:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s0, 17
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 4(a0)
	mul	a0, a0, a1
	add	a6, a6, a0
	li	a0, 18
	beq	t0, a0, .LBB0_12
# %bb.75:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s0, 18
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 4(a0)
	mul	a0, a0, a1
	add	a6, a6, a0
	li	a0, 19
	beq	t0, a0, .LBB0_12
# %bb.76:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s0, 19
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 4(a0)
	mul	a0, a0, a1
	add	a6, a6, a0
	li	a0, 20
	beq	t0, a0, .LBB0_12
# %bb.77:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s0, 20
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 4(a0)
	mul	a0, a0, a1
	add	a6, a6, a0
	li	a0, 21
	beq	t0, a0, .LBB0_12
# %bb.78:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s0, 21
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 4(a0)
	mul	a0, a0, a1
	add	a6, a6, a0
	li	a0, 22
	beq	t0, a0, .LBB0_11
# %bb.79:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s0, 22
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 4(a0)
	mul	a0, a0, a1
	add	a6, a6, a0
	li	a0, 23
	beq	t0, a0, .LBB0_11
# %bb.80:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s0, 23
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 4(a0)
	mul	a0, a0, a1
	add	a6, a6, a0
	li	a0, 24
	beq	t0, a0, .LBB0_11
# %bb.81:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s0, 24
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 4(a0)
	mul	a0, a0, a1
	add	a6, a6, a0
	li	a0, 25
	beq	t0, a0, .LBB0_11
# %bb.82:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s0, 25
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 4(a0)
	mul	a0, a0, a1
	add	a6, a6, a0
	li	a0, 26
	beq	t0, a0, .LBB0_11
# %bb.83:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s0, 26
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 4(a0)
	mul	a0, a0, a1
	add	a6, a6, a0
	li	a0, 27
	beq	t0, a0, .LBB0_11
# %bb.84:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s0, 27
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 4(a0)
	mul	a0, a0, a1
	add	a6, a6, a0
	li	a0, 28
	beq	t0, a0, .LBB0_11
# %bb.85:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s0, 28
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 4(a0)
	mul	a0, a0, a1
	add	a6, a6, a0
	li	a0, 29
	beq	t0, a0, .LBB0_11
# %bb.86:                               #   in Loop: Header=BB0_13 Depth=2
	addi	a0, s0, 29
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, s6
	lw	a0, 4(a0)
	mul	a0, a0, a1
	add	a6, a6, a0
	li	a0, 30
	beq	t0, a0, .LBB0_11
# %bb.87:                               #   in Loop: Header=BB0_13 Depth=2
	addi	s0, s0, 30
	c.li	zero, 2
	slli	a0, s0, 2
	mul	a1, s0, t3
	c.li	zero, 2
	add	a0, a0, t6
	slli	a1, a1, 2
	c.li	zero, 2
	lw	a0, 0(a0)
	add	a1, a1, s6
	lw	a1, 4(a1)
	mul	a0, a1, a0
	add	a6, a6, a0
	j	.LBB0_11
.LBB0_88:                               #   in Loop: Header=BB0_8 Depth=1
	lw	s9, 16(sp)                      # 4-byte Folded Reload
	lw	s7, 12(sp)                      # 4-byte Folded Reload
	lw	a2, 20(sp)                      # 4-byte Folded Reload
	lw	a0, 8(sp)                       # 4-byte Folded Reload
	bnez	a0, .LBB0_89
	j	.LBB0_7
.LBB0_89:                               #   in Loop: Header=BB0_8 Depth=1
	slli	s8, s8, 2
	lw	a6, 36(sp)                      # 4-byte Folded Reload
	add	a6, a6, s8
	bgeu	a5, a3, .LBB0_91
# %bb.90:                               #   in Loop: Header=BB0_8 Depth=1
	c.li	zero, 2
	li	s0, 0
	li	a7, 0
	j	.LBB0_95
.LBB0_91:                               #   in Loop: Header=BB0_8 Depth=1
	c.li	zero, 3
	mv	s10, a2
	li	t4, 0
	li	a7, 0
	c.li	zero, 2
	mv	a2, t2
	mv	t5, a6
.LBB0_92:                               #   Parent Loop BB0_8 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	c.li	zero, 2
	lw	a0, 0(t5)
	add	a3, t5, ra
	lw	a1, -64(a2)
	lw	s3, -60(a2)
	lw	s0, -56(a2)
	c.li	zero, 2
	lw	s2, -52(a2)
	add	a4, a3, ra
	c.li	zero, 2
	add	s1, a4, ra
	mul	a0, a0, a1
	c.li	zero, 2
	add	a1, s1, ra
	add	a0, a0, a7
	lw	a3, 0(a3)
	lw	a4, 0(a4)
	lw	s1, 0(s1)
	c.li	zero, 2
	lw	a7, 0(a1)
	mul	a3, a3, s3
	add	a0, a0, a3
	mul	a3, a4, s0
	add	a0, a0, a3
	lw	a3, -48(a2)
	lw	s3, -44(a2)
	lw	s4, -40(a2)
	c.li	zero, 3
	lw	s5, -36(a2)
	add	s0, a1, ra
	mul	s1, s1, s2
	c.li	zero, 2
	add	a1, s0, ra
	add	a0, a0, s1
	c.li	zero, 2
	add	s1, a1, ra
	mul	a3, a7, a3
	c.li	zero, 2
	add	a4, s1, ra
	add	a0, a0, a3
	lw	a3, 0(s0)
	lw	a1, 0(a1)
	lw	s1, 0(s1)
	c.li	zero, 2
	lw	a7, 0(a4)
	mul	a3, a3, s3
	c.li	zero, 2
	add	a0, a0, a3
	mul	a1, a1, s4
	add	a0, a0, a1
	mul	a1, s1, s5
	lw	a3, -32(a2)
	lw	s3, -28(a2)
	lw	s0, -24(a2)
	c.li	zero, 3
	lw	s2, -20(a2)
	add	a4, a4, ra
	add	a0, a0, a1
	c.li	zero, 2
	add	a1, a4, ra
	mul	a3, a7, a3
	lw	a4, 0(a4)
	lw	s1, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	add	a0, a0, a3
	c.li	zero, 2
	lw	a3, 0(a1)
	mul	a4, a4, s3
	add	a0, a0, a4
	mul	a4, s1, s0
	add	s3, a4, a0
	lw	s4, -16(a2)
	lw	s5, -12(a2)
	lw	s0, -8(a2)
	c.li	zero, 3
	lw	a7, -4(a2)
	add	a1, a1, ra
	mul	a3, a3, s2
	lw	a0, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	add	a3, a3, s3
	lw	a4, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	mul	a0, a0, s4
	lw	s1, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	add	a0, a0, a3
	c.li	zero, 2
	lw	a3, 0(a1)
	mul	a4, a4, s5
	add	a0, a0, a4
	mul	a4, s1, s0
	add	s3, a4, a0
	lw	s4, 0(a2)
	lw	s5, 4(a2)
	lw	s1, 8(a2)
	c.li	zero, 3
	lw	s2, 12(a2)
	add	a1, a1, ra
	mul	a3, a3, a7
	lw	a0, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	add	a3, a3, s3
	lw	a4, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	mul	a0, a0, s4
	lw	s0, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	add	a0, a0, a3
	c.li	zero, 2
	lw	a3, 0(a1)
	mul	a4, a4, s5
	add	a0, a0, a4
	mul	a4, s0, s1
	add	s3, a4, a0
	lw	s4, 16(a2)
	lw	s5, 20(a2)
	lw	s0, 24(a2)
	c.li	zero, 3
	lw	a7, 28(a2)
	add	a1, a1, ra
	mul	a3, a3, s2
	lw	a0, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	add	a3, a3, s3
	lw	a4, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	mul	a0, a0, s4
	lw	s1, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	add	a0, a0, a3
	c.li	zero, 2
	lw	a3, 0(a1)
	mul	a4, a4, s5
	add	a0, a0, a4
	mul	a4, s1, s0
	add	s3, a4, a0
	lw	s4, 32(a2)
	lw	s5, 36(a2)
	lw	s1, 40(a2)
	c.li	zero, 3
	lw	s2, 44(a2)
	add	a1, a1, ra
	mul	a3, a3, a7
	lw	a0, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	add	a3, a3, s3
	lw	a4, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	mul	a0, a0, s4
	lw	s0, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	add	a0, a0, a3
	c.li	zero, 2
	lw	a7, 0(a1)
	mul	a4, a4, s5
	add	a0, a0, a4
	mul	a4, s0, s1
	add	s3, a4, a0
	lw	s4, 48(a2)
	lw	s6, 52(a2)
	lw	s0, 56(a2)
	c.li	zero, 3
	lw	s5, 60(a2)
	add	a1, a1, ra
	mul	a0, a7, s2
	lw	a4, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	add	a0, a0, s3
	lw	a3, 0(a1)
	c.li	zero, 2
	add	a1, a1, ra
	mul	a4, a4, s4
	c.li	zero, 3
	lw	s1, 0(a1)
	add	a0, a0, a4
	mul	a3, a3, s6
	add	a0, a0, a3
	c.li	zero, 2
	mul	a3, s1, s0
	add	a1, a1, ra
	c.li	zero, 4
	lw	a1, 0(a1)
	addi	t4, t4, -32
	add	t5, t5, t1
	add	a0, a0, a3
	mul	a7, a1, s5
	c.li	zero, 2
	add	a7, a7, a0
	addi	a2, a2, 128
	bne	s11, t4, .LBB0_92
# %bb.93:                               #   in Loop: Header=BB0_8 Depth=1
	bnez	t0, .LBB0_94
	j	.LBB0_4
.LBB0_94:                               #   in Loop: Header=BB0_8 Depth=1
	c.li	zero, 3
	neg	s0, t4
	mv	a2, s10
	li	a3, 32
.LBB0_95:                               #   in Loop: Header=BB0_8 Depth=1
	c.li	zero, 2
	slli	a0, s0, 2
	mul	a1, s0, t3
	c.li	zero, 2
	add	a0, a0, t6
	slli	a1, a1, 2
	c.li	zero, 2
	lw	a0, 0(a0)
	add	a1, a1, a6
	lw	a1, 0(a1)
	mul	a0, a1, a0
	add	a7, a7, a0
	li	a0, 1
	bne	t0, a0, .LBB0_96
	j	.LBB0_6
.LBB0_96:                               #   in Loop: Header=BB0_8 Depth=1
	addi	a0, s0, 1
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, a6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 2
	bne	t0, a0, .LBB0_97
	j	.LBB0_6
.LBB0_97:                               #   in Loop: Header=BB0_8 Depth=1
	addi	a0, s0, 2
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, a6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 3
	bne	t0, a0, .LBB0_98
	j	.LBB0_6
.LBB0_98:                               #   in Loop: Header=BB0_8 Depth=1
	addi	a0, s0, 3
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, a6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 4
	bne	t0, a0, .LBB0_99
	j	.LBB0_6
.LBB0_99:                               #   in Loop: Header=BB0_8 Depth=1
	addi	a0, s0, 4
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, a6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 5
	bne	t0, a0, .LBB0_100
	j	.LBB0_6
.LBB0_100:                              #   in Loop: Header=BB0_8 Depth=1
	addi	a0, s0, 5
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, a6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 6
	bne	t0, a0, .LBB0_101
	j	.LBB0_6
.LBB0_101:                              #   in Loop: Header=BB0_8 Depth=1
	addi	a0, s0, 6
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, a6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 7
	bne	t0, a0, .LBB0_102
	j	.LBB0_6
.LBB0_102:                              #   in Loop: Header=BB0_8 Depth=1
	addi	a0, s0, 7
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, a6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 8
	bne	t0, a0, .LBB0_103
	j	.LBB0_6
.LBB0_103:                              #   in Loop: Header=BB0_8 Depth=1
	addi	a0, s0, 8
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, a6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 9
	bne	t0, a0, .LBB0_104
	j	.LBB0_6
.LBB0_104:                              #   in Loop: Header=BB0_8 Depth=1
	addi	a0, s0, 9
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, a6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 10
	bne	t0, a0, .LBB0_105
	j	.LBB0_6
.LBB0_105:                              #   in Loop: Header=BB0_8 Depth=1
	addi	a0, s0, 10
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, a6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 11
	bne	t0, a0, .LBB0_106
	j	.LBB0_6
.LBB0_106:                              #   in Loop: Header=BB0_8 Depth=1
	addi	a0, s0, 11
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, a6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 12
	bne	t0, a0, .LBB0_107
	j	.LBB0_6
.LBB0_107:                              #   in Loop: Header=BB0_8 Depth=1
	addi	a0, s0, 12
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, a6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 13
	bne	t0, a0, .LBB0_108
	j	.LBB0_6
.LBB0_108:                              #   in Loop: Header=BB0_8 Depth=1
	addi	a0, s0, 13
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, a6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 14
	bne	t0, a0, .LBB0_109
	j	.LBB0_6
.LBB0_109:                              #   in Loop: Header=BB0_8 Depth=1
	addi	a0, s0, 14
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, a6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 15
	bne	t0, a0, .LBB0_110
	j	.LBB0_6
.LBB0_110:                              #   in Loop: Header=BB0_8 Depth=1
	addi	a0, s0, 15
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, a6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 16
	bne	t0, a0, .LBB0_111
	j	.LBB0_6
.LBB0_111:                              #   in Loop: Header=BB0_8 Depth=1
	addi	a0, s0, 16
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, a6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 17
	bne	t0, a0, .LBB0_112
	j	.LBB0_6
.LBB0_112:                              #   in Loop: Header=BB0_8 Depth=1
	addi	a0, s0, 17
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, a6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 18
	bne	t0, a0, .LBB0_113
	j	.LBB0_5
.LBB0_113:                              #   in Loop: Header=BB0_8 Depth=1
	addi	a0, s0, 18
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, a6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 19
	bne	t0, a0, .LBB0_114
	j	.LBB0_5
.LBB0_114:                              #   in Loop: Header=BB0_8 Depth=1
	addi	a0, s0, 19
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, a6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 20
	bne	t0, a0, .LBB0_115
	j	.LBB0_5
.LBB0_115:                              #   in Loop: Header=BB0_8 Depth=1
	addi	a0, s0, 20
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, a6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 21
	bne	t0, a0, .LBB0_116
	j	.LBB0_5
.LBB0_116:                              #   in Loop: Header=BB0_8 Depth=1
	addi	a0, s0, 21
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, a6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 22
	bne	t0, a0, .LBB0_117
	j	.LBB0_5
.LBB0_117:                              #   in Loop: Header=BB0_8 Depth=1
	addi	a0, s0, 22
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, a6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 23
	bne	t0, a0, .LBB0_118
	j	.LBB0_5
.LBB0_118:                              #   in Loop: Header=BB0_8 Depth=1
	addi	a0, s0, 23
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, a6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 24
	bne	t0, a0, .LBB0_119
	j	.LBB0_5
.LBB0_119:                              #   in Loop: Header=BB0_8 Depth=1
	addi	a0, s0, 24
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, a6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 25
	bne	t0, a0, .LBB0_120
	j	.LBB0_5
.LBB0_120:                              #   in Loop: Header=BB0_8 Depth=1
	addi	a0, s0, 25
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, a6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 26
	bne	t0, a0, .LBB0_121
	j	.LBB0_5
.LBB0_121:                              #   in Loop: Header=BB0_8 Depth=1
	addi	a0, s0, 26
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, a6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 27
	bne	t0, a0, .LBB0_122
	j	.LBB0_5
.LBB0_122:                              #   in Loop: Header=BB0_8 Depth=1
	addi	a0, s0, 27
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, a6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 28
	bne	t0, a0, .LBB0_123
	j	.LBB0_5
.LBB0_123:                              #   in Loop: Header=BB0_8 Depth=1
	addi	a0, s0, 28
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, a6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 29
	bne	t0, a0, .LBB0_124
	j	.LBB0_5
.LBB0_124:                              #   in Loop: Header=BB0_8 Depth=1
	addi	a0, s0, 29
	slli	a1, a0, 2
	c.li	zero, 2
	mul	a0, a0, t3
	add	a1, a1, t6
	slli	a0, a0, 2
	c.li	zero, 2
	lw	a1, 0(a1)
	add	a0, a0, a6
	lw	a0, 0(a0)
	mul	a0, a0, a1
	add	a7, a7, a0
	li	a0, 30
	bne	t0, a0, .LBB0_125
	j	.LBB0_5
.LBB0_125:                              #   in Loop: Header=BB0_8 Depth=1
	addi	s0, s0, 30
	c.li	zero, 2
	slli	a0, s0, 2
	mul	a1, s0, t3
	c.li	zero, 2
	add	a0, a0, t6
	slli	a1, a1, 2
	c.li	zero, 2
	lw	a0, 0(a0)
	add	a1, a1, a6
	lw	a1, 0(a1)
	mul	a0, a1, a0
	add	a7, a7, a0
	j	.LBB0_5
.LBB0_126:
	addi	t0, t3, -1
	c.li	zero, 2
	andi	a6, s9, 3
	li	a7, 4
	c.li	zero, 2
	andi	a0, t3, 31
	li	a5, 0
	bltu	s9, a7, .LBB0_278
# %bb.127:
	lui	s6, 524288
	lw	a1, 28(sp)                      # 4-byte Folded Reload
	c.li	zero, 4
	addi	a4, a1, 64
	slli	s7, t3, 4
	slli	s8, t3, 2
	slli	s0, t3, 3
	c.li	zero, 4
	li	s1, 31
	li	s5, 1
	li	t1, 2
	li	t2, 3
	c.li	zero, 4
	li	ra, 5
	li	t4, 6
	li	t5, 7
	li	t6, 8
	c.li	zero, 4
	li	s2, 9
	li	s3, 10
	li	s4, 11
	addi	a2, s6, -4
	addi	a3, s6, -32
	c.li	zero, 2
	and	s10, s9, a2
	add	s6, a4, s8
	add	s8, s8, s0
	add	s0, s0, a4
	c.li	zero, 2
	and	a3, t3, a3
	add	s9, a4, s8
	neg	s8, a3
	j	.LBB0_129
.LBB0_128:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 4
	addi	a5, a5, 4
	add	a4, a4, s7
	add	s6, s6, s7
	add	s0, s0, s7
	add	s9, s9, s7
	beq	a5, s10, .LBB0_277
.LBB0_129:                              # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_132 Depth 2
                                        #     Child Loop BB0_169 Depth 2
                                        #     Child Loop BB0_206 Depth 2
                                        #     Child Loop BB0_243 Depth 2
	bgeu	t0, s1, .LBB0_131
# %bb.130:                              #   in Loop: Header=BB0_129 Depth=1
	li	a2, 0
	j	.LBB0_135
.LBB0_131:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	li	a3, 0
	mv	s11, a4
.LBB0_132:                              #   Parent Loop BB0_129 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	sw	zero, -64(s11)
	sw	zero, -60(s11)
	sw	zero, -56(s11)
	sw	zero, -52(s11)
	sw	zero, -48(s11)
	sw	zero, -44(s11)
	sw	zero, -40(s11)
	sw	zero, -36(s11)
	sw	zero, -32(s11)
	sw	zero, -28(s11)
	sw	zero, -24(s11)
	sw	zero, -20(s11)
	sw	zero, -16(s11)
	sw	zero, -12(s11)
	sw	zero, -8(s11)
	sw	zero, -4(s11)
	sw	zero, 0(s11)
	sw	zero, 4(s11)
	sw	zero, 8(s11)
	sw	zero, 12(s11)
	sw	zero, 16(s11)
	sw	zero, 20(s11)
	sw	zero, 24(s11)
	sw	zero, 28(s11)
	sw	zero, 32(s11)
	sw	zero, 36(s11)
	sw	zero, 40(s11)
	sw	zero, 44(s11)
	sw	zero, 48(s11)
	sw	zero, 52(s11)
	sw	zero, 56(s11)
	c.li	zero, 2
	sw	zero, 60(s11)
	addi	a3, a3, -32
	addi	s11, s11, 128
	bne	s8, a3, .LBB0_132
# %bb.133:                              #   in Loop: Header=BB0_129 Depth=1
	beqz	a0, .LBB0_166
# %bb.134:                              #   in Loop: Header=BB0_129 Depth=1
	neg	a2, a3
.LBB0_135:                              #   in Loop: Header=BB0_129 Depth=1
	mul	a3, a5, t3
	slli	a3, a3, 2
	lw	a1, 28(sp)                      # 4-byte Folded Reload
	c.li	zero, 2
	add	a3, a3, a1
	slli	a2, a2, 2
	add	a3, a3, a2
	sw	zero, 0(a3)
	beq	a0, s5, .LBB0_166
# %bb.136:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 4(a3)
	beq	a0, t1, .LBB0_166
# %bb.137:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 8(a3)
	beq	a0, t2, .LBB0_166
# %bb.138:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 12(a3)
	beq	a0, a7, .LBB0_166
# %bb.139:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 16(a3)
	beq	a0, ra, .LBB0_166
# %bb.140:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 20(a3)
	beq	a0, t4, .LBB0_166
# %bb.141:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 24(a3)
	beq	a0, t5, .LBB0_166
# %bb.142:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 28(a3)
	beq	a0, t6, .LBB0_166
# %bb.143:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 32(a3)
	beq	a0, s2, .LBB0_166
# %bb.144:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 36(a3)
	beq	a0, s3, .LBB0_166
# %bb.145:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 40(a3)
	beq	a0, s4, .LBB0_166
# %bb.146:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 44(a3)
	li	a1, 12
	beq	a0, a1, .LBB0_166
# %bb.147:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 48(a3)
	li	a1, 13
	beq	a0, a1, .LBB0_166
# %bb.148:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 52(a3)
	li	a1, 14
	beq	a0, a1, .LBB0_166
# %bb.149:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 56(a3)
	li	a1, 15
	beq	a0, a1, .LBB0_166
# %bb.150:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 60(a3)
	li	a1, 16
	beq	a0, a1, .LBB0_166
# %bb.151:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 64(a3)
	li	a1, 17
	beq	a0, a1, .LBB0_166
# %bb.152:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 68(a3)
	li	a1, 18
	beq	a0, a1, .LBB0_166
# %bb.153:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 72(a3)
	li	a1, 19
	beq	a0, a1, .LBB0_166
# %bb.154:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 76(a3)
	li	a1, 20
	beq	a0, a1, .LBB0_166
# %bb.155:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 80(a3)
	li	a1, 21
	beq	a0, a1, .LBB0_166
# %bb.156:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 84(a3)
	li	a1, 22
	beq	a0, a1, .LBB0_166
# %bb.157:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 88(a3)
	li	a1, 23
	beq	a0, a1, .LBB0_166
# %bb.158:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 92(a3)
	li	a1, 24
	beq	a0, a1, .LBB0_166
# %bb.159:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 96(a3)
	li	a1, 25
	beq	a0, a1, .LBB0_166
# %bb.160:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 100(a3)
	li	a1, 26
	beq	a0, a1, .LBB0_166
# %bb.161:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 104(a3)
	li	a1, 27
	beq	a0, a1, .LBB0_166
# %bb.162:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 108(a3)
	li	a1, 28
	beq	a0, a1, .LBB0_166
# %bb.163:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 112(a3)
	li	a1, 29
	beq	a0, a1, .LBB0_166
# %bb.164:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 116(a3)
	li	a1, 30
	beq	a0, a1, .LBB0_166
# %bb.165:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 120(a3)
.LBB0_166:                              #   in Loop: Header=BB0_129 Depth=1
	bgeu	t0, s1, .LBB0_168
# %bb.167:                              #   in Loop: Header=BB0_129 Depth=1
	li	a2, 0
	j	.LBB0_172
.LBB0_168:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	li	a3, 0
	mv	a2, s6
.LBB0_169:                              #   Parent Loop BB0_129 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	sw	zero, -64(a2)
	sw	zero, -60(a2)
	sw	zero, -56(a2)
	sw	zero, -52(a2)
	sw	zero, -48(a2)
	sw	zero, -44(a2)
	sw	zero, -40(a2)
	sw	zero, -36(a2)
	sw	zero, -32(a2)
	sw	zero, -28(a2)
	sw	zero, -24(a2)
	sw	zero, -20(a2)
	sw	zero, -16(a2)
	sw	zero, -12(a2)
	sw	zero, -8(a2)
	sw	zero, -4(a2)
	sw	zero, 0(a2)
	sw	zero, 4(a2)
	sw	zero, 8(a2)
	sw	zero, 12(a2)
	sw	zero, 16(a2)
	sw	zero, 20(a2)
	sw	zero, 24(a2)
	sw	zero, 28(a2)
	sw	zero, 32(a2)
	sw	zero, 36(a2)
	sw	zero, 40(a2)
	sw	zero, 44(a2)
	sw	zero, 48(a2)
	sw	zero, 52(a2)
	sw	zero, 56(a2)
	c.li	zero, 2
	sw	zero, 60(a2)
	addi	a3, a3, -32
	addi	a2, a2, 128
	bne	s8, a3, .LBB0_169
# %bb.170:                              #   in Loop: Header=BB0_129 Depth=1
	beqz	a0, .LBB0_203
# %bb.171:                              #   in Loop: Header=BB0_129 Depth=1
	neg	a2, a3
.LBB0_172:                              #   in Loop: Header=BB0_129 Depth=1
	addi	a3, a5, 1
	mul	a3, a3, t3
	slli	a3, a3, 2
	lw	a1, 28(sp)                      # 4-byte Folded Reload
	c.li	zero, 2
	add	a3, a3, a1
	slli	a2, a2, 2
	add	a3, a3, a2
	sw	zero, 0(a3)
	beq	a0, s5, .LBB0_203
# %bb.173:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 4(a3)
	beq	a0, t1, .LBB0_203
# %bb.174:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 8(a3)
	beq	a0, t2, .LBB0_203
# %bb.175:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 12(a3)
	beq	a0, a7, .LBB0_203
# %bb.176:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 16(a3)
	beq	a0, ra, .LBB0_203
# %bb.177:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 20(a3)
	beq	a0, t4, .LBB0_203
# %bb.178:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 24(a3)
	beq	a0, t5, .LBB0_203
# %bb.179:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 28(a3)
	beq	a0, t6, .LBB0_203
# %bb.180:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 32(a3)
	beq	a0, s2, .LBB0_203
# %bb.181:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 36(a3)
	beq	a0, s3, .LBB0_203
# %bb.182:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 40(a3)
	beq	a0, s4, .LBB0_203
# %bb.183:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 44(a3)
	li	a1, 12
	beq	a0, a1, .LBB0_203
# %bb.184:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 48(a3)
	li	a1, 13
	beq	a0, a1, .LBB0_203
# %bb.185:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 52(a3)
	li	a1, 14
	beq	a0, a1, .LBB0_203
# %bb.186:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 56(a3)
	li	a1, 15
	beq	a0, a1, .LBB0_203
# %bb.187:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 60(a3)
	li	a1, 16
	beq	a0, a1, .LBB0_203
# %bb.188:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 64(a3)
	li	a1, 17
	beq	a0, a1, .LBB0_203
# %bb.189:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 68(a3)
	li	a1, 18
	beq	a0, a1, .LBB0_203
# %bb.190:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 72(a3)
	li	a1, 19
	beq	a0, a1, .LBB0_203
# %bb.191:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 76(a3)
	li	a1, 20
	beq	a0, a1, .LBB0_203
# %bb.192:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 80(a3)
	li	a1, 21
	beq	a0, a1, .LBB0_203
# %bb.193:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 84(a3)
	li	a1, 22
	beq	a0, a1, .LBB0_203
# %bb.194:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 88(a3)
	li	a1, 23
	beq	a0, a1, .LBB0_203
# %bb.195:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 92(a3)
	li	a1, 24
	beq	a0, a1, .LBB0_203
# %bb.196:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 96(a3)
	li	a1, 25
	beq	a0, a1, .LBB0_203
# %bb.197:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 100(a3)
	li	a1, 26
	beq	a0, a1, .LBB0_203
# %bb.198:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 104(a3)
	li	a1, 27
	beq	a0, a1, .LBB0_203
# %bb.199:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 108(a3)
	li	a1, 28
	beq	a0, a1, .LBB0_203
# %bb.200:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 112(a3)
	li	a1, 29
	beq	a0, a1, .LBB0_203
# %bb.201:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 116(a3)
	li	a1, 30
	beq	a0, a1, .LBB0_203
# %bb.202:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 120(a3)
.LBB0_203:                              #   in Loop: Header=BB0_129 Depth=1
	bgeu	t0, s1, .LBB0_205
# %bb.204:                              #   in Loop: Header=BB0_129 Depth=1
	li	a2, 0
	j	.LBB0_209
.LBB0_205:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	li	a3, 0
	mv	a2, s0
.LBB0_206:                              #   Parent Loop BB0_129 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	sw	zero, -64(a2)
	sw	zero, -60(a2)
	sw	zero, -56(a2)
	sw	zero, -52(a2)
	sw	zero, -48(a2)
	sw	zero, -44(a2)
	sw	zero, -40(a2)
	sw	zero, -36(a2)
	sw	zero, -32(a2)
	sw	zero, -28(a2)
	sw	zero, -24(a2)
	sw	zero, -20(a2)
	sw	zero, -16(a2)
	sw	zero, -12(a2)
	sw	zero, -8(a2)
	sw	zero, -4(a2)
	sw	zero, 0(a2)
	sw	zero, 4(a2)
	sw	zero, 8(a2)
	sw	zero, 12(a2)
	sw	zero, 16(a2)
	sw	zero, 20(a2)
	sw	zero, 24(a2)
	sw	zero, 28(a2)
	sw	zero, 32(a2)
	sw	zero, 36(a2)
	sw	zero, 40(a2)
	sw	zero, 44(a2)
	sw	zero, 48(a2)
	sw	zero, 52(a2)
	sw	zero, 56(a2)
	c.li	zero, 2
	sw	zero, 60(a2)
	addi	a3, a3, -32
	addi	a2, a2, 128
	bne	s8, a3, .LBB0_206
# %bb.207:                              #   in Loop: Header=BB0_129 Depth=1
	beqz	a0, .LBB0_240
# %bb.208:                              #   in Loop: Header=BB0_129 Depth=1
	neg	a2, a3
.LBB0_209:                              #   in Loop: Header=BB0_129 Depth=1
	addi	a3, a5, 2
	mul	a3, a3, t3
	slli	a3, a3, 2
	lw	a1, 28(sp)                      # 4-byte Folded Reload
	c.li	zero, 2
	add	a3, a3, a1
	slli	a2, a2, 2
	add	a3, a3, a2
	sw	zero, 0(a3)
	beq	a0, s5, .LBB0_240
# %bb.210:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 4(a3)
	beq	a0, t1, .LBB0_240
# %bb.211:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 8(a3)
	beq	a0, t2, .LBB0_240
# %bb.212:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 12(a3)
	beq	a0, a7, .LBB0_240
# %bb.213:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 16(a3)
	beq	a0, ra, .LBB0_240
# %bb.214:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 20(a3)
	beq	a0, t4, .LBB0_240
# %bb.215:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 24(a3)
	beq	a0, t5, .LBB0_240
# %bb.216:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 28(a3)
	beq	a0, t6, .LBB0_240
# %bb.217:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 32(a3)
	beq	a0, s2, .LBB0_240
# %bb.218:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 36(a3)
	beq	a0, s3, .LBB0_240
# %bb.219:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 40(a3)
	beq	a0, s4, .LBB0_240
# %bb.220:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 44(a3)
	li	a1, 12
	beq	a0, a1, .LBB0_240
# %bb.221:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 48(a3)
	li	a1, 13
	beq	a0, a1, .LBB0_240
# %bb.222:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 52(a3)
	li	a1, 14
	beq	a0, a1, .LBB0_240
# %bb.223:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 56(a3)
	li	a1, 15
	beq	a0, a1, .LBB0_240
# %bb.224:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 60(a3)
	li	a1, 16
	beq	a0, a1, .LBB0_240
# %bb.225:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 64(a3)
	li	a1, 17
	beq	a0, a1, .LBB0_240
# %bb.226:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 68(a3)
	li	a1, 18
	beq	a0, a1, .LBB0_240
# %bb.227:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 72(a3)
	li	a1, 19
	beq	a0, a1, .LBB0_240
# %bb.228:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 76(a3)
	li	a1, 20
	beq	a0, a1, .LBB0_240
# %bb.229:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 80(a3)
	li	a1, 21
	beq	a0, a1, .LBB0_240
# %bb.230:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 84(a3)
	li	a1, 22
	beq	a0, a1, .LBB0_240
# %bb.231:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 88(a3)
	li	a1, 23
	beq	a0, a1, .LBB0_240
# %bb.232:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 92(a3)
	li	a1, 24
	beq	a0, a1, .LBB0_240
# %bb.233:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 96(a3)
	li	a1, 25
	beq	a0, a1, .LBB0_240
# %bb.234:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 100(a3)
	li	a1, 26
	beq	a0, a1, .LBB0_240
# %bb.235:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 104(a3)
	li	a1, 27
	beq	a0, a1, .LBB0_240
# %bb.236:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 108(a3)
	li	a1, 28
	beq	a0, a1, .LBB0_240
# %bb.237:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 112(a3)
	li	a1, 29
	beq	a0, a1, .LBB0_240
# %bb.238:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 116(a3)
	li	a1, 30
	beq	a0, a1, .LBB0_240
# %bb.239:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 120(a3)
.LBB0_240:                              #   in Loop: Header=BB0_129 Depth=1
	bgeu	t0, s1, .LBB0_242
# %bb.241:                              #   in Loop: Header=BB0_129 Depth=1
	li	a2, 0
	j	.LBB0_246
.LBB0_242:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	li	a3, 0
	mv	a2, s9
.LBB0_243:                              #   Parent Loop BB0_129 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	sw	zero, -64(a2)
	sw	zero, -60(a2)
	sw	zero, -56(a2)
	sw	zero, -52(a2)
	sw	zero, -48(a2)
	sw	zero, -44(a2)
	sw	zero, -40(a2)
	sw	zero, -36(a2)
	sw	zero, -32(a2)
	sw	zero, -28(a2)
	sw	zero, -24(a2)
	sw	zero, -20(a2)
	sw	zero, -16(a2)
	sw	zero, -12(a2)
	sw	zero, -8(a2)
	sw	zero, -4(a2)
	sw	zero, 0(a2)
	sw	zero, 4(a2)
	sw	zero, 8(a2)
	sw	zero, 12(a2)
	sw	zero, 16(a2)
	sw	zero, 20(a2)
	sw	zero, 24(a2)
	sw	zero, 28(a2)
	sw	zero, 32(a2)
	sw	zero, 36(a2)
	sw	zero, 40(a2)
	sw	zero, 44(a2)
	sw	zero, 48(a2)
	sw	zero, 52(a2)
	sw	zero, 56(a2)
	c.li	zero, 2
	sw	zero, 60(a2)
	addi	a3, a3, -32
	addi	a2, a2, 128
	bne	s8, a3, .LBB0_243
# %bb.244:                              #   in Loop: Header=BB0_129 Depth=1
	beqz	a0, .LBB0_128
# %bb.245:                              #   in Loop: Header=BB0_129 Depth=1
	neg	a2, a3
.LBB0_246:                              #   in Loop: Header=BB0_129 Depth=1
	addi	a3, a5, 3
	mul	a3, a3, t3
	slli	a3, a3, 2
	lw	a1, 28(sp)                      # 4-byte Folded Reload
	c.li	zero, 2
	add	a3, a3, a1
	slli	a2, a2, 2
	add	a3, a3, a2
	sw	zero, 0(a3)
	beq	a0, s5, .LBB0_128
# %bb.247:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 4(a3)
	beq	a0, t1, .LBB0_128
# %bb.248:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 8(a3)
	beq	a0, t2, .LBB0_128
# %bb.249:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 12(a3)
	beq	a0, a7, .LBB0_128
# %bb.250:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 16(a3)
	beq	a0, ra, .LBB0_128
# %bb.251:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 20(a3)
	beq	a0, t4, .LBB0_128
# %bb.252:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 24(a3)
	beq	a0, t5, .LBB0_128
# %bb.253:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 28(a3)
	beq	a0, t6, .LBB0_128
# %bb.254:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 32(a3)
	beq	a0, s2, .LBB0_128
# %bb.255:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 36(a3)
	beq	a0, s3, .LBB0_128
# %bb.256:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 40(a3)
	beq	a0, s4, .LBB0_128
# %bb.257:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 44(a3)
	li	a1, 12
	beq	a0, a1, .LBB0_128
# %bb.258:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 48(a3)
	li	a1, 13
	beq	a0, a1, .LBB0_128
# %bb.259:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 52(a3)
	li	a1, 14
	beq	a0, a1, .LBB0_128
# %bb.260:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 56(a3)
	li	a1, 15
	beq	a0, a1, .LBB0_128
# %bb.261:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 60(a3)
	li	a1, 16
	beq	a0, a1, .LBB0_128
# %bb.262:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 64(a3)
	li	a1, 17
	beq	a0, a1, .LBB0_128
# %bb.263:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 68(a3)
	li	a1, 18
	beq	a0, a1, .LBB0_128
# %bb.264:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 72(a3)
	li	a1, 19
	beq	a0, a1, .LBB0_128
# %bb.265:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 76(a3)
	li	a1, 20
	beq	a0, a1, .LBB0_128
# %bb.266:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 80(a3)
	li	a1, 21
	beq	a0, a1, .LBB0_128
# %bb.267:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 84(a3)
	li	a1, 22
	beq	a0, a1, .LBB0_128
# %bb.268:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 88(a3)
	li	a1, 23
	beq	a0, a1, .LBB0_128
# %bb.269:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 92(a3)
	li	a1, 24
	beq	a0, a1, .LBB0_128
# %bb.270:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 96(a3)
	li	a1, 25
	beq	a0, a1, .LBB0_128
# %bb.271:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 100(a3)
	li	a1, 26
	beq	a0, a1, .LBB0_128
# %bb.272:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 104(a3)
	li	a1, 27
	beq	a0, a1, .LBB0_128
# %bb.273:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 108(a3)
	li	a1, 28
	beq	a0, a1, .LBB0_128
# %bb.274:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 112(a3)
	li	a1, 29
	beq	a0, a1, .LBB0_128
# %bb.275:                              #   in Loop: Header=BB0_129 Depth=1
	c.li	zero, 2
	sw	zero, 116(a3)
	li	a1, 30
	beq	a0, a1, .LBB0_128
# %bb.276:                              #   in Loop: Header=BB0_129 Depth=1
	sw	zero, 120(a3)
	j	.LBB0_128
.LBB0_277:
	beqz	a6, .LBB0_389
.LBB0_278:
	mul	a1, a5, t3
	c.li	zero, 2
	slli	a1, a1, 2
	li	a2, 31
	lw	a3, 28(sp)                      # 4-byte Folded Reload
	add	a1, a1, a3
	bgeu	t0, a2, .LBB0_280
# %bb.279:
	c.li	zero, 2
	mv	a1, a1
	li	a2, 1
	sw	zero, 0(a1)
	bne	a0, a2, .LBB0_284
	j	.LBB0_314
.LBB0_280:
	li	a2, 0
	lui	a3, 524288
	addi	a3, a3, -32
	and	a3, t3, a3
	c.li	zero, 2
	neg	a3, a3
	addi	s1, a1, 64
.LBB0_281:                              # =>This Inner Loop Header: Depth=1
	sw	zero, -64(s1)
	sw	zero, -60(s1)
	sw	zero, -56(s1)
	sw	zero, -52(s1)
	sw	zero, -48(s1)
	sw	zero, -44(s1)
	sw	zero, -40(s1)
	sw	zero, -36(s1)
	sw	zero, -32(s1)
	sw	zero, -28(s1)
	sw	zero, -24(s1)
	sw	zero, -20(s1)
	sw	zero, -16(s1)
	sw	zero, -12(s1)
	sw	zero, -8(s1)
	sw	zero, -4(s1)
	sw	zero, 0(s1)
	sw	zero, 4(s1)
	sw	zero, 8(s1)
	sw	zero, 12(s1)
	sw	zero, 16(s1)
	sw	zero, 20(s1)
	sw	zero, 24(s1)
	sw	zero, 28(s1)
	sw	zero, 32(s1)
	sw	zero, 36(s1)
	sw	zero, 40(s1)
	sw	zero, 44(s1)
	sw	zero, 48(s1)
	sw	zero, 52(s1)
	sw	zero, 56(s1)
	c.li	zero, 2
	sw	zero, 60(s1)
	addi	a2, a2, -32
	addi	s1, s1, 128
	bne	a3, a2, .LBB0_281
# %bb.282:
	beqz	a0, .LBB0_314
# %bb.283:
	neg	a2, a2
	slli	a2, a2, 2
	add	a1, a1, a2
	li	a2, 1
	sw	zero, 0(a1)
	beq	a0, a2, .LBB0_314
.LBB0_284:
	li	a2, 2
	sw	zero, 4(a1)
	beq	a0, a2, .LBB0_314
# %bb.285:
	li	a2, 3
	sw	zero, 8(a1)
	beq	a0, a2, .LBB0_314
# %bb.286:
	li	a2, 4
	sw	zero, 12(a1)
	beq	a0, a2, .LBB0_314
# %bb.287:
	li	a2, 5
	sw	zero, 16(a1)
	beq	a0, a2, .LBB0_314
# %bb.288:
	li	a2, 6
	sw	zero, 20(a1)
	beq	a0, a2, .LBB0_314
# %bb.289:
	li	a2, 7
	sw	zero, 24(a1)
	beq	a0, a2, .LBB0_314
# %bb.290:
	li	a2, 8
	sw	zero, 28(a1)
	beq	a0, a2, .LBB0_314
# %bb.291:
	li	a2, 9
	sw	zero, 32(a1)
	beq	a0, a2, .LBB0_314
# %bb.292:
	li	a2, 10
	sw	zero, 36(a1)
	beq	a0, a2, .LBB0_314
# %bb.293:
	li	a2, 11
	sw	zero, 40(a1)
	beq	a0, a2, .LBB0_314
# %bb.294:
	li	a2, 12
	sw	zero, 44(a1)
	beq	a0, a2, .LBB0_314
# %bb.295:
	li	a2, 13
	sw	zero, 48(a1)
	beq	a0, a2, .LBB0_314
# %bb.296:
	li	a2, 14
	sw	zero, 52(a1)
	beq	a0, a2, .LBB0_314
# %bb.297:
	li	a2, 15
	sw	zero, 56(a1)
	beq	a0, a2, .LBB0_314
# %bb.298:
	li	a2, 16
	sw	zero, 60(a1)
	beq	a0, a2, .LBB0_314
# %bb.299:
	li	a2, 17
	sw	zero, 64(a1)
	beq	a0, a2, .LBB0_314
# %bb.300:
	li	a2, 18
	sw	zero, 68(a1)
	beq	a0, a2, .LBB0_314
# %bb.301:
	li	a2, 19
	sw	zero, 72(a1)
	beq	a0, a2, .LBB0_314
# %bb.302:
	li	a2, 20
	sw	zero, 76(a1)
	beq	a0, a2, .LBB0_314
# %bb.303:
	li	a2, 21
	sw	zero, 80(a1)
	beq	a0, a2, .LBB0_314
# %bb.304:
	li	a2, 22
	sw	zero, 84(a1)
	beq	a0, a2, .LBB0_314
# %bb.305:
	li	a2, 23
	sw	zero, 88(a1)
	beq	a0, a2, .LBB0_314
# %bb.306:
	li	a2, 24
	sw	zero, 92(a1)
	beq	a0, a2, .LBB0_314
# %bb.307:
	li	a2, 25
	sw	zero, 96(a1)
	beq	a0, a2, .LBB0_314
# %bb.308:
	li	a2, 26
	sw	zero, 100(a1)
	beq	a0, a2, .LBB0_314
# %bb.309:
	li	a2, 27
	sw	zero, 104(a1)
	beq	a0, a2, .LBB0_314
# %bb.310:
	li	a2, 28
	sw	zero, 108(a1)
	beq	a0, a2, .LBB0_314
# %bb.311:
	li	a2, 29
	sw	zero, 112(a1)
	beq	a0, a2, .LBB0_314
# %bb.312:
	li	a2, 30
	sw	zero, 116(a1)
	beq	a0, a2, .LBB0_314
# %bb.313:
	sw	zero, 120(a1)
.LBB0_314:
	li	a1, 1
	beq	a6, a1, .LBB0_389
# %bb.315:
	addi	a1, a5, 1
	mul	a1, a1, t3
	c.li	zero, 2
	slli	a1, a1, 2
	li	a2, 31
	lw	a3, 28(sp)                      # 4-byte Folded Reload
	add	a1, a1, a3
	bgeu	t0, a2, .LBB0_317
# %bb.316:
	c.li	zero, 2
	mv	a1, a1
	li	a2, 1
	sw	zero, 0(a1)
	bne	a0, a2, .LBB0_321
	j	.LBB0_351
.LBB0_317:
	li	a2, 0
	lui	a3, 524288
	addi	a3, a3, -32
	and	a3, t3, a3
	c.li	zero, 2
	neg	a3, a3
	addi	s1, a1, 64
.LBB0_318:                              # =>This Inner Loop Header: Depth=1
	sw	zero, -64(s1)
	sw	zero, -60(s1)
	sw	zero, -56(s1)
	sw	zero, -52(s1)
	sw	zero, -48(s1)
	sw	zero, -44(s1)
	sw	zero, -40(s1)
	sw	zero, -36(s1)
	sw	zero, -32(s1)
	sw	zero, -28(s1)
	sw	zero, -24(s1)
	sw	zero, -20(s1)
	sw	zero, -16(s1)
	sw	zero, -12(s1)
	sw	zero, -8(s1)
	sw	zero, -4(s1)
	sw	zero, 0(s1)
	sw	zero, 4(s1)
	sw	zero, 8(s1)
	sw	zero, 12(s1)
	sw	zero, 16(s1)
	sw	zero, 20(s1)
	sw	zero, 24(s1)
	sw	zero, 28(s1)
	sw	zero, 32(s1)
	sw	zero, 36(s1)
	sw	zero, 40(s1)
	sw	zero, 44(s1)
	sw	zero, 48(s1)
	sw	zero, 52(s1)
	sw	zero, 56(s1)
	c.li	zero, 2
	sw	zero, 60(s1)
	addi	a2, a2, -32
	addi	s1, s1, 128
	bne	a3, a2, .LBB0_318
# %bb.319:
	beqz	a0, .LBB0_351
# %bb.320:
	neg	a2, a2
	slli	a2, a2, 2
	add	a1, a1, a2
	li	a2, 1
	sw	zero, 0(a1)
	beq	a0, a2, .LBB0_351
.LBB0_321:
	li	a2, 2
	sw	zero, 4(a1)
	beq	a0, a2, .LBB0_351
# %bb.322:
	li	a2, 3
	sw	zero, 8(a1)
	beq	a0, a2, .LBB0_351
# %bb.323:
	li	a2, 4
	sw	zero, 12(a1)
	beq	a0, a2, .LBB0_351
# %bb.324:
	li	a2, 5
	sw	zero, 16(a1)
	beq	a0, a2, .LBB0_351
# %bb.325:
	li	a2, 6
	sw	zero, 20(a1)
	beq	a0, a2, .LBB0_351
# %bb.326:
	li	a2, 7
	sw	zero, 24(a1)
	beq	a0, a2, .LBB0_351
# %bb.327:
	li	a2, 8
	sw	zero, 28(a1)
	beq	a0, a2, .LBB0_351
# %bb.328:
	li	a2, 9
	sw	zero, 32(a1)
	beq	a0, a2, .LBB0_351
# %bb.329:
	li	a2, 10
	sw	zero, 36(a1)
	beq	a0, a2, .LBB0_351
# %bb.330:
	li	a2, 11
	sw	zero, 40(a1)
	beq	a0, a2, .LBB0_351
# %bb.331:
	li	a2, 12
	sw	zero, 44(a1)
	beq	a0, a2, .LBB0_351
# %bb.332:
	li	a2, 13
	sw	zero, 48(a1)
	beq	a0, a2, .LBB0_351
# %bb.333:
	li	a2, 14
	sw	zero, 52(a1)
	beq	a0, a2, .LBB0_351
# %bb.334:
	li	a2, 15
	sw	zero, 56(a1)
	beq	a0, a2, .LBB0_351
# %bb.335:
	li	a2, 16
	sw	zero, 60(a1)
	beq	a0, a2, .LBB0_351
# %bb.336:
	li	a2, 17
	sw	zero, 64(a1)
	beq	a0, a2, .LBB0_351
# %bb.337:
	li	a2, 18
	sw	zero, 68(a1)
	beq	a0, a2, .LBB0_351
# %bb.338:
	li	a2, 19
	sw	zero, 72(a1)
	beq	a0, a2, .LBB0_351
# %bb.339:
	li	a2, 20
	sw	zero, 76(a1)
	beq	a0, a2, .LBB0_351
# %bb.340:
	li	a2, 21
	sw	zero, 80(a1)
	beq	a0, a2, .LBB0_351
# %bb.341:
	li	a2, 22
	sw	zero, 84(a1)
	beq	a0, a2, .LBB0_351
# %bb.342:
	li	a2, 23
	sw	zero, 88(a1)
	beq	a0, a2, .LBB0_351
# %bb.343:
	li	a2, 24
	sw	zero, 92(a1)
	beq	a0, a2, .LBB0_351
# %bb.344:
	li	a2, 25
	sw	zero, 96(a1)
	beq	a0, a2, .LBB0_351
# %bb.345:
	li	a2, 26
	sw	zero, 100(a1)
	beq	a0, a2, .LBB0_351
# %bb.346:
	li	a2, 27
	sw	zero, 104(a1)
	beq	a0, a2, .LBB0_351
# %bb.347:
	li	a2, 28
	sw	zero, 108(a1)
	beq	a0, a2, .LBB0_351
# %bb.348:
	li	a2, 29
	sw	zero, 112(a1)
	beq	a0, a2, .LBB0_351
# %bb.349:
	li	a2, 30
	sw	zero, 116(a1)
	beq	a0, a2, .LBB0_351
# %bb.350:
	sw	zero, 120(a1)
.LBB0_351:
	li	a1, 2
	beq	a6, a1, .LBB0_389
# %bb.352:
	addi	a5, a5, 2
	mul	a1, a5, t3
	c.li	zero, 2
	slli	a1, a1, 2
	li	a2, 31
	lw	a3, 28(sp)                      # 4-byte Folded Reload
	add	a1, a1, a3
	bgeu	t0, a2, .LBB0_354
# %bb.353:
	li	a2, 0
	j	.LBB0_358
.LBB0_354:
	li	a2, 0
	lui	a3, 524288
	addi	a3, a3, -32
	and	a3, t3, a3
	c.li	zero, 2
	neg	a3, a3
	addi	a4, a1, 64
.LBB0_355:                              # =>This Inner Loop Header: Depth=1
	sw	zero, -64(a4)
	sw	zero, -60(a4)
	sw	zero, -56(a4)
	sw	zero, -52(a4)
	sw	zero, -48(a4)
	sw	zero, -44(a4)
	sw	zero, -40(a4)
	sw	zero, -36(a4)
	sw	zero, -32(a4)
	sw	zero, -28(a4)
	sw	zero, -24(a4)
	sw	zero, -20(a4)
	sw	zero, -16(a4)
	sw	zero, -12(a4)
	sw	zero, -8(a4)
	sw	zero, -4(a4)
	sw	zero, 0(a4)
	sw	zero, 4(a4)
	sw	zero, 8(a4)
	sw	zero, 12(a4)
	sw	zero, 16(a4)
	sw	zero, 20(a4)
	sw	zero, 24(a4)
	sw	zero, 28(a4)
	sw	zero, 32(a4)
	sw	zero, 36(a4)
	sw	zero, 40(a4)
	sw	zero, 44(a4)
	sw	zero, 48(a4)
	sw	zero, 52(a4)
	sw	zero, 56(a4)
	c.li	zero, 2
	sw	zero, 60(a4)
	addi	a2, a2, -32
	addi	a4, a4, 128
	bne	a3, a2, .LBB0_355
# %bb.356:
	beqz	a0, .LBB0_389
# %bb.357:
	neg	a2, a2
.LBB0_358:
	slli	a2, a2, 2
	add	a1, a1, a2
	li	a2, 1
	sw	zero, 0(a1)
	beq	a0, a2, .LBB0_389
# %bb.359:
	li	a2, 2
	sw	zero, 4(a1)
	beq	a0, a2, .LBB0_389
# %bb.360:
	li	a2, 3
	sw	zero, 8(a1)
	beq	a0, a2, .LBB0_389
# %bb.361:
	li	a2, 4
	sw	zero, 12(a1)
	beq	a0, a2, .LBB0_389
# %bb.362:
	li	a2, 5
	sw	zero, 16(a1)
	beq	a0, a2, .LBB0_389
# %bb.363:
	li	a2, 6
	sw	zero, 20(a1)
	beq	a0, a2, .LBB0_389
# %bb.364:
	li	a2, 7
	sw	zero, 24(a1)
	beq	a0, a2, .LBB0_389
# %bb.365:
	li	a2, 8
	sw	zero, 28(a1)
	beq	a0, a2, .LBB0_389
# %bb.366:
	li	a2, 9
	sw	zero, 32(a1)
	beq	a0, a2, .LBB0_389
# %bb.367:
	li	a2, 10
	sw	zero, 36(a1)
	beq	a0, a2, .LBB0_389
# %bb.368:
	li	a2, 11
	sw	zero, 40(a1)
	beq	a0, a2, .LBB0_389
# %bb.369:
	li	a2, 12
	sw	zero, 44(a1)
	beq	a0, a2, .LBB0_389
# %bb.370:
	li	a2, 13
	sw	zero, 48(a1)
	beq	a0, a2, .LBB0_389
# %bb.371:
	li	a2, 14
	sw	zero, 52(a1)
	beq	a0, a2, .LBB0_389
# %bb.372:
	li	a2, 15
	sw	zero, 56(a1)
	beq	a0, a2, .LBB0_389
# %bb.373:
	li	a2, 16
	sw	zero, 60(a1)
	beq	a0, a2, .LBB0_389
# %bb.374:
	li	a2, 17
	sw	zero, 64(a1)
	beq	a0, a2, .LBB0_389
# %bb.375:
	li	a2, 18
	sw	zero, 68(a1)
	beq	a0, a2, .LBB0_389
# %bb.376:
	li	a2, 19
	sw	zero, 72(a1)
	beq	a0, a2, .LBB0_389
# %bb.377:
	li	a2, 20
	sw	zero, 76(a1)
	beq	a0, a2, .LBB0_389
# %bb.378:
	li	a2, 21
	sw	zero, 80(a1)
	beq	a0, a2, .LBB0_389
# %bb.379:
	li	a2, 22
	sw	zero, 84(a1)
	beq	a0, a2, .LBB0_389
# %bb.380:
	li	a2, 23
	sw	zero, 88(a1)
	beq	a0, a2, .LBB0_389
# %bb.381:
	li	a2, 24
	sw	zero, 92(a1)
	beq	a0, a2, .LBB0_389
# %bb.382:
	li	a2, 25
	sw	zero, 96(a1)
	beq	a0, a2, .LBB0_389
# %bb.383:
	li	a2, 26
	sw	zero, 100(a1)
	beq	a0, a2, .LBB0_389
# %bb.384:
	li	a2, 27
	sw	zero, 104(a1)
	beq	a0, a2, .LBB0_389
# %bb.385:
	li	a2, 28
	sw	zero, 108(a1)
	beq	a0, a2, .LBB0_389
# %bb.386:
	li	a2, 29
	sw	zero, 112(a1)
	beq	a0, a2, .LBB0_389
# %bb.387:
	li	a2, 30
	sw	zero, 116(a1)
	beq	a0, a2, .LBB0_389
# %bb.388:
	sw	zero, 120(a1)
.LBB0_389:
	lw	ra, 92(sp)                      # 4-byte Folded Reload
	lw	s0, 88(sp)                      # 4-byte Folded Reload
	lw	s1, 84(sp)                      # 4-byte Folded Reload
	lw	s2, 80(sp)                      # 4-byte Folded Reload
	lw	s3, 76(sp)                      # 4-byte Folded Reload
	lw	s4, 72(sp)                      # 4-byte Folded Reload
	lw	s5, 68(sp)                      # 4-byte Folded Reload
	lw	s6, 64(sp)                      # 4-byte Folded Reload
	lw	s7, 60(sp)                      # 4-byte Folded Reload
	lw	s8, 56(sp)                      # 4-byte Folded Reload
	lw	s9, 52(sp)                      # 4-byte Folded Reload
	lw	s10, 48(sp)                     # 4-byte Folded Reload
	lw	s11, 44(sp)                     # 4-byte Folded Reload
	addi	sp, sp, 96
	ret
.Lfunc_end0:
	.size	matmul_i32, .Lfunc_end0-matmul_i32
                                        # -- End function
	.ident	"clang version 23.0.0git (ssh://git@github.com/llvm/llvm-project.git d3081aafc47eccba242ffc3cc43ecfcb545a51bb)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
