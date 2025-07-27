.section .rodata
	msg_stack_empty:
	.string	"Stack is Empty\n"
	
	msg_stack_full:
	.string	"Stack is Full\n"

	msg_queue_empty:
	.string	"Queue is Empty\n"

	msg_queue_full:
	.string	"Queue is Full\n"
	
	msg_graph_size:
	.string	"Enter no of vertices of the graph : "

	msg_edge_exists:
	.string	"Edge Exists %d -> %d (1/0) : "

	msg_sg1:
	.string	"Vertex %d -> "

	msg_sg2:
	.string	"%d -> "

	msg_sg3:
	.string	"NULL\n"

	msg_s:
	.string	"%d"

	msg_dfs:
	.string	"Depth First Search : \n"
	
	msg_bfs:
	.string	"Breadth First Search : \n"

	msg:
	.string	"%d "

	msg_empty:
	.string	""
	
	msg_adjacency:
	.string	"Adjacency List :\n"

.section .data
	.globl	size
	.type	size, @object
	.size	size, 4
	.align	4
	size:
	.int	100

	
.section .bss
	.comm	stack, 104, 4		# 1st 4 bytes -> top, rest array
	.comm	queue, 108, 4		# 1st 8 bytes -> front, rear
	.comm	graph, 8, 4		# p_arr, N		

.section .text
.globl	main
.type	main, @function

main:
	pushl	%ebp
	movl	%esp, %ebp
	
	pushl	$msg_graph_size
	call	printf
	addl	$4, %esp

	movl	$graph, %eax
	leal	4(%eax), %edx
	
	pushl	%edx
	pushl	$msg_s
	call	scanf		    # N == no of vertices
	addl	$8, %esp	    

	call	create_graph

	pushl	$msg_adjacency
	call	printf
	addl	$4, %esp
	call	show_graph

	pushl	$msg_dfs
	call	printf
	addl	$4, %esp
	call	dfs
	pushl	$msg_empty
	call	puts
	addl	$4, %esp

	pushl	$msg_bfs
	call	printf
	addl	$4, %esp
	call	bfs
	pushl	$msg_empty
	call	puts
	addl	$4, %esp

	pushl	$0
	call	exit
	
.globl	bfs
.type	bfs, @function

bfs:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$12, %esp

	movl	$graph, %eax
	movl	4(%eax), %edx
	
	pushl	$4
	pushl	%edx
	call	calloc
	addl	$8, %esp
	movl	%eax, -4(%ebp)

	call	init_queue
	pushl	$1
	call	enqueue	
	addl	$4, %esp

	jmp	bfs_while_cnd

bfs_while_body:
	call	dequeue
	movl	%eax, -8(%ebp)

	subl	$1, %eax
	movl	-4(%ebp), %edx
	movl	(%edx, %eax, 4), %ecx
	cmpl	$0, %ecx
	jne	bfs_while_cnd
	
	pushl	-8(%ebp)
	pushl	$msg
	call	printf
	addl	$8, %esp

	movl	-8(%ebp), %eax
	subl	$1, %eax
	movl	-4(%ebp), %ebx
	movl	$1, (%ebx, %eax, 4)

	movl	$graph, %edx
	movl	(%edx), %edx
	movl	(%edx, %eax, 4), %edx
	movl	(%edx), %edx
	movl	%edx, -12(%ebp)

	jmp	bfs_for_cnd

