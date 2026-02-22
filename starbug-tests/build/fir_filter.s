	.attribute	4, 16
	.attribute	5, "rv32i2p1_m2p0_a2p1_c2p0_zmmul1p0_zaamo1p0_zalrsc1p0_zca1p0"
	.file	"fir_filter.c"
	.text
	.globl	fir_filter_i32                  # -- Begin function fir_filter_i32
	.p2align	1
	.type	fir_filter_i32,@function
fir_filter_i32:                         # @fir_filter_i32
# %bb.0:
	bgtz	a3, .LBB0_1
	j	.LBB0_526
.LBB0_1:
	addi	sp, sp, -64
	sw	ra, 60(sp)                      # 4-byte Folded Spill
	sw	s0, 56(sp)                      # 4-byte Folded Spill
	sw	s1, 52(sp)                      # 4-byte Folded Spill
	sw	s2, 48(sp)                      # 4-byte Folded Spill
	sw	s3, 44(sp)                      # 4-byte Folded Spill
	sw	s4, 40(sp)                      # 4-byte Folded Spill
	sw	s5, 36(sp)                      # 4-byte Folded Spill
	sw	s6, 32(sp)                      # 4-byte Folded Spill
	sw	s7, 28(sp)                      # 4-byte Folded Spill
	sw	s8, 24(sp)                      # 4-byte Folded Spill
	sw	s9, 20(sp)                      # 4-byte Folded Spill
	sw	s10, 16(sp)                     # 4-byte Folded Spill
	sw	s11, 12(sp)                     # 4-byte Folded Spill
	bgtz	a4, .LBB0_2
	j	.LBB0_327
.LBB0_2:
	li	s6, 1
	c.li	zero, 2
	andi	a6, a4, 31
	li	a7, 0
	bne	a3, s6, .LBB0_3
	j	.LBB0_364
.LBB0_3:
	andi	t0, a3, 1
	c.li	zero, 4
	lui	a5, 524288
	addi	t1, a0, -60
	addi	t2, a1, 64
	addi	t3, a0, -56
	c.li	zero, 4
	li	t4, 32
	li	t5, 2
	li	t6, 3
	li	s8, 4
	c.li	zero, 3
	li	s9, 5
	li	s2, 6
	addi	s0, a5, -2
	c.li	zero, 2
	and	s7, a3, s0
	addi	a5, a5, -32
	and	a5, a5, a4
	neg	s11, a5
	j	.LBB0_5
.LBB0_4:                                #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 3
	slli	ra, ra, 2
	addi	a7, a7, 2
	addi	t1, t1, 8
	add	ra, ra, a2
	c.li	zero, 2
	sw	s10, 0(ra)
	addi	t3, t3, 8
	bne	a7, s7, .LBB0_5
	j	.LBB0_363
.LBB0_5:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_100 Depth 2
                                        #     Child Loop BB0_261 Depth 2
	bgeu	a4, t4, .LBB0_98
# %bb.6:                                #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 3
	li	s0, 0
	li	s5, 0
	mv	a3, a7
	bltz	a7, .LBB0_8
.LBB0_7:                                #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a3, a3, 2
	slli	a5, s0, 2
	c.li	zero, 2
	add	a3, a3, a0
	add	a5, a5, a1
	lw	a3, 0(a3)
	lw	a5, 0(a5)
	mul	a3, a5, a3
	add	s5, s5, a3
.LBB0_8:                                #   in Loop: Header=BB0_5 Depth=1
	beq	a6, s6, .LBB0_166
# %bb.9:                                #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 1
	sub	a5, a7, a3
	bltz	a5, .LBB0_11
# %bb.10:                               #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s5, s5, a3
.LBB0_11:                               #   in Loop: Header=BB0_5 Depth=1
	beq	a6, t5, .LBB0_166
# %bb.12:                               #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 2
	sub	a5, a7, a3
	bltz	a5, .LBB0_14
# %bb.13:                               #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s5, s5, a3
.LBB0_14:                               #   in Loop: Header=BB0_5 Depth=1
	beq	a6, t6, .LBB0_166
# %bb.15:                               #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 3
	sub	a5, a7, a3
	bltz	a5, .LBB0_17
# %bb.16:                               #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s5, s5, a3
.LBB0_17:                               #   in Loop: Header=BB0_5 Depth=1
	beq	a6, s8, .LBB0_166
# %bb.18:                               #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 4
	sub	a5, a7, a3
	bltz	a5, .LBB0_20
# %bb.19:                               #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s5, s5, a3
.LBB0_20:                               #   in Loop: Header=BB0_5 Depth=1
	beq	a6, s9, .LBB0_166
# %bb.21:                               #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 5
	sub	a5, a7, a3
	bltz	a5, .LBB0_23
# %bb.22:                               #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s5, s5, a3
.LBB0_23:                               #   in Loop: Header=BB0_5 Depth=1
	beq	a6, s2, .LBB0_166
# %bb.24:                               #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 6
	sub	a5, a7, a3
	bltz	a5, .LBB0_26
# %bb.25:                               #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s5, s5, a3
.LBB0_26:                               #   in Loop: Header=BB0_5 Depth=1
	li	a3, 7
	beq	a6, a3, .LBB0_166
# %bb.27:                               #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 7
	sub	a5, a7, a3
	bltz	a5, .LBB0_29
# %bb.28:                               #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s5, s5, a3
.LBB0_29:                               #   in Loop: Header=BB0_5 Depth=1
	li	a3, 8
	beq	a6, a3, .LBB0_166
# %bb.30:                               #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 8
	sub	a5, a7, a3
	bltz	a5, .LBB0_32
# %bb.31:                               #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s5, s5, a3
.LBB0_32:                               #   in Loop: Header=BB0_5 Depth=1
	li	a3, 9
	beq	a6, a3, .LBB0_166
# %bb.33:                               #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 9
	sub	a5, a7, a3
	bltz	a5, .LBB0_35
# %bb.34:                               #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s5, s5, a3
.LBB0_35:                               #   in Loop: Header=BB0_5 Depth=1
	li	a3, 10
	beq	a6, a3, .LBB0_166
# %bb.36:                               #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 10
	sub	a5, a7, a3
	bltz	a5, .LBB0_38
# %bb.37:                               #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s5, s5, a3
.LBB0_38:                               #   in Loop: Header=BB0_5 Depth=1
	li	a3, 11
	beq	a6, a3, .LBB0_166
# %bb.39:                               #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 11
	sub	a5, a7, a3
	bltz	a5, .LBB0_41
# %bb.40:                               #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s5, s5, a3
.LBB0_41:                               #   in Loop: Header=BB0_5 Depth=1
	li	a3, 12
	beq	a6, a3, .LBB0_166
# %bb.42:                               #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 12
	sub	a5, a7, a3
	bltz	a5, .LBB0_44
# %bb.43:                               #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s5, s5, a3
.LBB0_44:                               #   in Loop: Header=BB0_5 Depth=1
	li	a3, 13
	beq	a6, a3, .LBB0_166
# %bb.45:                               #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 13
	sub	a5, a7, a3
	bltz	a5, .LBB0_47
# %bb.46:                               #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s5, s5, a3
.LBB0_47:                               #   in Loop: Header=BB0_5 Depth=1
	li	a3, 14
	beq	a6, a3, .LBB0_166
# %bb.48:                               #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 14
	sub	a5, a7, a3
	bltz	a5, .LBB0_50
# %bb.49:                               #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s5, s5, a3
.LBB0_50:                               #   in Loop: Header=BB0_5 Depth=1
	li	a3, 15
	beq	a6, a3, .LBB0_166
# %bb.51:                               #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 15
	sub	a5, a7, a3
	bltz	a5, .LBB0_53
# %bb.52:                               #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s5, s5, a3
.LBB0_53:                               #   in Loop: Header=BB0_5 Depth=1
	li	a3, 16
	beq	a6, a3, .LBB0_166
# %bb.54:                               #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 16
	sub	a5, a7, a3
	bltz	a5, .LBB0_56
# %bb.55:                               #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s5, s5, a3
.LBB0_56:                               #   in Loop: Header=BB0_5 Depth=1
	li	a3, 17
	beq	a6, a3, .LBB0_166
# %bb.57:                               #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 17
	sub	a5, a7, a3
	bltz	a5, .LBB0_59
# %bb.58:                               #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s5, s5, a3
.LBB0_59:                               #   in Loop: Header=BB0_5 Depth=1
	li	a3, 18
	beq	a6, a3, .LBB0_166
# %bb.60:                               #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 18
	sub	a5, a7, a3
	bltz	a5, .LBB0_62
# %bb.61:                               #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s5, s5, a3
.LBB0_62:                               #   in Loop: Header=BB0_5 Depth=1
	li	a3, 19
	beq	a6, a3, .LBB0_166
# %bb.63:                               #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 19
	sub	a5, a7, a3
	bltz	a5, .LBB0_65
# %bb.64:                               #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s5, s5, a3
.LBB0_65:                               #   in Loop: Header=BB0_5 Depth=1
	li	a3, 20
	beq	a6, a3, .LBB0_166
# %bb.66:                               #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 20
	sub	a5, a7, a3
	bltz	a5, .LBB0_68
# %bb.67:                               #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s5, s5, a3
.LBB0_68:                               #   in Loop: Header=BB0_5 Depth=1
	li	a3, 21
	beq	a6, a3, .LBB0_166
# %bb.69:                               #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 21
	sub	a5, a7, a3
	bltz	a5, .LBB0_71
