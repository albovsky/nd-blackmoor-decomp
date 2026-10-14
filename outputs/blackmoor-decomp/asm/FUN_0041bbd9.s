# FUN_0041bbd9
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041bbd9
# extent:       0x0041bbd9-0x0041bda0 (455 code bytes)
# span:         0x0041bbd9-0x0041bda0 (code 455, tables 0, padding 0)
# sha256:       3daab37a4e668129bf5fa4ba9f30589ba45a2cf43beed828938b6bdafd4daa7b
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# name:         LzssEncoder::delete_tree_node
# arguments:    thiscall: ecx=this, spilled and never read; one stack dword [ebp+8] = node index p (a dword used as a word-array index, not range-checked); callee pops 4 (ret 4); no return value
# locals:       this_unused = ecx spilled and not read again; succ_q = word holding the replacement node q that takes the place of p in the tree (low word of the slot)
# fields:       no object fields touched; absolute globals (word arrays indexed by node number, nil value 0x1000): 0x00569144 = parent array dad[], 0x0056b148 = first child array (called child1 here, tested first), 0x0056d34c = second child array (child2)
# callees:      none
# track-n:      host-adapter: none
# unverified:   That the three arrays are the dad, right-son and left-son arrays of the well-known LZSS binary search tree (nil = 0x1000, root nodes above it) is my identification of the algorithm shape from these bytes and from the sibling insert routine FUN_0041b992 and the callers FUN_0041aaa1 and FUN_0041aeaa in the pseudocode; the evidence is that the structure matches the classic delete of a node with zero, one or two children, but I did not trace the arrays' extents or writers. The array names child1 (0x56b148) and child2 (0x56d34c) are labels; they correspond to the usual right-son and left-son only by the shape of the algorithm. No Track N source covers this routine: src/cif_archive.c decodes LZSS streams and has no tree. Node indices come from the callers and are not checked here (an index above the array extent reads or writes the adjacent array); this is a native rejection point, not valid-input behaviour. The method and class names are my labels, not recovered identifiers. The upper half of the succ_q slot is never initialised and is never read (all reads are movsx of the word).
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ succ_q, 0x4  # word: replacement node q (low word of the slot)
.equ this_unused, 0x8  # this, spilled from ecx and never read
.equ arg_node, 0x8  # stack argument: node index p

# --- external targets -----------------------------------------------

.org 0x0041bbd9 - 0x401000
.globl FUN_0041bbd9
FUN_0041bbd9:
    # block 0x0041bbd9: entry: spill this (unused); load word dad[p] (0x569144 + p*2); if it is not 0x1000 go to child1_test
    push ebp                                     # 0041bbd9
    {load} mov ebp, esp                          # 0041bbda
    sub esp, 0x8                                 # 0041bbdc
    mov dword ptr [ebp - this_unused], ecx           # 0041bbdf
    mov eax, dword ptr [ebp + arg_node]             # 0041bbe2
    movsx ecx, word ptr [2*eax + 0x569144]       # 0041bbe5
    cmp ecx, 0x1000                              # 0041bbed
    jne.d8 child1_test                            # 0041bbf3
    # block 0x0041bbf5: dad[p] is 0x1000: the node is not in the tree, go straight to the epilogue
    jmp.d32 epilogue                           # 0041bbf5
child1_test:
    # block 0x0041bbfa: child1_test: if child1[p] (0x56b148) is not 0x1000 go to child2_nil_test
    mov edx, dword ptr [ebp + arg_node]             # 0041bbfa
    movsx eax, word ptr [2*edx + 0x56b148]       # 0041bbfd
    cmp eax, 0x1000                              # 0041bc05
    jne.d8 child2_nil_test                            # 0041bc0a
    # block 0x0041bc0c: child1[p] is nil: q = child2[p] (0x56d34c), go to splice_into_parent
    mov ecx, dword ptr [ebp + arg_node]             # 0041bc0c
    mov dx, word ptr [2*ecx + 0x56d34c]          # 0041bc0f
    mov word ptr [ebp - succ_q], dx             # 0041bc17
    jmp.d32 splice_into_parent                           # 0041bc1b
child2_nil_test:
    # block 0x0041bc20: child2_nil_test: if child2[p] is not 0x1000 go to two_children
    mov eax, dword ptr [ebp + arg_node]             # 0041bc20
    movsx ecx, word ptr [2*eax + 0x56d34c]       # 0041bc23
    cmp ecx, 0x1000                              # 0041bc2b
    jne.d8 two_children                            # 0041bc31
    # block 0x0041bc33: child2[p] is nil: q = child1[p], go to splice_into_parent
    mov edx, dword ptr [ebp + arg_node]             # 0041bc33
    mov ax, word ptr [2*edx + 0x56b148]          # 0041bc36
    mov word ptr [ebp - succ_q], ax             # 0041bc3e
    jmp.d32 splice_into_parent                           # 0041bc42
two_children:
    # block 0x0041bc47: two_children: q = child2[p]; if child1[q] is 0x1000 go to link_child1_of_p, else fall into the descent loop
    mov ecx, dword ptr [ebp + arg_node]             # 0041bc47
    mov dx, word ptr [2*ecx + 0x56d34c]          # 0041bc4a
    mov word ptr [ebp - succ_q], dx             # 0041bc52
    movsx eax, word ptr [ebp - succ_q]          # 0041bc56
    movsx ecx, word ptr [2*eax + 0x56b148]       # 0041bc5a
    cmp ecx, 0x1000                              # 0041bc62
    je.d32 link_child1_of_p                            # 0041bc68