bfs_for_body:
	movl	4(%eax), %edx
	pushl	%edx
	call	enqueue
	addl	$4, %esp

	movl	-12(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, -12(%ebp)

bfs_for_cnd:
	movl	-12(%ebp), %eax
	cmpl	$0, %eax
	jne	bfs_for_body

bfs_while_cnd:
	call	queue_empty
	cmpl	$0, %eax
	je	bfs_while_body

	movl	%ebp, %esp
	popl	%ebp
	ret


.globl	dfs
.type	dfs, @function

dfs:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$12, %esp

	movl	$graph, %eax
	movl	4(%eax), %edx
	
	pushl	$4
	pushl	%edx
	call	calloc
	addl	$8, %esp
	movl	%eax, -4(%ebp)

	call	init_stack
	pushl	$1
	call	push_stack		# Starting vertex is 1
	addl	$4, %esp

	jmp	dfs_while_cnd

dfs_while_body:
	call	pop_stack
	movl	%eax, -8(%ebp)

	subl	$1, %eax
	movl	-4(%ebp), %edx
	movl	(%edx, %eax, 4), %ecx
	cmpl	$0, %ecx
	jne	dfs_while_cnd
	
	pushl	-8(%ebp)
	pushl	$msg
	call	printf
	addl	$8, %esp

	movl	-8(%ebp), %eax
	subl	$1, %eax
	movl	-4(%ebp), %ebx
	movl	$1, (%ebx, %eax, 4)

	movl	$graph, %edx
	movl	(%edx), %edx
	movl	(%edx, %eax, 4), %edx
	movl	(%edx), %edx
	movl	%edx, -12(%ebp)

	jmp	dfs_for_cnd

dfs_for_body:
	movl	4(%eax), %edx
	pushl	%edx
	call	push_stack
	addl	$4, %esp

	movl	-12(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, -12(%ebp)

dfs_for_cnd:
	movl	-12(%ebp), %eax
	cmpl	$0, %eax
	jne	dfs_for_body

dfs_while_cnd:
	call	stack_empty
	cmpl	$0, %eax
	je	dfs_while_body

	movl	%ebp, %esp
	popl	%ebp
	ret

.globl	show_graph
.type	show_graph, @function

show_graph:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	$0, -4(%ebp)

	jmp	sg_cnd

sg_body:
	addl	$1, %edx
	pushl	%edx
	pushl	$msg_sg1
	call	printf
	addl	$8, %esp

	movl	-4(%ebp), %edx
	movl	$graph, %eax
	movl	(%eax), %eax
	movl	(%eax, %edx, 4), %ecx
	movl	(%ecx), %ecx
	movl	%ecx, -8(%ebp)

	jmp	sg_nested_cnd
	
sg_nested_body:
	movl	4(%eax), %edx
	pushl	%edx
	pushl	$msg_sg2
	call	printf
	addl	$8, %esp
	
	movl	-8(%ebp), %eax
	movl	(%eax), %edx
	movl	%edx, -8(%ebp)

sg_nested_cnd:
	movl	-8(%ebp), %eax
#	movl	(%eax), %ebx
	cmpl	$0, %eax
	jne	sg_nested_body

	pushl	$msg_sg3
	call	printf
	addl	$4, %esp

	addl	$1, -4(%ebp)

sg_cnd:
	movl	$graph, %eax
	movl	4(%eax), %eax
	movl	-4(%ebp), %edx
	cmpl	%eax, %edx
	jl	sg_body

	movl	%ebp, %esp
	popl	%ebp
	ret


.globl	vertex_insert
.type	vertex_insert, @function

vertex_insert:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp

	call	get_node
	movl	%eax, -4(%ebp)
	movl	12(%ebp), %edx
	movl	%edx, 4(%eax)

	movl	8(%ebp), %edx
	movl	%edx, -8(%ebp)
	jmp	vi_cnd

vi_body:
	movl	%eax, -8(%ebp)

vi_cnd:
	movl	-8(%ebp), %eax
	movl	(%eax), %eax
	cmpl	$0, %eax
	jne	vi_body

	movl	-4(%ebp), %ebx
	movl	-8(%ebp), %eax
	movl	%ebx, (%eax)
	
		
	movl	%ebp, %esp
	popl	%ebp
	ret


.globl	create_graph
.type	create_graph, @function

create_graph:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	
	movl	$graph, %eax
	movl	4(%eax), %edx
	
	pushl	$4
	pushl	%edx
	call	calloc
	addl	$8, %esp
	
	movl	$graph, %ebx
	movl	%eax, (%ebx)

	movl	$0, -4(%ebp)
	jmp	for_cnd_1

for_body_1:
	call	get_node		# next, vertex
	movl	-4(%ebp), %ebx
	movl	%ebx, %edx
	addl	$1, %edx

	movl	%edx, 4(%eax)
	movl	$graph, %edx
	movl	(%edx), %ecx
	movl	%eax, (%ecx, %ebx, 4)

	addl	$1, -4(%ebp)

for_cnd_1:
	movl	-4(%ebp), %ebx
	movl	$graph, %eax
	movl	4(%eax), %ecx
	cmpl	%ecx, %ebx
	jl	for_body_1


	movl	$0, -4(%ebp)
	movl	$0, -8(%ebp)
	jmp	for_cnd_2

for_body_2:
	movl	$0, -8(%ebp)
	jmp	nested_for_cnd

nested_for_body:
	movl	-4(%ebp), %eax
	movl	-8(%ebp), %edx
	addl	$1, %eax
	addl	$1, %edx

	pushl	%edx
	pushl	%eax
	pushl	$msg_edge_exists
	call	printf
	addl	$4, %esp

	leal	-12(%ebp), %eax
	pushl	%eax
	pushl	$msg_s
	call	scanf
	addl	$8, %esp

	movl	-12(%ebp), %eax
	cmpl	$0, %eax
	je	nested_for_out

	movl	$graph, %eax
	movl	-4(%ebp), %edx
	movl	-8(%ebp), %ecx
	addl	$1, %ecx

	movl	(%eax), %eax
	movl	(%eax, %edx, 4), %eax

	pushl	%ecx
	pushl	%eax
	call	vertex_insert
	addl	$8, %esp

nested_for_out:
	addl	$1, -8(%ebp)

nested_for_cnd:
	movl	-8(%ebp), %edx
	movl	$graph, %eax
	movl	4(%eax), %eax
	cmpl	%eax, %edx
	jl	nested_for_body

	addl	$1, -4(%ebp)

for_cnd_2:
	movl	-4(%ebp), %edx
	movl	$graph, %eax
	movl	4(%eax), %eax
	cmpl	%eax, %edx
	jl	for_body_2
	
	movl	%ebp, %esp
	popl	%ebp
	ret


.globl	get_node
.type	get_node, @function

get_node:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$4, %esp

	pushl	$4
	pushl	$2
	call	calloc
	addl	$8, %esp

	movl	%eax, -4(%ebp)

	movl	%ebp, %esp
	popl	%ebp
	ret


.globl	dequeue
.type	dequeue, @function

dequeue:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$4, %esp

	call	queue_empty
	cmpl	$1, %eax
	je	dequeue_empty

	movl	$8, %ebx
	movl	$queue, %eax
	movl	(%eax), %edx
	movl	4(%eax), %ecx

	cmpl	%edx, %ecx
	jne	dq_out

	movl	queue(%ebx, %edx, 4), %esi
	movl	%esi, -4(%ebp)
	movl	$-1, %esi
	movl	%esi, (%eax)
	movl	%esi, 4(%eax)
	movl	-4(%ebp), %eax
	
	jmp	dequeue_out

dequeue_empty:
	pushl	$msg_queue_empty
	call	printf
	addl	$4, %esp
	movl	$-1, %eax
	jmp	dequeue_out

dq_out:
	movl	queue(%ebx, %edx, 4), %esi
	movl	%esi, -4(%ebp)
	addl	$1, %edx
	movl	%edx, (%eax)
	movl	%esi, %eax
	
dequeue_out:
	movl	%ebp, %esp
	popl	%ebp
	ret


.globl	enqueue
.type	enqueue, @function

enqueue:
	pushl	%ebp
	movl	%esp, %ebp

	call	queue_full
	cmpl	$1, %eax
	je	enqueue_full

	movl	$queue, %eax
	movl	(%eax), %edx
	movl	4(%eax), %ecx

	cmpl	$-1, %edx
	jne	enqueue_out

	cmpl	$-1, %ecx
	jne	enqueue_out

	addl	$1, %edx
	addl	$1, %ecx
	
	movl	%edx, (%eax)
	movl	%ecx, 4(%eax)

	movl	$8, %ebx
	movl	8(%ebp), %edx
	movl	%edx, queue(%ebx, %ecx, 4)

	jmp	q_out

enqueue_full:
	pushl	$msg_queue_full
	call	printf
	addl	$4, %esp
	jmp	q_out

enqueue_out:
	movl	8(%ebp), %edx
	movl	4(%eax), %ecx
	addl	$1, %ecx
	movl	%ecx, 4(%eax)
	movl	$8, %ebx
	movl	%edx, queue(%ebx, %ecx, 4)

q_out:
	movl	%ebp, %esp
	popl	%ebp
	ret


.globl	pop_stack
.type	pop_stack, @function

pop_stack:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$4, %esp

	call	stack_empty
	cmpl	$1, %eax
	je	pop_stack_empty

	movl	$stack, %eax
	movl	(%eax), %edx
	movl	$4, %ebx
	movl	stack(%ebx, %edx, 4), %ecx

	movl	%ecx, -4(%ebp)
	subl	$1, %edx
	movl	%edx, (%eax)

	movl	-4(%ebp), %eax
	jmp	pop_stack_out

pop_stack_empty:
	pushl	$msg_stack_empty
	call	printf
	addl	$4, %esp

pop_stack_out:
	movl	%ebp, %esp
	popl	%ebp
	ret


.globl	push_stack
.type	push_stack, @function

push_stack:
	pushl	%ebp
	movl	%esp, %ebp

	call	stack_full
	cmpl	$1, %eax
	je	push_stack_full

	movl	$stack, %eax
	movl	(%eax), %edx
	addl	$1, %edx
	movl	%edx, (%eax)
	
	movl	8(%ebp), %ecx
	movl	$4, %ebx
	movl	%ecx, stack(%ebx, %edx, 4)
	jmp	push_stack_out

push_stack_full:
	pushl	$msg_stack_full
	call	printf
	addl	$4, %esp

push_stack_out:
	movl	%ebp, %esp
	popl	%ebp
	ret


.globl	queue_empty
.type	queue_empty, @function

queue_empty:
	pushl	%ebp
	movl	%esp, %ebp

	movl	$queue, %eax
	movl	(%eax), %edx

	cmpl	$-1, %edx
	je	empty_q

	movl	$0, %eax
	jmp	queue_empty_out

empty_q:
	movl	$1, %eax

queue_empty_out:
	movl	%ebp, %esp
	popl	%ebp
	ret


.globl	queue_full
.type	queue_full, @function

queue_full:
	pushl	%ebp
	movl	%esp, %ebp
	
	movl	$queue, %eax
	movl	4(%eax), %edx

	movl	size, %eax
	subl	$1, %eax

	cmpl	%eax, %edx
	je	full_q

	movl	$0, %eax
	jmp	queue_full_out

full_q:
	movl	$1, %eax

queue_full_out:
	movl	%ebp, %esp
	popl	%ebp
	ret


.globl	stack_full
.type	stack_full, @function

stack_full:
	pushl	%ebp
	movl	%esp, %ebp

	movl	$stack, %eax
	movl	(%eax), %edx

	movl	size, %eax
	subl	$1, %eax

	cmpl	%eax, %edx
	je	full_s

	movl	$0, %eax
	jmp	stack_full_out

full_s:
	movl	$1, %eax

stack_full_out:
	movl	%ebp, %esp
	popl	%ebp
	ret


.globl	stack_empty
.type	stack_empty, @function

stack_empty:
	pushl	%ebp
	movl	%esp, %ebp

	movl	$stack, %eax
	movl	(%eax), %edx
	
	cmpl	$-1, %edx
	je	empty_s

	movl	$0, %eax
	jmp	stack_empty_out

empty_s:
	movl	$1, %eax

stack_empty_out:
	movl	%ebp, %esp
	popl	%ebp
	ret


.globl	init_stack
.type	init_stack, @function
	
init_stack:
	pushl	%ebp
	movl	%esp, %ebp

	movl	$stack, %eax
	movl	$-1, (%eax)
	
	movl	%ebp, %esp
	popl	%ebp
	ret


.globl	init_queue
.type	init_queue, @function

init_queue:
	pushl	%ebp
	movl	%esp, %ebp
	
	movl	$queue, %eax
	movl	$-1, (%eax)
	movl	$-1, 4(%eax)

	movl	%ebp, %esp
	popl	%ebp
	ret
	
	
	
	
