# %bb.70:                               #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s5, s5, a3
.LBB0_71:                               #   in Loop: Header=BB0_5 Depth=1
	li	a3, 22
	beq	a6, a3, .LBB0_166
# %bb.72:                               #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 22
	sub	a5, a7, a3
	bltz	a5, .LBB0_74
# %bb.73:                               #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s5, s5, a3
.LBB0_74:                               #   in Loop: Header=BB0_5 Depth=1
	li	a3, 23
	beq	a6, a3, .LBB0_166
# %bb.75:                               #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 23
	sub	a5, a7, a3
	bltz	a5, .LBB0_77
# %bb.76:                               #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s5, s5, a3
.LBB0_77:                               #   in Loop: Header=BB0_5 Depth=1
	li	a3, 24
	beq	a6, a3, .LBB0_166
# %bb.78:                               #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 24
	sub	a5, a7, a3
	bltz	a5, .LBB0_80
# %bb.79:                               #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s5, s5, a3
.LBB0_80:                               #   in Loop: Header=BB0_5 Depth=1
	li	a3, 25
	beq	a6, a3, .LBB0_166
# %bb.81:                               #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 25
	sub	a5, a7, a3
	bltz	a5, .LBB0_83
# %bb.82:                               #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s5, s5, a3
.LBB0_83:                               #   in Loop: Header=BB0_5 Depth=1
	li	a3, 26
	beq	a6, a3, .LBB0_166
# %bb.84:                               #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 26
	sub	a5, a7, a3
	bltz	a5, .LBB0_86
# %bb.85:                               #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s5, s5, a3
.LBB0_86:                               #   in Loop: Header=BB0_5 Depth=1
	li	a3, 27
	beq	a6, a3, .LBB0_166
# %bb.87:                               #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 27
	sub	a5, a7, a3
	bltz	a5, .LBB0_89
# %bb.88:                               #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s5, s5, a3
.LBB0_89:                               #   in Loop: Header=BB0_5 Depth=1
	li	a3, 28
	beq	a6, a3, .LBB0_166
# %bb.90:                               #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 28
	sub	a5, a7, a3
	bltz	a5, .LBB0_92
# %bb.91:                               #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5 
	add	s5, s5, a3
.LBB0_92:                               #   in Loop: Header=BB0_5 Depth=1
	li	a3, 29
	beq	a6, a3, .LBB0_166
# %bb.93:                               #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 29
	sub	a5, a7, a3
	bltz	a5, .LBB0_95
# %bb.94:                               #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s5, s5, a3
.LBB0_95:                               #   in Loop: Header=BB0_5 Depth=1
	li	a3, 30
	beq	a6, a3, .LBB0_166
# %bb.96:                               #   in Loop: Header=BB0_5 Depth=1
	addi	s0, s0, 30
	sub	a3, a7, s0
	bltz	a3, .LBB0_166
# %bb.97:                               #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a3, a3, 2
	slli	s0, s0, 2
	c.li	zero, 2
	add	a3, a3, a0
	add	s0, s0, a1
	lw	a3, 0(a3)
	lw	a5, 0(s0)
	mul	a3, a5, a3
	add	s5, s5, a3
	j	.LBB0_166
.LBB0_98:                               #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 4
	li	ra, 0
	li	s5, 0
	addi	s10, a7, -124
	mv	a5, t2
	mv	a3, t1
	j	.LBB0_100
.LBB0_99:                               #   in Loop: Header=BB0_100 Depth=2
	c.li	zero, 3
	addi	ra, ra, -32
	addi	a3, a3, -128
	addi	a5, a5, 128
	beq	s11, ra, .LBB0_164
.LBB0_100:                              #   Parent Loop BB0_5 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	add	s0, a7, ra
	bltz	s0, .LBB0_102
# %bb.101:                              #   in Loop: Header=BB0_100 Depth=2
	lw	s0, 60(a3)
	lw	s1, -64(a5)
	mul	s0, s1, s0
	add	s5, s5, s0
.LBB0_102:                              #   in Loop: Header=BB0_100 Depth=2
	add	s0, s10, ra
	addi	s1, s0, 123
	bltz	s1, .LBB0_104
# %bb.103:                              #   in Loop: Header=BB0_100 Depth=2
	lw	s1, 56(a3)
	lw	s4, -60(a5)
	mul	s1, s4, s1
	add	s5, s5, s1
.LBB0_104:                              #   in Loop: Header=BB0_100 Depth=2
	addi	s1, s0, 122
	bltz	s1, .LBB0_106
# %bb.105:                              #   in Loop: Header=BB0_100 Depth=2
	lw	s4, 52(a3)
	lw	s1, -56(a5)
	mul	s1, s1, s4
	add	s5, s5, s1
.LBB0_106:                              #   in Loop: Header=BB0_100 Depth=2
	addi	s1, s0, 121
	bltz	s1, .LBB0_108
# %bb.107:                              #   in Loop: Header=BB0_100 Depth=2
	lw	s4, 48(a3)
	lw	s1, -52(a5)
	mul	s1, s1, s4
	add	s5, s5, s1
.LBB0_108:                              #   in Loop: Header=BB0_100 Depth=2
	addi	s1, s0, 120
	bltz	s1, .LBB0_110
# %bb.109:                              #   in Loop: Header=BB0_100 Depth=2
	lw	s4, 44(a3)
	lw	s1, -48(a5)
	mul	s1, s1, s4
	add	s5, s5, s1
.LBB0_110:                              #   in Loop: Header=BB0_100 Depth=2
	addi	s1, s0, 119
	bltz	s1, .LBB0_112
# %bb.111:                              #   in Loop: Header=BB0_100 Depth=2
	lw	s4, 40(a3)
	lw	s1, -44(a5)
	mul	s1, s1, s4
	add	s5, s5, s1
.LBB0_112:                              #   in Loop: Header=BB0_100 Depth=2
	addi	s1, s0, 118
	bltz	s1, .LBB0_114
# %bb.113:                              #   in Loop: Header=BB0_100 Depth=2
	lw	s4, 36(a3)
	lw	s1, -40(a5)
	mul	s1, s1, s4
	add	s5, s5, s1
.LBB0_114:                              #   in Loop: Header=BB0_100 Depth=2
	addi	s1, s0, 117
	bltz	s1, .LBB0_116
# %bb.115:                              #   in Loop: Header=BB0_100 Depth=2
	lw	s4, 32(a3)
	lw	s1, -36(a5)
	mul	s1, s1, s4
	add	s5, s5, s1
.LBB0_116:                              #   in Loop: Header=BB0_100 Depth=2
	addi	s1, s0, 116
	bltz	s1, .LBB0_118
# %bb.117:                              #   in Loop: Header=BB0_100 Depth=2
	lw	s4, 28(a3)
	lw	s1, -32(a5)
	mul	s1, s1, s4
	add	s5, s5, s1
.LBB0_118:                              #   in Loop: Header=BB0_100 Depth=2
	addi	s1, s0, 115
	bltz	s1, .LBB0_120
# %bb.119:                              #   in Loop: Header=BB0_100 Depth=2
	lw	s4, 24(a3)
	lw	s1, -28(a5)
	mul	s1, s1, s4
	add	s5, s5, s1
.LBB0_120:                              #   in Loop: Header=BB0_100 Depth=2
	addi	s1, s0, 114
	bltz	s1, .LBB0_122
# %bb.121:                              #   in Loop: Header=BB0_100 Depth=2
	lw	s4, 20(a3)
	lw	s1, -24(a5)
	mul	s1, s1, s4
	add	s5, s5, s1
.LBB0_122:                              #   in Loop: Header=BB0_100 Depth=2
	addi	s1, s0, 113
	bltz	s1, .LBB0_124
# %bb.123:                              #   in Loop: Header=BB0_100 Depth=2
	lw	s4, 16(a3)
	lw	s1, -20(a5)
	mul	s1, s1, s4
	add	s5, s5, s1
.LBB0_124:                              #   in Loop: Header=BB0_100 Depth=2
	addi	s1, s0, 112
	bltz	s1, .LBB0_126
# %bb.125:                              #   in Loop: Header=BB0_100 Depth=2
	lw	s4, 12(a3)
	lw	s1, -16(a5)
	mul	s1, s1, s4
	add	s5, s5, s1
.LBB0_126:                              #   in Loop: Header=BB0_100 Depth=2
	addi	s1, s0, 111
	bltz	s1, .LBB0_128
# %bb.127:                              #   in Loop: Header=BB0_100 Depth=2
	lw	s4, 8(a3)
	lw	s1, -12(a5)
	mul	s1, s1, s4
	add	s5, s5, s1
.LBB0_128:                              #   in Loop: Header=BB0_100 Depth=2
	addi	s1, s0, 110
	bltz	s1, .LBB0_130
# %bb.129:                              #   in Loop: Header=BB0_100 Depth=2
	lw	s4, 4(a3)
	lw	s1, -8(a5)
	mul	s1, s1, s4
	add	s5, s5, s1
.LBB0_130:                              #   in Loop: Header=BB0_100 Depth=2
	addi	s1, s0, 109
	bltz	s1, .LBB0_132
# %bb.131:                              #   in Loop: Header=BB0_100 Depth=2
	lw	s4, 0(a3)
	lw	s1, -4(a5)
	mul	s1, s1, s4
	add	s5, s5, s1
.LBB0_132:                              #   in Loop: Header=BB0_100 Depth=2
	addi	s1, s0, 108
	bltz	s1, .LBB0_134
