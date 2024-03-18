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
    pushq %rbx                   # collee-save
    pushq %r12                   # collee-save
    pushq %r13                   # collee-save
    xorq %r12, %r12              # initialize curr_result to 0
    xorq %rax, %rax              # initialize result to 0
    xorq %r13, %r13              # i = 0

inner_prod_loop:

    cmp %r13, %r8                # compare i with max_col_a
    je  inner_prod_end           # jump to inner_prod_end if i == max_col_a

    pushq %rsi                   # caller-save
    pushq %rcx                   # caller-save
                                 # mat_a is alreay in rdi
    movq %r8, %rsi               # max_col_a
                                 # row_a is alreay in rdx
    movq %r13, %rcx              # i
    call get_element_from_matrix # call
    popq %rcx                    # caller-save
    popq %rsi                    # caller-save
    movq %rax, %rbx              # mat_a[row_a][i]

    pushq %rdi                   # caller-save
    pushq %rsi                   # caller-save
    pushq %rdx                   # caller-save
    movq %rsi, %rdi              # mat_b
    movq %r9, %rsi               # max_col_b
    movq %r13, %rdx              # i
                                 # col_b is already in rcx
    call get_element_from_matrix # call
    popq %rdx                    # caller-save
    popq %rsi                    # caller-save
    popq %rdi                    # caller-save

    imulq %rax, %rbx             # mat_a[row_a][i] * mat_b[i][col_b]
    addq %rbx, %r12              # curr_result += mat_a[row_a][i] * mat_b[i][col_b]
    inc %r13                     # i++
    jmp inner_prod_loop          # jump back to the beginning of the loop

inner_prod_end:

    movq %r12, %rax              # result = curr_result
    popq %r13                    # collee-save
    popq %r12                    # collee-save
    popq %rbx                    # collee-save

    popq %rbp
    ret

matrix_multiplication:
	ret
