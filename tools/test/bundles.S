	.text
	.globl _start
_start:
# --- CASE 1: safe 4-wide ALU bundle (expect: clean) ---
	c.li	zero, 4
	add	a0, a1, a2
	add	a3, a4, a5
	add	a6, a7, t0
	add	t1, t2, t3

# --- CASE 2: RAW hazard, lane0 writes a0, lane1 reads a0 (expect: ERROR) ---
	c.li	zero, 2
	add	a0, a1, a2
	add	s0, a0, a5

# --- CASE 3: WAW hazard, both write a0 (expect: ERROR) ---
	c.li	zero, 2
	add	a0, a1, a2
	add	a0, a4, a5

# --- CASE 4: load in worker lane (expect: ERROR) ---
	c.li	zero, 2
	add	a0, a1, a2
	lw	s1, 0(s2)

# --- CASE 5: two memory ops in one bundle (expect: ERROR) ---
	c.li	zero, 2
	lw	s3, 0(s4)
	lw	s5, 4(s6)

# --- CASE 6: branch in worker lane (expect: ERROR) ---
	c.li	zero, 2
	add	a0, a1, a2
	beq	s7, s8, _start

# --- CASE 7: load in lane 0 plus ALU (expect: clean) ---
	c.li	zero, 3
	lw	s9, 0(s10)
	add	t4, t5, t6
	add	a1, a2, a3

# --- CASE 8: WAR anti-dependence (expect: clean, warning only) ---
	c.li	zero, 2
	add	a0, a1, a2
	add	a1, a4, a5