# %bb.133:                              #   in Loop: Header=BB0_100 Depth=2
	lw	s4, -4(a3)
	lw	s1, 0(a5)
	mul	s1, s1, s4
	add	s5, s5, s1
.LBB0_134:                              #   in Loop: Header=BB0_100 Depth=2
	addi	s1, s0, 107
	bltz	s1, .LBB0_136
# %bb.135:                              #   in Loop: Header=BB0_100 Depth=2
	lw	s4, -8(a3)
	lw	s1, 4(a5)
	mul	s1, s1, s4
	add	s5, s5, s1
.LBB0_136:                              #   in Loop: Header=BB0_100 Depth=2
	addi	s1, s0, 106
	bltz	s1, .LBB0_138
# %bb.137:                              #   in Loop: Header=BB0_100 Depth=2
	lw	s4, -12(a3)
	lw	s1, 8(a5)
	mul	s1, s1, s4
	add	s5, s5, s1
.LBB0_138:                              #   in Loop: Header=BB0_100 Depth=2
	addi	s1, s0, 105
	bltz	s1, .LBB0_140
# %bb.139:                              #   in Loop: Header=BB0_100 Depth=2
	lw	s4, -16(a3)
	lw	s1, 12(a5)
	mul	s1, s1, s4
	add	s5, s5, s1
.LBB0_140:                              #   in Loop: Header=BB0_100 Depth=2
	addi	s1, s0, 104
	bltz	s1, .LBB0_142
# %bb.141:                              #   in Loop: Header=BB0_100 Depth=2
	lw	s4, -20(a3)
	lw	s1, 16(a5)
	mul	s1, s1, s4
	add	s5, s5, s1
.LBB0_142:                              #   in Loop: Header=BB0_100 Depth=2
	addi	s1, s0, 103
	bltz	s1, .LBB0_144
# %bb.143:                              #   in Loop: Header=BB0_100 Depth=2
	lw	s4, -24(a3)
	lw	s1, 20(a5)
	mul	s1, s1, s4
	add	s5, s5, s1
.LBB0_144:                              #   in Loop: Header=BB0_100 Depth=2
	addi	s1, s0, 102
	bltz	s1, .LBB0_146
# %bb.145:                              #   in Loop: Header=BB0_100 Depth=2
	lw	s4, -28(a3)
	lw	s1, 24(a5)
	mul	s1, s1, s4
	add	s5, s5, s1
.LBB0_146:                              #   in Loop: Header=BB0_100 Depth=2
	addi	s1, s0, 101
	bltz	s1, .LBB0_148
# %bb.147:                              #   in Loop: Header=BB0_100 Depth=2
	lw	s4, -32(a3)
	lw	s1, 28(a5)
	mul	s1, s1, s4
	add	s5, s5, s1
.LBB0_148:                              #   in Loop: Header=BB0_100 Depth=2
	addi	s1, s0, 100
	bltz	s1, .LBB0_150
# %bb.149:                              #   in Loop: Header=BB0_100 Depth=2
	lw	s4, -36(a3)
	lw	s1, 32(a5)
	mul	s1, s1, s4
	add	s5, s5, s1
.LBB0_150:                              #   in Loop: Header=BB0_100 Depth=2
	addi	s1, s0, 99
	bltz	s1, .LBB0_152
# %bb.151:                              #   in Loop: Header=BB0_100 Depth=2
	lw	s4, -40(a3)
	lw	s1, 36(a5)
	mul	s1, s1, s4
	add	s5, s5, s1
.LBB0_152:                              #   in Loop: Header=BB0_100 Depth=2
	addi	s1, s0, 98
	bltz	s1, .LBB0_154
# %bb.153:                              #   in Loop: Header=BB0_100 Depth=2
	lw	s4, -44(a3)
	lw	s1, 40(a5)
	mul	s1, s1, s4
	add	s5, s5, s1
.LBB0_154:                              #   in Loop: Header=BB0_100 Depth=2
	addi	s1, s0, 97
	bltz	s1, .LBB0_156
# %bb.155:                              #   in Loop: Header=BB0_100 Depth=2
	lw	s4, -48(a3)
	lw	s1, 44(a5)
	mul	s1, s1, s4
	add	s5, s5, s1
.LBB0_156:                              #   in Loop: Header=BB0_100 Depth=2
	addi	s1, s0, 96
	bltz	s1, .LBB0_158
# %bb.157:                              #   in Loop: Header=BB0_100 Depth=2
	lw	s4, -52(a3)
	lw	s1, 48(a5)
	mul	s1, s1, s4
	add	s5, s5, s1
.LBB0_158:                              #   in Loop: Header=BB0_100 Depth=2
	addi	s1, s0, 95
	bltz	s1, .LBB0_160
# %bb.159:                              #   in Loop: Header=BB0_100 Depth=2
	lw	s4, -56(a3)
	lw	s1, 52(a5)
	mul	s1, s1, s4
	add	s5, s5, s1
.LBB0_160:                              #   in Loop: Header=BB0_100 Depth=2
	addi	s1, s0, 94
	bltz	s1, .LBB0_162
# %bb.161:                              #   in Loop: Header=BB0_100 Depth=2
	lw	s4, -60(a3)
	lw	s1, 56(a5)
	mul	s1, s1, s4
	add	s5, s5, s1
.LBB0_162:                              #   in Loop: Header=BB0_100 Depth=2
	addi	s0, s0, 93
	bltz	s0, .LBB0_99
# %bb.163:                              #   in Loop: Header=BB0_100 Depth=2
	lw	s0, -64(a3)
	lw	s1, 60(a5)
	mul	s0, s1, s0
	add	s5, s5, s0
	j	.LBB0_99
.LBB0_164:                              #   in Loop: Header=BB0_5 Depth=1
	beqz	a6, .LBB0_166
# %bb.165:                              #   in Loop: Header=BB0_5 Depth=1
	neg	s0, ra
	sub	a3, a7, s0
	bgez	a3, .LBB0_7
	j	.LBB0_8
.LBB0_166:                              #   in Loop: Header=BB0_5 Depth=1
	slli	a3, a7, 2
	add	a3, a3, a2
	c.li	zero, 2
	sw	s5, 0(a3)
	addi	ra, a7, 1
	bgeu	a4, t4, .LBB0_259
# %bb.167:                              #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 3
	li	s0, 0
	li	s10, 0
	mv	a3, ra
	bltz	ra, .LBB0_169
.LBB0_168:                              #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a3, a3, 2
	slli	a5, s0, 2
	c.li	zero, 2
	add	a3, a3, a0
	add	a5, a5, a1
	lw	a3, 0(a3)
	lw	a5, 0(a5)
	mul	a3, a5, a3
	add	s10, s10, a3
.LBB0_169:                              #   in Loop: Header=BB0_5 Depth=1
	beq	a6, s6, .LBB0_4
# %bb.170:                              #   in Loop: Header=BB0_5 Depth=1
	sub	a3, a7, s0
	bltz	a3, .LBB0_172
# %bb.171:                              #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a3, a3, 2
	slli	a5, s0, 2
	c.li	zero, 2
	add	a3, a3, a0
	add	a5, a5, a1
	lw	a3, 0(a3)
	lw	a5, 4(a5)
	mul	a3, a5, a3
	add	s10, s10, a3
.LBB0_172:                              #   in Loop: Header=BB0_5 Depth=1
	beq	a6, t5, .LBB0_4
# %bb.173:                              #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 2
	sub	a5, ra, a3
	bltz	a5, .LBB0_175
# %bb.174:                              #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s10, s10, a3
.LBB0_175:                              #   in Loop: Header=BB0_5 Depth=1
	beq	a6, t6, .LBB0_4
# %bb.176:                              #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 3
	sub	a5, ra, a3
	bltz	a5, .LBB0_178
# %bb.177:                              #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s10, s10, a3
.LBB0_178:                              #   in Loop: Header=BB0_5 Depth=1
	beq	a6, s8, .LBB0_4
# %bb.179:                              #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 4
	sub	a5, ra, a3
	bltz	a5, .LBB0_181
# %bb.180:                              #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s10, s10, a3
.LBB0_181:                              #   in Loop: Header=BB0_5 Depth=1
	beq	a6, s9, .LBB0_4
# %bb.182:                              #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 5
	sub	a5, ra, a3
	bltz	a5, .LBB0_184
# %bb.183:                              #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s10, s10, a3
.LBB0_184:                              #   in Loop: Header=BB0_5 Depth=1
	beq	a6, s2, .LBB0_4
# %bb.185:                              #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 6
	sub	a5, ra, a3
	bltz	a5, .LBB0_187
# %bb.186:                              #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s10, s10, a3
.LBB0_187:                              #   in Loop: Header=BB0_5 Depth=1
	li	a3, 7
	beq	a6, a3, .LBB0_4
# %bb.188:                              #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 7
	sub	a5, ra, a3
	bltz	a5, .LBB0_190
# %bb.189:                              #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s10, s10, a3
.LBB0_190:                              #   in Loop: Header=BB0_5 Depth=1
	li	a3, 8
	beq	a6, a3, .LBB0_4
# %bb.191:                              #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 8
	sub	a5, ra, a3
	bltz	a5, .LBB0_193
# %bb.192:                              #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s10, s10, a3
.LBB0_193:                              #   in Loop: Header=BB0_5 Depth=1
	li	a3, 9
	beq	a6, a3, .LBB0_4