descend_child1:
    # block 0x0041bc6e: descend_child1: q = child1[q]; repeat while child1[q] is not 0x1000
    movsx edx, word ptr [ebp - succ_q]          # 0041bc6e
    mov ax, word ptr [2*edx + 0x56b148]          # 0041bc72
    mov word ptr [ebp - succ_q], ax             # 0041bc7a
    movsx ecx, word ptr [ebp - succ_q]          # 0041bc7e
    movsx edx, word ptr [2*ecx + 0x56b148]       # 0041bc82
    cmp edx, 0x1000                              # 0041bc8a
    jne.d8 descend_child1                            # 0041bc90
    # block 0x0041bc92: q has no child1 (end of the descent): child1[dad[q]] = child2[q]; dad[child2[q]] = dad[q]; child2[q] = child2[p]; dad[child2[p]] = q
    movsx eax, word ptr [ebp - succ_q]          # 0041bc92
    movsx ecx, word ptr [ebp - succ_q]          # 0041bc96
    movsx edx, word ptr [2*ecx + 0x569144]       # 0041bc9a
    mov ax, word ptr [2*eax + 0x56d34c]          # 0041bca2
    mov word ptr [2*edx + 0x56b148], ax          # 0041bcaa
    movsx ecx, word ptr [ebp - succ_q]          # 0041bcb2
    movsx edx, word ptr [ebp - succ_q]          # 0041bcb6
    movsx eax, word ptr [2*edx + 0x56d34c]       # 0041bcba
    mov cx, word ptr [2*ecx + 0x569144]          # 0041bcc2
    mov word ptr [2*eax + 0x569144], cx          # 0041bcca
    movsx edx, word ptr [ebp - succ_q]          # 0041bcd2
    mov eax, dword ptr [ebp + arg_node]             # 0041bcd6
    mov cx, word ptr [2*eax + 0x56d34c]          # 0041bcd9
    mov word ptr [2*edx + 0x56d34c], cx          # 0041bce1
    mov edx, dword ptr [ebp + arg_node]             # 0041bce9
    movsx eax, word ptr [2*edx + 0x56d34c]       # 0041bcec
    mov cx, word ptr [ebp - succ_q]             # 0041bcf4
    mov word ptr [2*eax + 0x569144], cx          # 0041bcf8
link_child1_of_p:
    # block 0x0041bd00: link_child1_of_p: child1[q] = child1[p]; dad[child1[p]] = q
    movsx edx, word ptr [ebp - succ_q]          # 0041bd00
    mov eax, dword ptr [ebp + arg_node]             # 0041bd04
    mov cx, word ptr [2*eax + 0x56b148]          # 0041bd07
    mov word ptr [2*edx + 0x56b148], cx          # 0041bd0f
    mov edx, dword ptr [ebp + arg_node]             # 0041bd17
    movsx eax, word ptr [2*edx + 0x56b148]       # 0041bd1a
    mov cx, word ptr [ebp - succ_q]             # 0041bd22
    mov word ptr [2*eax + 0x569144], cx          # 0041bd26
splice_into_parent:
    # block 0x0041bd2e: splice_into_parent: dad[q] = dad[p]; if child1[dad[p]] equals p (signed word compare against the dword argument) go to the first-child store, else go to parent_child2_slot
    movsx edx, word ptr [ebp - succ_q]          # 0041bd2e
    mov eax, dword ptr [ebp + arg_node]             # 0041bd32
    mov cx, word ptr [2*eax + 0x569144]          # 0041bd35
    mov word ptr [2*edx + 0x569144], cx          # 0041bd3d
    mov edx, dword ptr [ebp + arg_node]             # 0041bd45
    movsx eax, word ptr [2*edx + 0x569144]       # 0041bd48
    movsx ecx, word ptr [2*eax + 0x56b148]       # 0041bd50
    cmp ecx, dword ptr [ebp + arg_node]             # 0041bd58
    jne.d8 parent_child2_slot                            # 0041bd5b
    # block 0x0041bd5d: p is the parent child1: child1[dad[p]] = q, go to clear_parent
    mov edx, dword ptr [ebp + arg_node]             # 0041bd5d
    movsx eax, word ptr [2*edx + 0x569144]       # 0041bd60
    mov cx, word ptr [ebp - succ_q]             # 0041bd68
    mov word ptr [2*eax + 0x56b148], cx          # 0041bd6c
    jmp.d8 clear_parent                            # 0041bd74
parent_child2_slot:
    # block 0x0041bd76: parent_child2_slot: p is the parent child2: child2[dad[p]] = q
    mov edx, dword ptr [ebp + arg_node]             # 0041bd76
    movsx eax, word ptr [2*edx + 0x569144]       # 0041bd79
    mov cx, word ptr [ebp - succ_q]             # 0041bd81
    mov word ptr [2*eax + 0x56d34c], cx          # 0041bd85
clear_parent:
    # block 0x0041bd8d: clear_parent: dad[p] = 0x1000 (node removed)
    mov edx, dword ptr [ebp + arg_node]             # 0041bd8d
    mov word ptr [2*edx + 0x569144], 0x1000      # 0041bd90
epilogue:
    # block 0x0041bd9a: epilogue: restore the frame and return, popping the one stack argument (ret 4)
    {load} mov esp, ebp                          # 0041bd9a
    pop ebp                                      # 0041bd9c
    ret 0x4                                      # 0041bd9d
