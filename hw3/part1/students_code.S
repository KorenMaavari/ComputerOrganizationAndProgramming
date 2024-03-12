.global get_element_from_matrix, inner_prod, matrix_multiplication

# Function to get element from matrix
# Input: matrix (rdi), n (rsi), row (rdx), col (rcx)
# Output: eax contains the element
get_element_from_matrix:
    pushq %rbp
    movq %rsp, %rbp
    movq %rdx, %rax              # row
    imulq %rsi, %rax             # row * n
    addq %rcx, %rax              # row * n + col
    imulq $4, %rax               # each element is a 4-byte integer
    movl (%rdi, %rax), %eax      # load the element of matrix[row][col]
	popq %rbp
    ret

# Function to calculate inner product using get_element_from_matrix
# Input: mat_a (rdi), mat_b (rsi), row_a (rdx), col_b (rcx), max_col_a (r8), max_col_b (r9)
# Output: rax contains the inner product
inner_prod:

    pushq %rbp
    movq %rsp, %rbp
    xorq %rax, %rax              # Initialize result to 0
    movl %r8, %ecx               # Counter for loop, max_col_a and mat_b's number of rows should be equal
    xorl %esi, %esi              # i = 0

inner_prod_loop:

    pushq %rsi
    pushq %rcx
                                 # mat_a is alreay in rdi
    movq %r8, %rsi               # max_col_a
                                 # row_a is alreay in rdx
    movl %esi, %rcx              # i
    call get_element_from_matrix
    popq %rsi
    popq %rcx
    movq %rax, %rbx              # mat_a[row_a][i]

    pushq %rdi
    pushq %rsi
    pushq %rdx
    movq %rsi, %rdi              # mat_b
    movq %r9, %rsi               # max_col_b
    movl %esi, %rdx              # i
                                 # col_b is already in rcx
    call get_element_from_matrix
    popq %rdi
    popq %rsi
    popq %rdx

    imulq %rax, %rbx             # mat_a[row_a][i] * mat_b[i][col_b]
    addq %rbx, %rax              # result += mat_a[row_a][i] * mat_b[i][col_b]
    inc %esi                     # i++
    loop inner_prod_loop

	popq %rbp
    ret

matrix_multiplication:
	ret

# Lidor: Is Lidor responsible to preserve rbx?
# Change the loop to bne or something
# Verify the callee-save
# Differences between signed and unsigned