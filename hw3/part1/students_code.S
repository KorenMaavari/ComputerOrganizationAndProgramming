.global get_element_from_matrix, inner_prod, matrix_multiplication

# Function to get element from matrix
# Input: matrix (rdi), n (rsi), row (rdx), col (rcx)
# Output: eax contains the element
get_element_from_matrix:
	mov rax, rdx      # row
    imul rax, rsi     # row * n
    add rax, rcx      # row * n + col
    imul rax, 4       # each element is a 4-byte integer
    add rax, rdi      # address of matrix[row][col]
    mov eax, [rax]    # load the element
	ret

# Function to calculate inner product using get_element_from_matrix
# Input: mat_a (rdi), mat_b (rsi), row_a (rdx), col_b (rcx), max_col_a (r8), max_col_b (r9)
# Output: eax contains the inner product
inner_prod:
    xor eax, eax      # Initialize result to 0
    mov ecx, r8       # Counter for loop

inner_prod_loop:
    # Get elements from mat_a and mat_b
    mov rax, rdi      # mat_a
    mov rdx, rcx      # col_b
    call get_element_from_matrix
    mov ebx, eax      # mat_a[row_a][i]

    mov rax, rsi      # mat_b
    mov rdx, r9       # max_col_b
    call get_element_from_matrix
    imul ebx, eax     # mat_a[row_a][i] * mat_b[i][col_b]

    add eax, ebx      # result += mat_a[row_a][i] * mat_b[i][col_b]

    add rdi, 4        # Move to the next element in mat_a
    add rsi, 4        # Move to the next element in mat_b
    loop inner_prod_loop

    ret

matrix_multiplication:
	ret