# %bb.194:                              #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 9
	sub	a5, ra, a3
	bltz	a5, .LBB0_196
# %bb.195:                              #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s10, s10, a3
.LBB0_196:                              #   in Loop: Header=BB0_5 Depth=1
	li	a3, 10
	beq	a6, a3, .LBB0_4
# %bb.197:                              #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 10
	sub	a5, ra, a3
	bltz	a5, .LBB0_199
# %bb.198:                              #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s10, s10, a3
.LBB0_199:                              #   in Loop: Header=BB0_5 Depth=1
	li	a3, 11
	beq	a6, a3, .LBB0_4
# %bb.200:                              #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 11
	sub	a5, ra, a3
	bltz	a5, .LBB0_202
# %bb.201:                              #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s10, s10, a3
.LBB0_202:                              #   in Loop: Header=BB0_5 Depth=1
	li	a3, 12
	beq	a6, a3, .LBB0_4
# %bb.203:                              #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 12
	sub	a5, ra, a3
	bltz	a5, .LBB0_205
# %bb.204:                              #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s10, s10, a3
.LBB0_205:                              #   in Loop: Header=BB0_5 Depth=1
	li	a3, 13
	beq	a6, a3, .LBB0_4
# %bb.206:                              #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 13
	sub	a5, ra, a3
	bltz	a5, .LBB0_208
# %bb.207:                              #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s10, s10, a3
.LBB0_208:                              #   in Loop: Header=BB0_5 Depth=1
	li	a3, 14
	beq	a6, a3, .LBB0_4
# %bb.209:                              #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 14
	sub	a5, ra, a3
	bltz	a5, .LBB0_211
# %bb.210:                              #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s10, s10, a3
.LBB0_211:                              #   in Loop: Header=BB0_5 Depth=1
	li	a3, 15
	beq	a6, a3, .LBB0_4
# %bb.212:                              #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 15
	sub	a5, ra, a3
	bltz	a5, .LBB0_214
# %bb.213:                              #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s10, s10, a3
.LBB0_214:                              #   in Loop: Header=BB0_5 Depth=1
	li	a3, 16
	beq	a6, a3, .LBB0_4
# %bb.215:                              #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 16
	sub	a5, ra, a3
	bltz	a5, .LBB0_217
# %bb.216:                              #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s10, s10, a3
.LBB0_217:                              #   in Loop: Header=BB0_5 Depth=1
	li	a3, 17
	beq	a6, a3, .LBB0_4
# %bb.218:                              #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 17
	sub	a5, ra, a3
	bltz	a5, .LBB0_220
# %bb.219:                              #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s10, s10, a3
.LBB0_220:                              #   in Loop: Header=BB0_5 Depth=1
	li	a3, 18
	beq	a6, a3, .LBB0_4
# %bb.221:                              #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 18
	sub	a5, ra, a3
	bltz	a5, .LBB0_223
# %bb.222:                              #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s10, s10, a3
.LBB0_223:                              #   in Loop: Header=BB0_5 Depth=1
	li	a3, 19
	beq	a6, a3, .LBB0_4
# %bb.224:                              #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 19
	sub	a5, ra, a3
	bltz	a5, .LBB0_226
# %bb.225:                              #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s10, s10, a3
.LBB0_226:                              #   in Loop: Header=BB0_5 Depth=1
	li	a3, 20
	beq	a6, a3, .LBB0_4
# %bb.227:                              #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 20
	sub	a5, ra, a3
	bltz	a5, .LBB0_229
# %bb.228:                              #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s10, s10, a3
.LBB0_229:                              #   in Loop: Header=BB0_5 Depth=1
	li	a3, 21
	beq	a6, a3, .LBB0_4
# %bb.230:                              #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 21
	sub	a5, ra, a3
	bltz	a5, .LBB0_232
# %bb.231:                              #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s10, s10, a3
.LBB0_232:                              #   in Loop: Header=BB0_5 Depth=1
	li	a3, 22
	beq	a6, a3, .LBB0_4
# %bb.233:                              #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 22
	sub	a5, ra, a3
	bltz	a5, .LBB0_235
# %bb.234:                              #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s10, s10, a3
.LBB0_235:                              #   in Loop: Header=BB0_5 Depth=1
	li	a3, 23
	beq	a6, a3, .LBB0_4
# %bb.236:                              #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 23
	sub	a5, ra, a3
	bltz	a5, .LBB0_238
# %bb.237:                              #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s10, s10, a3
.LBB0_238:                              #   in Loop: Header=BB0_5 Depth=1
	li	a3, 24
	beq	a6, a3, .LBB0_4
# %bb.239:                              #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 24
	sub	a5, ra, a3
	bltz	a5, .LBB0_241
# %bb.240:                              #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s10, s10, a3
.LBB0_241:                              #   in Loop: Header=BB0_5 Depth=1
	li	a3, 25
	beq	a6, a3, .LBB0_4
# %bb.242:                              #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 25
	sub	a5, ra, a3
	bltz	a5, .LBB0_244
# %bb.243:                              #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s10, s10, a3
.LBB0_244:                              #   in Loop: Header=BB0_5 Depth=1
	li	a3, 26
	beq	a6, a3, .LBB0_4
# %bb.245:                              #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 26
	sub	a5, ra, a3
	bltz	a5, .LBB0_247
# %bb.246:                              #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s10, s10, a3
.LBB0_247:                              #   in Loop: Header=BB0_5 Depth=1
	li	a3, 27
	beq	a6, a3, .LBB0_4
# %bb.248:                              #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 27
	sub	a5, ra, a3
	bltz	a5, .LBB0_250
# %bb.249:                              #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s10, s10, a3
.LBB0_250:                              #   in Loop: Header=BB0_5 Depth=1
	li	a3, 28
	beq	a6, a3, .LBB0_4
# %bb.251:                              #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 28
	sub	a5, ra, a3
	bltz	a5, .LBB0_253
# %bb.252:                              #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s10, s10, a3
.LBB0_253:                              #   in Loop: Header=BB0_5 Depth=1
	li	a3, 29
	beq	a6, a3, .LBB0_4
# %bb.254:                              #   in Loop: Header=BB0_5 Depth=1
	addi	a3, s0, 29
	sub	a5, ra, a3
	bltz	a5, .LBB0_256
# %bb.255:                              #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a5, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a5
	add	s10, s10, a3
.LBB0_256:                              #   in Loop: Header=BB0_5 Depth=1
	li	a3, 30
	beq	a6, a3, .LBB0_4
# %bb.257:                              #   in Loop: Header=BB0_5 Depth=1
	addi	s0, s0, 30
	sub	a3, ra, s0
	bltz	a3, .LBB0_4
# %bb.258:                              #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 2
	slli	a3, a3, 2
	slli	s0, s0, 2
	c.li	zero, 2
	add	a3, a3, a0
	add	s0, s0, a1
	lw	a3, 0(a3)
	lw	a5, 0(s0)
	mul	a3, a5, a3
	add	s10, s10, a3
	j	.LBB0_4
.LBB0_259:                              #   in Loop: Header=BB0_5 Depth=1
	c.li	zero, 4
	li	s4, 0
	li	s10, 0
	addi	s5, a7, -120
	mv	a5, t2
	mv	s1, t3
	j	.LBB0_261
.LBB0_260:                              #   in Loop: Header=BB0_261 Depth=2
	c.li	zero, 3
	addi	s4, s4, -32
	addi	s1, s1, -128
	addi	a5, a5, 128
	beq	s11, s4, .LBB0_325
.LBB0_261:                              #   Parent Loop BB0_5 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	add	s0, a7, s4
	addi	a3, s0, 1
	bltz	a3, .LBB0_263
# %bb.262:                              #   in Loop: Header=BB0_261 Depth=2
	lw	a3, 60(s1)
	lw	s3, -64(a5)
	mul	a3, s3, a3
	add	s10, s10, a3
.LBB0_263:                              #   in Loop: Header=BB0_261 Depth=2
	bltz	s0, .LBB0_265
# %bb.264:                              #   in Loop: Header=BB0_261 Depth=2
	lw	a3, 56(s1)
	lw	s0, -60(a5)
	mul	a3, s0, a3
	add	s10, s10, a3
.LBB0_265:                              #   in Loop: Header=BB0_261 Depth=2
	add	a3, s5, s4
	addi	s0, a3, 119
	bltz	s0, .LBB0_267
# %bb.266:                              #   in Loop: Header=BB0_261 Depth=2
	lw	s3, 52(s1)
	lw	s0, -56(a5)
	mul	s0, s0, s3
	add	s10, s10, s0
.LBB0_267:                              #   in Loop: Header=BB0_261 Depth=2
	addi	s0, a3, 118
	bltz	s0, .LBB0_269
# %bb.268:                              #   in Loop: Header=BB0_261 Depth=2
	lw	s3, 48(s1)
	lw	s0, -52(a5)
	mul	s0, s0, s3
	add	s10, s10, s0
.LBB0_269:                              #   in Loop: Header=BB0_261 Depth=2
	addi	s0, a3, 117
	bltz	s0, .LBB0_271
# %bb.270:                              #   in Loop: Header=BB0_261 Depth=2
	lw	s3, 44(s1)
	lw	s0, -48(a5)
	mul	s0, s0, s3
	add	s10, s10, s0
.LBB0_271:                              #   in Loop: Header=BB0_261 Depth=2
	addi	s0, a3, 116
	bltz	s0, .LBB0_273
# %bb.272:                              #   in Loop: Header=BB0_261 Depth=2
	lw	s3, 40(s1)
	lw	s0, -44(a5)
	mul	s0, s0, s3
	add	s10, s10, s0
.LBB0_273:                              #   in Loop: Header=BB0_261 Depth=2
	addi	s0, a3, 115
	bltz	s0, .LBB0_275
# %bb.274:                              #   in Loop: Header=BB0_261 Depth=2
	lw	s3, 36(s1)
	lw	s0, -40(a5)
	mul	s0, s0, s3
	add	s10, s10, s0
.LBB0_275:                              #   in Loop: Header=BB0_261 Depth=2
	addi	s0, a3, 114
	bltz	s0, .LBB0_277
# %bb.276:                              #   in Loop: Header=BB0_261 Depth=2
	lw	s3, 32(s1)
	lw	s0, -36(a5)
	mul	s0, s0, s3
	add	s10, s10, s0
.LBB0_277:                              #   in Loop: Header=BB0_261 Depth=2
	addi	s0, a3, 113
	bltz	s0, .LBB0_279
# %bb.278:                              #   in Loop: Header=BB0_261 Depth=2
	lw	s3, 28(s1)
	lw	s0, -32(a5)
	mul	s0, s0, s3
	add	s10, s10, s0
.LBB0_279:                              #   in Loop: Header=BB0_261 Depth=2
	addi	s0, a3, 112
	bltz	s0, .LBB0_281
# %bb.280:                              #   in Loop: Header=BB0_261 Depth=2
	lw	s3, 24(s1)
	lw	s0, -28(a5)
	mul	s0, s0, s3
	add	s10, s10, s0
.LBB0_281:                              #   in Loop: Header=BB0_261 Depth=2
	addi	s0, a3, 111
	bltz	s0, .LBB0_283
# %bb.282:                              #   in Loop: Header=BB0_261 Depth=2
	lw	s3, 20(s1)
	lw	s0, -24(a5)
	mul	s0, s0, s3
	add	s10, s10, s0
.LBB0_283:                              #   in Loop: Header=BB0_261 Depth=2
	addi	s0, a3, 110
	bltz	s0, .LBB0_285
# %bb.284:                              #   in Loop: Header=BB0_261 Depth=2
	lw	s3, 16(s1)
	lw	s0, -20(a5)
	mul	s0, s0, s3
	add	s10, s10, s0
.LBB0_285:                              #   in Loop: Header=BB0_261 Depth=2
	addi	s0, a3, 109
	bltz	s0, .LBB0_287
# %bb.286:                              #   in Loop: Header=BB0_261 Depth=2
	lw	s3, 12(s1)
	lw	s0, -16(a5)
	mul	s0, s0, s3
	add	s10, s10, s0
.LBB0_287:                              #   in Loop: Header=BB0_261 Depth=2
	addi	s0, a3, 108
	bltz	s0, .LBB0_289
# %bb.288:                              #   in Loop: Header=BB0_261 Depth=2
	lw	s3, 8(s1)
	lw	s0, -12(a5)
	mul	s0, s0, s3
	add	s10, s10, s0
.LBB0_289:                              #   in Loop: Header=BB0_261 Depth=2
	addi	s0, a3, 107
	bltz	s0, .LBB0_291
# %bb.290:                              #   in Loop: Header=BB0_261 Depth=2
	lw	s3, 4(s1)
	lw	s0, -8(a5)
	mul	s0, s0, s3
	add	s10, s10, s0
.LBB0_291:                              #   in Loop: Header=BB0_261 Depth=2
	addi	s0, a3, 106
	bltz	s0, .LBB0_293
# %bb.292:                              #   in Loop: Header=BB0_261 Depth=2
	lw	s3, 0(s1)
	lw	s0, -4(a5)
	mul	s0, s0, s3
	add	s10, s10, s0
.LBB0_293:                              #   in Loop: Header=BB0_261 Depth=2
	addi	s0, a3, 105
	bltz	s0, .LBB0_295
# %bb.294:                              #   in Loop: Header=BB0_261 Depth=2
	lw	s3, -4(s1)
	lw	s0, 0(a5)
	mul	s0, s0, s3
	add	s10, s10, s0
.LBB0_295:                              #   in Loop: Header=BB0_261 Depth=2
	addi	s0, a3, 104
	bltz	s0, .LBB0_297
# %bb.296:                              #   in Loop: Header=BB0_261 Depth=2
	lw	s3, -8(s1)
	lw	s0, 4(a5)
	mul	s0, s0, s3
	add	s10, s10, s0
.LBB0_297:                              #   in Loop: Header=BB0_261 Depth=2
	addi	s0, a3, 103
	bltz	s0, .LBB0_299
# %bb.298:                              #   in Loop: Header=BB0_261 Depth=2
	lw	s3, -12(s1)
	lw	s0, 8(a5)
	mul	s0, s0, s3
	add	s10, s10, s0
.LBB0_299:                              #   in Loop: Header=BB0_261 Depth=2
	addi	s0, a3, 102
	bltz	s0, .LBB0_301
# %bb.300:                              #   in Loop: Header=BB0_261 Depth=2
	lw	s3, -16(s1)
	lw	s0, 12(a5)
	mul	s0, s0, s3
	add	s10, s10, s0
.LBB0_301:                              #   in Loop: Header=BB0_261 Depth=2
	addi	s0, a3, 101
	bltz	s0, .LBB0_303
# %bb.302:                              #   in Loop: Header=BB0_261 Depth=2
	lw	s3, -20(s1)
	lw	s0, 16(a5)
	mul	s0, s0, s3
	add	s10, s10, s0
.LBB0_303:                              #   in Loop: Header=BB0_261 Depth=2
	addi	s0, a3, 100
	bltz	s0, .LBB0_305
# %bb.304:                              #   in Loop: Header=BB0_261 Depth=2
	lw	s3, -24(s1)
	lw	s0, 20(a5)
	mul	s0, s0, s3
	add	s10, s10, s0
.LBB0_305:                              #   in Loop: Header=BB0_261 Depth=2
	addi	s0, a3, 99
	bltz	s0, .LBB0_307
# %bb.306:                              #   in Loop: Header=BB0_261 Depth=2
	lw	s3, -28(s1)
	lw	s0, 24(a5)
	mul	s0, s0, s3
	add	s10, s10, s0
.LBB0_307:                              #   in Loop: Header=BB0_261 Depth=2
	addi	s0, a3, 98
	bltz	s0, .LBB0_309
# %bb.308:                              #   in Loop: Header=BB0_261 Depth=2
	lw	s3, -32(s1)
	lw	s0, 28(a5)
	mul	s0, s0, s3
	add	s10, s10, s0
.LBB0_309:                              #   in Loop: Header=BB0_261 Depth=2
	addi	s0, a3, 97
	bltz	s0, .LBB0_311
# %bb.310:                              #   in Loop: Header=BB0_261 Depth=2
	lw	s3, -36(s1)
	lw	s0, 32(a5)
	mul	s0, s0, s3
	add	s10, s10, s0
.LBB0_311:                              #   in Loop: Header=BB0_261 Depth=2
	addi	s0, a3, 96
	bltz	s0, .LBB0_313
# %bb.312:                              #   in Loop: Header=BB0_261 Depth=2
	lw	s3, -40(s1)
	lw	s0, 36(a5)
	mul	s0, s0, s3
	add	s10, s10, s0
.LBB0_313:                              #   in Loop: Header=BB0_261 Depth=2
	addi	s0, a3, 95
	bltz	s0, .LBB0_315
# %bb.314:                              #   in Loop: Header=BB0_261 Depth=2
	lw	s3, -44(s1)
	lw	s0, 40(a5)
	mul	s0, s0, s3
	add	s10, s10, s0
.LBB0_315:                              #   in Loop: Header=BB0_261 Depth=2
	addi	s0, a3, 94
	bltz	s0, .LBB0_317
# %bb.316:                              #   in Loop: Header=BB0_261 Depth=2
	lw	s3, -48(s1)
	lw	s0, 44(a5)
	mul	s0, s0, s3
	add	s10, s10, s0
.LBB0_317:                              #   in Loop: Header=BB0_261 Depth=2
	addi	s0, a3, 93
	bltz	s0, .LBB0_319
# %bb.318:                              #   in Loop: Header=BB0_261 Depth=2
	lw	s3, -52(s1)
	lw	s0, 48(a5)
	mul	s0, s0, s3
	add	s10, s10, s0
.LBB0_319:                              #   in Loop: Header=BB0_261 Depth=2
	addi	s0, a3, 92
	bltz	s0, .LBB0_321
# %bb.320:                              #   in Loop: Header=BB0_261 Depth=2
	lw	s3, -56(s1)
	lw	s0, 52(a5)
	mul	s0, s0, s3
	add	s10, s10, s0
.LBB0_321:                              #   in Loop: Header=BB0_261 Depth=2
	addi	s0, a3, 91
	bltz	s0, .LBB0_323
# %bb.322:                              #   in Loop: Header=BB0_261 Depth=2
	lw	s3, -60(s1)
	lw	s0, 56(a5)
	mul	s0, s0, s3
	add	s10, s10, s0
.LBB0_323:                              #   in Loop: Header=BB0_261 Depth=2
	addi	a3, a3, 90
	bltz	a3, .LBB0_260
# %bb.324:                              #   in Loop: Header=BB0_261 Depth=2
	lw	a3, -64(s1)
	lw	s0, 60(a5)
	mul	a3, s0, a3
	add	s10, s10, a3
	j	.LBB0_260
.LBB0_325:                              #   in Loop: Header=BB0_5 Depth=1
	bnez	a6, .LBB0_326
	j	.LBB0_4
.LBB0_326:                              #   in Loop: Header=BB0_5 Depth=1
	neg	s0, s4
	sub	a3, ra, s0
	bgez	a3, .LBB0_168
	j	.LBB0_169
.LBB0_327:
	srli	a1, a3, 5
	c.li	zero, 2
	andi	a3, a3, 31
	li	a0, 0
	beqz	a1, .LBB0_332
# %bb.328:
	slli	a1, a1, 6
	srli	a1, a1, 1
	c.li	zero, 2
	neg	a1, a1
	addi	a4, a2, 64
.LBB0_329:                              # =>This Inner Loop Header: Depth=1
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
	addi	a0, a0, -32
	addi	a4, a4, 128
	bne	a1, a0, .LBB0_329
# %bb.330:
	beqz	a3, .LBB0_525
# %bb.331:
	neg	a0, a0
.LBB0_332:
	slli	a0, a0, 2
	add	a2, a2, a0
	li	a0, 1
	sw	zero, 0(a2)
	beq	a3, a0, .LBB0_525
# %bb.333:
	li	a0, 2
	sw	zero, 4(a2)
	beq	a3, a0, .LBB0_525
# %bb.334:
	li	a0, 3
	sw	zero, 8(a2)
	beq	a3, a0, .LBB0_525
# %bb.335:
	li	a0, 4
	sw	zero, 12(a2)
	beq	a3, a0, .LBB0_525
# %bb.336:
	li	a0, 5
	sw	zero, 16(a2)
	beq	a3, a0, .LBB0_525
# %bb.337:
	li	a0, 6
	sw	zero, 20(a2)
	beq	a3, a0, .LBB0_525
# %bb.338:
	li	a0, 7
	sw	zero, 24(a2)
	beq	a3, a0, .LBB0_525
# %bb.339:
	li	a0, 8
	sw	zero, 28(a2)
	beq	a3, a0, .LBB0_525
# %bb.340:
	li	a0, 9
	sw	zero, 32(a2)
	beq	a3, a0, .LBB0_525
# %bb.341:
	li	a0, 10
	sw	zero, 36(a2)
	beq	a3, a0, .LBB0_525
# %bb.342:
	li	a0, 11
	sw	zero, 40(a2)
	beq	a3, a0, .LBB0_525
# %bb.343:
	li	a0, 12
	sw	zero, 44(a2)
	beq	a3, a0, .LBB0_525
# %bb.344:
	li	a0, 13
	sw	zero, 48(a2)
	beq	a3, a0, .LBB0_525
# %bb.345:
	li	a0, 14
	sw	zero, 52(a2)
	beq	a3, a0, .LBB0_525
# %bb.346:
	li	a0, 15
	sw	zero, 56(a2)
	beq	a3, a0, .LBB0_525
# %bb.347:
	li	a0, 16
	sw	zero, 60(a2)
	beq	a3, a0, .LBB0_525
# %bb.348:
	li	a0, 17
	sw	zero, 64(a2)
	beq	a3, a0, .LBB0_525
# %bb.349:
	li	a0, 18
	sw	zero, 68(a2)
	beq	a3, a0, .LBB0_525
# %bb.350:
	li	a0, 19
	sw	zero, 72(a2)
	beq	a3, a0, .LBB0_525
# %bb.351:
	li	a0, 20
	sw	zero, 76(a2)
	beq	a3, a0, .LBB0_525
# %bb.352:
	li	a0, 21
	sw	zero, 80(a2)
	beq	a3, a0, .LBB0_525
# %bb.353:
	li	a0, 22
	sw	zero, 84(a2)
	beq	a3, a0, .LBB0_525
# %bb.354:
	li	a0, 23
	sw	zero, 88(a2)
	beq	a3, a0, .LBB0_525
# %bb.355:
	li	a0, 24
	sw	zero, 92(a2)
	beq	a3, a0, .LBB0_525
# %bb.356:
	li	a0, 25
	sw	zero, 96(a2)
	beq	a3, a0, .LBB0_525
# %bb.357:
	li	a0, 26
	sw	zero, 100(a2)
	beq	a3, a0, .LBB0_525
# %bb.358:
	li	a0, 27
	sw	zero, 104(a2)
	beq	a3, a0, .LBB0_525
# %bb.359:
	li	a0, 28
	sw	zero, 108(a2)
	beq	a3, a0, .LBB0_525
# %bb.360:
	li	a0, 29
	sw	zero, 112(a2)
	beq	a3, a0, .LBB0_525
# %bb.361:
	li	a0, 30
	sw	zero, 116(a2)
	beq	a3, a0, .LBB0_525
# %bb.362:
	sw	zero, 120(a2)
	j	.LBB0_525
.LBB0_363:
	beqz	t0, .LBB0_525
.LBB0_364:
	c.li	zero, 2
	srli	a3, a4, 5
	slli	t2, a7, 2
	beqz	a3, .LBB0_527
# %bb.365:
	c.li	zero, 4
	li	t3, 0
	li	t4, 0
	slli	a3, a3, 6
	addi	t0, a7, -124
	c.li	zero, 2
	add	s1, t2, a0
	srli	s0, a3, 1
	c.li	zero, 2
	addi	a3, s1, -60
	neg	t1, s0
	addi	s0, a1, 64
	j	.LBB0_367
.LBB0_366:                              #   in Loop: Header=BB0_367 Depth=1
	c.li	zero, 3
	addi	t3, t3, -32
	addi	a3, a3, -128
	addi	s0, s0, 128
	beq	t1, t3, .LBB0_431
.LBB0_367:                              # =>This Inner Loop Header: Depth=1
	add	a5, a7, t3
	bltz	a5, .LBB0_369
# %bb.368:                              #   in Loop: Header=BB0_367 Depth=1
	lw	a5, 60(a3)
	lw	s1, -64(s0)
	mul	a5, s1, a5
	add	t4, t4, a5
.LBB0_369:                              #   in Loop: Header=BB0_367 Depth=1
	add	s1, t0, t3
	addi	a5, s1, 123
	bltz	a5, .LBB0_371
# %bb.370:                              #   in Loop: Header=BB0_367 Depth=1
	lw	a5, 56(a3)
	lw	a4, -60(s0)
	mul	a4, a4, a5
	add	t4, t4, a4
.LBB0_371:                              #   in Loop: Header=BB0_367 Depth=1
	addi	a4, s1, 122
	bltz	a4, .LBB0_373
# %bb.372:                              #   in Loop: Header=BB0_367 Depth=1
	lw	a4, 52(a3)
	lw	a5, -56(s0)
	mul	a4, a5, a4
	add	t4, t4, a4
.LBB0_373:                              #   in Loop: Header=BB0_367 Depth=1
	addi	a4, s1, 121
	bltz	a4, .LBB0_375
# %bb.374:                              #   in Loop: Header=BB0_367 Depth=1
	lw	a4, 48(a3)
	lw	a5, -52(s0)
	mul	a4, a5, a4
	add	t4, t4, a4
.LBB0_375:                              #   in Loop: Header=BB0_367 Depth=1
	addi	a4, s1, 120
	bltz	a4, .LBB0_377
# %bb.376:                              #   in Loop: Header=BB0_367 Depth=1
	lw	a4, 44(a3)
	lw	a5, -48(s0)
	mul	a4, a5, a4
	add	t4, t4, a4
.LBB0_377:                              #   in Loop: Header=BB0_367 Depth=1
	addi	a4, s1, 119
	bltz	a4, .LBB0_379
# %bb.378:                              #   in Loop: Header=BB0_367 Depth=1
	lw	a4, 40(a3)
	lw	a5, -44(s0)
	mul	a4, a5, a4
	add	t4, t4, a4
.LBB0_379:                              #   in Loop: Header=BB0_367 Depth=1
	addi	a4, s1, 118
	bltz	a4, .LBB0_381
# %bb.380:                              #   in Loop: Header=BB0_367 Depth=1
	lw	a4, 36(a3)
	lw	a5, -40(s0)
	mul	a4, a5, a4
	add	t4, t4, a4
.LBB0_381:                              #   in Loop: Header=BB0_367 Depth=1
	addi	a4, s1, 117
	bltz	a4, .LBB0_383
# %bb.382:                              #   in Loop: Header=BB0_367 Depth=1
	lw	a4, 32(a3)
	lw	a5, -36(s0)
	mul	a4, a5, a4
	add	t4, t4, a4
.LBB0_383:                              #   in Loop: Header=BB0_367 Depth=1
	addi	a4, s1, 116
	bltz	a4, .LBB0_385
# %bb.384:                              #   in Loop: Header=BB0_367 Depth=1
	lw	a4, 28(a3)
	lw	a5, -32(s0)
	mul	a4, a5, a4
	add	t4, t4, a4
.LBB0_385:                              #   in Loop: Header=BB0_367 Depth=1
	addi	a4, s1, 115
	bltz	a4, .LBB0_387
# %bb.386:                              #   in Loop: Header=BB0_367 Depth=1
	lw	a4, 24(a3)
	lw	a5, -28(s0)
	mul	a4, a5, a4
	add	t4, t4, a4
.LBB0_387:                              #   in Loop: Header=BB0_367 Depth=1
	addi	a4, s1, 114
	bltz	a4, .LBB0_389
# %bb.388:                              #   in Loop: Header=BB0_367 Depth=1
	lw	a4, 20(a3)
	lw	a5, -24(s0)
	mul	a4, a5, a4
	add	t4, t4, a4
.LBB0_389:                              #   in Loop: Header=BB0_367 Depth=1
	addi	a4, s1, 113
	bltz	a4, .LBB0_391
# %bb.390:                              #   in Loop: Header=BB0_367 Depth=1
	lw	a4, 16(a3)
	lw	a5, -20(s0)
	mul	a4, a5, a4
	add	t4, t4, a4
.LBB0_391:                              #   in Loop: Header=BB0_367 Depth=1
	addi	a4, s1, 112
	bltz	a4, .LBB0_393
# %bb.392:                              #   in Loop: Header=BB0_367 Depth=1
	lw	a4, 12(a3)
	lw	a5, -16(s0)
	mul	a4, a5, a4
	add	t4, t4, a4
.LBB0_393:                              #   in Loop: Header=BB0_367 Depth=1
	addi	a4, s1, 111
	bltz	a4, .LBB0_395
# %bb.394:                              #   in Loop: Header=BB0_367 Depth=1
	lw	a4, 8(a3)
	lw	a5, -12(s0)
	mul	a4, a5, a4
	add	t4, t4, a4
.LBB0_395:                              #   in Loop: Header=BB0_367 Depth=1
	addi	a4, s1, 110
	bltz	a4, .LBB0_397
# %bb.396:                              #   in Loop: Header=BB0_367 Depth=1
	lw	a4, 4(a3)
	lw	a5, -8(s0)
	mul	a4, a5, a4
	add	t4, t4, a4
.LBB0_397:                              #   in Loop: Header=BB0_367 Depth=1
	addi	a4, s1, 109
	bltz	a4, .LBB0_399
# %bb.398:                              #   in Loop: Header=BB0_367 Depth=1
	lw	a4, 0(a3)
	lw	a5, -4(s0)
	mul	a4, a5, a4
	add	t4, t4, a4
.LBB0_399:                              #   in Loop: Header=BB0_367 Depth=1
	addi	a4, s1, 108
	bltz	a4, .LBB0_401
# %bb.400:                              #   in Loop: Header=BB0_367 Depth=1
	lw	a4, -4(a3)
	lw	a5, 0(s0)
	mul	a4, a5, a4
	add	t4, t4, a4
.LBB0_401:                              #   in Loop: Header=BB0_367 Depth=1
	addi	a4, s1, 107
	bltz	a4, .LBB0_403
# %bb.402:                              #   in Loop: Header=BB0_367 Depth=1
	lw	a4, -8(a3)
	lw	a5, 4(s0)
	mul	a4, a5, a4
	add	t4, t4, a4
.LBB0_403:                              #   in Loop: Header=BB0_367 Depth=1
	addi	a4, s1, 106
	bltz	a4, .LBB0_405
# %bb.404:                              #   in Loop: Header=BB0_367 Depth=1
	lw	a4, -12(a3)
	lw	a5, 8(s0)
	mul	a4, a5, a4
	add	t4, t4, a4
.LBB0_405:                              #   in Loop: Header=BB0_367 Depth=1
	addi	a4, s1, 105
	bltz	a4, .LBB0_407
# %bb.406:                              #   in Loop: Header=BB0_367 Depth=1
	lw	a4, -16(a3)
	lw	a5, 12(s0)
	mul	a4, a5, a4
	add	t4, t4, a4
.LBB0_407:                              #   in Loop: Header=BB0_367 Depth=1
	addi	a4, s1, 104
	bltz	a4, .LBB0_409
# %bb.408:                              #   in Loop: Header=BB0_367 Depth=1
	lw	a4, -20(a3)
	lw	a5, 16(s0)
	mul	a4, a5, a4
	add	t4, t4, a4
.LBB0_409:                              #   in Loop: Header=BB0_367 Depth=1
	addi	a4, s1, 103
	bltz	a4, .LBB0_411
# %bb.410:                              #   in Loop: Header=BB0_367 Depth=1
	lw	a4, -24(a3)
	lw	a5, 20(s0)
	mul	a4, a5, a4
	add	t4, t4, a4
.LBB0_411:                              #   in Loop: Header=BB0_367 Depth=1
	addi	a4, s1, 102
	bltz	a4, .LBB0_413
# %bb.412:                              #   in Loop: Header=BB0_367 Depth=1
	lw	a4, -28(a3)
	lw	a5, 24(s0)
	mul	a4, a5, a4
	add	t4, t4, a4
.LBB0_413:                              #   in Loop: Header=BB0_367 Depth=1
	addi	a4, s1, 101
	bltz	a4, .LBB0_415
# %bb.414:                              #   in Loop: Header=BB0_367 Depth=1
	lw	a4, -32(a3)
	lw	a5, 28(s0)
	mul	a4, a5, a4
	add	t4, t4, a4
.LBB0_415:                              #   in Loop: Header=BB0_367 Depth=1
	addi	a4, s1, 100
	bltz	a4, .LBB0_417
# %bb.416:                              #   in Loop: Header=BB0_367 Depth=1
	lw	a4, -36(a3)
	lw	a5, 32(s0)
	mul	a4, a5, a4
	add	t4, t4, a4
.LBB0_417:                              #   in Loop: Header=BB0_367 Depth=1
	addi	a4, s1, 99
	bltz	a4, .LBB0_419
# %bb.418:                              #   in Loop: Header=BB0_367 Depth=1
	lw	a4, -40(a3)
	lw	a5, 36(s0)
	mul	a4, a5, a4
	add	t4, t4, a4
.LBB0_419:                              #   in Loop: Header=BB0_367 Depth=1
	addi	a4, s1, 98
	bltz	a4, .LBB0_421
# %bb.420:                              #   in Loop: Header=BB0_367 Depth=1
	lw	a4, -44(a3)
	lw	a5, 40(s0)
	mul	a4, a5, a4
	add	t4, t4, a4
.LBB0_421:                              #   in Loop: Header=BB0_367 Depth=1
	addi	a4, s1, 97
	bltz	a4, .LBB0_423
# %bb.422:                              #   in Loop: Header=BB0_367 Depth=1
	lw	a4, -48(a3)
	lw	a5, 44(s0)
	mul	a4, a5, a4
	add	t4, t4, a4
.LBB0_423:                              #   in Loop: Header=BB0_367 Depth=1
	addi	a4, s1, 96
	bltz	a4, .LBB0_425
# %bb.424:                              #   in Loop: Header=BB0_367 Depth=1
	lw	a4, -52(a3)
	lw	a5, 48(s0)
	mul	a4, a5, a4
	add	t4, t4, a4
.LBB0_425:                              #   in Loop: Header=BB0_367 Depth=1
	addi	a4, s1, 95
	bltz	a4, .LBB0_427
# %bb.426:                              #   in Loop: Header=BB0_367 Depth=1
	lw	a4, -56(a3)
	lw	a5, 52(s0)
	mul	a4, a5, a4
	add	t4, t4, a4
.LBB0_427:                              #   in Loop: Header=BB0_367 Depth=1
	addi	a4, s1, 94
	bltz	a4, .LBB0_429
# %bb.428:                              #   in Loop: Header=BB0_367 Depth=1
	lw	a4, -60(a3)
	lw	a5, 56(s0)
	mul	a4, a5, a4
	add	t4, t4, a4
.LBB0_429:                              #   in Loop: Header=BB0_367 Depth=1
	addi	a4, s1, 93
	bltz	a4, .LBB0_366
# %bb.430:                              #   in Loop: Header=BB0_367 Depth=1
	lw	a4, -64(a3)
	lw	a5, 60(s0)
	mul	a4, a5, a4
	add	t4, t4, a4
	j	.LBB0_366
.LBB0_431:
	beqz	a6, .LBB0_524
# %bb.432:
	neg	s1, t3
	sub	a3, a7, s1
	bltz	a3, .LBB0_434
.LBB0_433:
	c.li	zero, 2
	slli	a3, a3, 2
	slli	a4, s1, 2
	c.li	zero, 2
	add	a3, a3, a0
	add	a4, a4, a1
	lw	a3, 0(a3)
	lw	a4, 0(a4)
	mul	a3, a4, a3
	add	t4, t4, a3
.LBB0_434:
	li	a3, 1
	beq	a6, a3, .LBB0_524
# %bb.435:
	addi	a3, s1, 1
	sub	a5, a7, a3
	bltz	a5, .LBB0_437
# %bb.436:
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a4, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a4
	add	t4, t4, a3
.LBB0_437:
	li	a3, 2
	beq	a6, a3, .LBB0_524
# %bb.438:
	addi	a3, s1, 2
	sub	a5, a7, a3
	bltz	a5, .LBB0_440
# %bb.439:
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a4, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a4
	add	t4, t4, a3
.LBB0_440:
	li	a3, 3
	beq	a6, a3, .LBB0_524
# %bb.441:
	addi	a3, s1, 3
	sub	a5, a7, a3
	bltz	a5, .LBB0_443
# %bb.442:
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a4, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a4
	add	t4, t4, a3
.LBB0_443:
	li	a3, 4
	beq	a6, a3, .LBB0_524
# %bb.444:
	addi	a3, s1, 4
	sub	a5, a7, a3
	bltz	a5, .LBB0_446
# %bb.445:
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a4, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a4
	add	t4, t4, a3
.LBB0_446:
	li	a3, 5
	beq	a6, a3, .LBB0_524
# %bb.447:
	addi	a3, s1, 5
	sub	a5, a7, a3
	bltz	a5, .LBB0_449
# %bb.448:
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a4, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a4
	add	t4, t4, a3
.LBB0_449:
	li	a3, 6
	beq	a6, a3, .LBB0_524
# %bb.450:
	addi	a3, s1, 6
	sub	a5, a7, a3
	bltz	a5, .LBB0_452
# %bb.451:
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a4, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a4
	add	t4, t4, a3
.LBB0_452:
	li	a3, 7
	beq	a6, a3, .LBB0_524
# %bb.453:
	addi	a3, s1, 7
	sub	a5, a7, a3
	bltz	a5, .LBB0_455
# %bb.454:
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a4, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a4
	add	t4, t4, a3
.LBB0_455:
	li	a3, 8
	beq	a6, a3, .LBB0_524
# %bb.456:
	addi	a3, s1, 8
	sub	a5, a7, a3
	bltz	a5, .LBB0_458
# %bb.457:
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a4, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a4
	add	t4, t4, a3
.LBB0_458:
	li	a3, 9
	beq	a6, a3, .LBB0_524
# %bb.459:
	addi	a3, s1, 9
	sub	a5, a7, a3
	bltz	a5, .LBB0_461
# %bb.460:
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a4, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a4
	add	t4, t4, a3
.LBB0_461:
	li	a3, 10
	beq	a6, a3, .LBB0_524
# %bb.462:
	addi	a3, s1, 10
	sub	a5, a7, a3
	bltz	a5, .LBB0_464
# %bb.463:
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a4, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a4
	add	t4, t4, a3
.LBB0_464:
	li	a3, 11
	beq	a6, a3, .LBB0_524
# %bb.465:
	addi	a3, s1, 11
	sub	a5, a7, a3
	bltz	a5, .LBB0_467
# %bb.466:
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a4, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a4
	add	t4, t4, a3
.LBB0_467:
	li	a3, 12
	beq	a6, a3, .LBB0_524
# %bb.468:
	addi	a3, s1, 12
	sub	a5, a7, a3
	bltz	a5, .LBB0_470
# %bb.469:
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a4, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a4
	add	t4, t4, a3
.LBB0_470:
	li	a3, 13
	beq	a6, a3, .LBB0_524
# %bb.471:
	addi	a3, s1, 13
	sub	a5, a7, a3
	bltz	a5, .LBB0_473
# %bb.472:
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a4, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a4
	add	t4, t4, a3
.LBB0_473:
	li	a3, 14
	beq	a6, a3, .LBB0_524
# %bb.474:
	addi	a3, s1, 14
	sub	a5, a7, a3
	bltz	a5, .LBB0_476
# %bb.475:
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a4, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a4
	add	t4, t4, a3
.LBB0_476:
	li	a3, 15
	beq	a6, a3, .LBB0_524
# %bb.477:
	addi	a3, s1, 15
	sub	a5, a7, a3
	bltz	a5, .LBB0_479
# %bb.478:
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a4, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a4
	add	t4, t4, a3
.LBB0_479:
	li	a3, 16
	beq	a6, a3, .LBB0_524
# %bb.480:
	addi	a3, s1, 16
	sub	a5, a7, a3
	bltz	a5, .LBB0_482
# %bb.481:
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a4, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a4
	add	t4, t4, a3
.LBB0_482:
	li	a3, 17
	beq	a6, a3, .LBB0_524
# %bb.483:
	addi	a3, s1, 17
	sub	a5, a7, a3
	bltz	a5, .LBB0_485
# %bb.484:
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a4, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a4
	add	t4, t4, a3
.LBB0_485:
	li	a3, 18
	beq	a6, a3, .LBB0_524
# %bb.486:
	addi	a3, s1, 18
	sub	a5, a7, a3
	bltz	a5, .LBB0_488
# %bb.487:
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a4, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a4
	add	t4, t4, a3
.LBB0_488:
	li	a3, 19
	beq	a6, a3, .LBB0_524
# %bb.489:
	addi	a3, s1, 19
	sub	a5, a7, a3
	bltz	a5, .LBB0_491
# %bb.490:
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a4, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a4
	add	t4, t4, a3
.LBB0_491:
	li	a3, 20
	beq	a6, a3, .LBB0_524
# %bb.492:
	addi	a3, s1, 20
	sub	a5, a7, a3
	bltz	a5, .LBB0_494
# %bb.493:
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a4, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a4
	add	t4, t4, a3
.LBB0_494:
	li	a3, 21
	beq	a6, a3, .LBB0_524
# %bb.495:
	addi	a3, s1, 21
	sub	a5, a7, a3
	bltz	a5, .LBB0_497
# %bb.496:
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a4, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a4
	add	t4, t4, a3
.LBB0_497:
	li	a3, 22
	beq	a6, a3, .LBB0_524
# %bb.498:
	addi	a3, s1, 22
	sub	a5, a7, a3
	bltz	a5, .LBB0_500
# %bb.499:
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a4, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a4
	add	t4, t4, a3
.LBB0_500:
	li	a3, 23
	beq	a6, a3, .LBB0_524
# %bb.501:
	addi	a3, s1, 23
	sub	a5, a7, a3
	bltz	a5, .LBB0_503
# %bb.502:
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a4, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a4
	add	t4, t4, a3
.LBB0_503:
	li	a3, 24
	beq	a6, a3, .LBB0_524
# %bb.504:
	addi	a3, s1, 24
	sub	a5, a7, a3
	bltz	a5, .LBB0_506
# %bb.505:
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a4, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a4
	add	t4, t4, a3
.LBB0_506:
	li	a3, 25
	beq	a6, a3, .LBB0_524
# %bb.507:
	addi	a3, s1, 25
	sub	a5, a7, a3
	bltz	a5, .LBB0_509
# %bb.508:
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a4, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a4
	add	t4, t4, a3
.LBB0_509:
	li	a3, 26
	beq	a6, a3, .LBB0_524
# %bb.510:
	addi	a3, s1, 26
	sub	a5, a7, a3
	bltz	a5, .LBB0_512
# %bb.511:
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a4, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a4
	add	t4, t4, a3
.LBB0_512:
	li	a3, 27
	beq	a6, a3, .LBB0_524
# %bb.513:
	addi	a3, s1, 27
	sub	a5, a7, a3
	bltz	a5, .LBB0_515
# %bb.514:
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a4, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a4
	add	t4, t4, a3
.LBB0_515:
	li	a3, 28
	beq	a6, a3, .LBB0_524
# %bb.516:
	addi	a3, s1, 28
	sub	a5, a7, a3
	bltz	a5, .LBB0_518
# %bb.517:
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a4, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a4
	add	t4, t4, a3
.LBB0_518:
	li	a3, 29
	beq	a6, a3, .LBB0_524
# %bb.519:
	addi	a3, s1, 29
	sub	a5, a7, a3
	bltz	a5, .LBB0_521
# %bb.520:
	c.li	zero, 2
	slli	a5, a5, 2
	slli	a3, a3, 2
	c.li	zero, 2
	add	a5, a5, a0
	add	a3, a3, a1
	lw	a4, 0(a5)
	lw	a3, 0(a3)
	mul	a3, a3, a4
	add	t4, t4, a3
.LBB0_521:
	li	a3, 30
	beq	a6, a3, .LBB0_524
# %bb.522:
	addi	s1, s1, 30
	sub	a3, a7, s1
	bltz	a3, .LBB0_524
# %bb.523:
	c.li	zero, 2
	slli	a3, a3, 2
	slli	s1, s1, 2
	c.li	zero, 2
	add	a0, a0, a3
	add	a1, a1, s1
	lw	a0, 0(a0)
	lw	a1, 0(a1)
	mul	a0, a1, a0
	add	t4, t4, a0
.LBB0_524:
	add	a2, a2, t2
	sw	t4, 0(a2)
.LBB0_525:
	lw	ra, 60(sp)                      # 4-byte Folded Reload
	lw	s0, 56(sp)                      # 4-byte Folded Reload
	lw	s1, 52(sp)                      # 4-byte Folded Reload
	lw	s2, 48(sp)                      # 4-byte Folded Reload
	lw	s3, 44(sp)                      # 4-byte Folded Reload
	lw	s4, 40(sp)                      # 4-byte Folded Reload
	lw	s5, 36(sp)                      # 4-byte Folded Reload
	lw	s6, 32(sp)                      # 4-byte Folded Reload
	lw	s7, 28(sp)                      # 4-byte Folded Reload
	lw	s8, 24(sp)                      # 4-byte Folded Reload
	lw	s9, 20(sp)                      # 4-byte Folded Reload
	lw	s10, 16(sp)                     # 4-byte Folded Reload
	lw	s11, 12(sp)                     # 4-byte Folded Reload
	addi	sp, sp, 64
.LBB0_526:
	ret
.LBB0_527:
	c.li	zero, 3
	li	s1, 0
	li	t4, 0
	mv	a3, a7
	bgez	a7, .LBB0_433
	j	.LBB0_434
.Lfunc_end0:
	.size	fir_filter_i32, .Lfunc_end0-fir_filter_i32
                                        # -- End function
	.ident	"clang version 23.0.0git (ssh://git@github.com/llvm/llvm-project.git d3081aafc47eccba242ffc3cc43ecfcb545a51bb)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
