# FUN_0041b992
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041b992
# extent:       0x0041b992-0x0041bbd9 (583 code bytes)
# span:         0x0041b992-0x0041bbd9 (code 583, tables 0, padding 0)
# sha256:       6193ec68ceb93ef450595ed4e34d07a2b8d00cd1340b0561a9be4d21f5dce287
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# name:         LzssEncoder::insert_node
# arguments:    thiscall in form (ecx is spilled to [ebp-0x14] and never read afterwards); one stack argument arg_node_r at [ebp+8] = r, the ring-buffer position being inserted (dword; used whole for the addressing text_buf+r and 2*r, but only its low 16 bits are stored into the word tables); callee pops 4 (ret 4); no result is produced (eax is scratch at return)
# locals:       frame 0x14 bytes plus saved ebx: [ebp-0x4] word p = current tree node (starts at 0x1001 + first byte of the key); [ebp-0x8] dword key = 0x56f354 + r, the address of the string being inserted; [ebp-0xc] word i = match index inside the compare loop; [ebp-0x10] word cmp = signed difference of the last compared byte pair (starts at 1); [ebp-0x14] = ecx at entry, unused
# fields:       none (no object fields touched); globals only: 0x0056f354 text buf (ring buffer, byte array); 0x0056b148 word array "right" child links, first 0x1001 slots are ring positions and the next 256 are the per-first-byte tree roots (p starts at 0x1001+byte); 0x0056d34c word array "left" child links; 0x00569144 word array parent ("dad") links; 0x0056f34e word best match length; 0x0056f350 word best match position; the value 0x1000 is the "no node" marker
# callees:      none
# track-n:      host-adapter: none
# unverified:   The array roles right/left/dad and the name insert_node are inferred from the access pattern of the bytes (binary search tree keyed by byte-wise comparison of 18-byte strings, 0x12 = maximum match length, 0x1000 = no node) and from the caller 0x41a4c9, which calls this for each ring position of what looks like an LZSS compressor; the bytes do not name the algorithm. Which child array a comparison sign selects is verified from the branches (cmp >= 0 uses 0x56b148, cmp < 0 uses 0x56d34c), "right" and "left" are only labels. The compare difference is unsigned byte minus unsigned byte stored as a word, then tested as signed word; the loop runs i from 1 to at most 0x11 and compares signed words. No bounds check exists on r or on the loaded child links (a link beyond the 0x1001-slot tables would index outside them): unsafe original behaviour on corrupt tables, not examined here. The caller 0x41a4c9 and the exact table sizes are not re-verified from the bytes; the size claims in this header follow from the addresses only. ecx at entry has no use here (not read after the spill), so what object the original method belongs to is not established; it is likely a C++ method of a compressor object whose state lives in globals.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_node_p, 0x4  # [ebp - 0x4]: word p, current tree node being compared
.equ local_key_ptr, 0x8  # [ebp - 0x8]: dword key, pointer 0x56f354 + r into the ring buffer
.equ local_match_i, 0xc  # [ebp - 0xc]: word i, index of the byte pair being compared (1 .. 0x12)
.equ local_cmp, 0x10  # [ebp - 0x10]: word cmp, signed difference of the last byte pair (1 at entry)
.equ local_this_unused, 0x14  # [ebp - 0x14]: ecx at entry, spilled and never read
.equ arg_node_r, 0x8  # [ebp + 0x8]: stack argument r, ring-buffer position to insert

# --- external targets -----------------------------------------------

.org 0x0041b992 - 0x401000
.globl FUN_0041b992
FUN_0041b992:
    # block 0x0041b992: entry: spill ecx, cmp = 1, key = 0x56f354 + r, p = key[0] + 0x1001 (tree root slot for the first byte), right[r] = left[r] = 0x1000 (no node), best match length 0x56f34e = 0
    push ebp                                     # 0041b992
    {load} mov ebp, esp                          # 0041b993
    sub esp, 0x14                                # 0041b995
    push ebx                                     # 0041b998
    mov dword ptr [ebp - local_this_unused], ecx          # 0041b999
    mov word ptr [ebp - local_cmp], 0x1           # 0041b99c
    mov eax, dword ptr [ebp + arg_node_r]             # 0041b9a2
    add eax, 0x56f354                            # 0041b9a5
    mov dword ptr [ebp - local_key_ptr], eax           # 0041b9aa
    mov ecx, dword ptr [ebp - local_key_ptr]           # 0041b9ad
    {load} xor edx, edx                          # 0041b9b0
    mov dl, byte ptr [ecx]                       # 0041b9b2
    add edx, 0x1001                              # 0041b9b4
    mov word ptr [ebp - local_node_p], dx             # 0041b9ba
    mov eax, dword ptr [ebp + arg_node_r]             # 0041b9be
    mov word ptr [2*eax + 0x56d34c], 0x1000      # 0041b9c1
    mov ecx, dword ptr [ebp + arg_node_r]             # 0041b9cb
    mov word ptr [2*ecx + 0x56b148], 0x1000      # 0041b9ce
    mov word ptr [0x56f34e], 0x0                 # 0041b9d8
L_search_loop:
    # block 0x0041b9e1: search loop head: if cmp (signed word) < 0 go to the left branch, otherwise fall into the right branch
    movsx edx, word ptr [ebp - local_cmp]         # 0041b9e1
    test edx, edx                                # 0041b9e5
    jl.d8 L_left_branch                             # 0041b9e7
    # block 0x0041b9e9: cmp >= 0: if right[p] (word array 0x56b148) != 0x1000 take it, otherwise fall into the attach case
    movsx eax, word ptr [ebp - local_node_p]          # 0041b9e9
    movsx ecx, word ptr [2*eax + 0x56b148]       # 0041b9ed
    cmp ecx, 0x1000                              # 0041b9f5
    je.d8 L_attach_right                             # 0041b9fb
    # block 0x0041b9fd: right child exists: p = right[p], then go to the compare step
    movsx edx, word ptr [ebp - local_node_p]          # 0041b9fd
    mov ax, word ptr [2*edx + 0x56b148]          # 0041ba01
    mov word ptr [ebp - local_node_p], ax             # 0041ba09
    jmp.d8 L_after_right_step                            # 0041ba0d
L_attach_right:
    # block 0x0041ba0f: right child is free: right[p] = low word of r, parent[r] (0x569144) = p, return
    movsx ecx, word ptr [ebp - local_node_p]          # 0041ba0f
    mov dx, word ptr [ebp + arg_node_r]               # 0041ba13
    mov word ptr [2*ecx + 0x56b148], dx          # 0041ba17
    mov eax, dword ptr [ebp + arg_node_r]             # 0041ba1f
    mov cx, word ptr [ebp - local_node_p]             # 0041ba22
    mov word ptr [2*eax + 0x569144], cx          # 0041ba26
    jmp.d32 L_epilogue                           # 0041ba2e
L_after_right_step:
    # block 0x0041ba33: after stepping right: go to the byte-compare loop
    jmp.d8 L_compare_keys                            # 0041ba33
L_left_branch:
    # block 0x0041ba35: cmp < 0: if left[p] (word array 0x56d34c) != 0x1000 take it, otherwise fall into the attach case
    movsx edx, word ptr [ebp - local_node_p]          # 0041ba35
    movsx eax, word ptr [2*edx + 0x56d34c]       # 0041ba39
    cmp eax, 0x1000                              # 0041ba41
    je.d8 L_attach_left                             # 0041ba46
    # block 0x0041ba48: left child exists: p = left[p], then go to the compare step
    movsx ecx, word ptr [ebp - local_node_p]          # 0041ba48
    mov dx, word ptr [2*ecx + 0x56d34c]          # 0041ba4c
    mov word ptr [ebp - local_node_p], dx             # 0041ba54
    jmp.d8 L_compare_keys                            # 0041ba58
L_attach_left:
    # block 0x0041ba5a: left child is free: left[p] = low word of r, parent[r] = p, return
    movsx eax, word ptr [ebp - local_node_p]          # 0041ba5a
    mov cx, word ptr [ebp + arg_node_r]               # 0041ba5e
    mov word ptr [2*eax + 0x56d34c], cx          # 0041ba62
    mov edx, dword ptr [ebp + arg_node_r]             # 0041ba6a
    mov ax, word ptr [ebp - local_node_p]             # 0041ba6d
    mov word ptr [2*edx + 0x569144], ax          # 0041ba71
    jmp.d32 L_epilogue                           # 0041ba79
L_compare_keys:
    # block 0x0041ba7e: compare setup: i = 1
    mov word ptr [ebp - local_match_i], 0x1            # 0041ba7e
    jmp.d8 L_i_limit_test                            # 0041ba84
L_next_i:
    # block 0x0041ba86: i = i + 1 (16-bit)
    mov cx, word ptr [ebp - local_match_i]             # 0041ba86
    add cx, 0x1                                  # 0041ba8a
    mov word ptr [ebp - local_match_i], cx             # 0041ba8e
L_i_limit_test:
    # block 0x0041ba92: loop test: if i >= 0x12 (signed) leave the compare loop
    movsx edx, word ptr [ebp - local_match_i]          # 0041ba92
    cmp edx, 0x12                                # 0041ba96
    jge.d8 L_after_compare                            # 0041ba99
    # block 0x0041ba9b: cmp = key[i] - text_buf[p + i] as unsigned bytes stored to a word; if cmp == 0 go on to the next i
    movsx eax, word ptr [ebp - local_match_i]          # 0041ba9b
    mov ecx, dword ptr [ebp - local_key_ptr]           # 0041ba9f
    {load} xor edx, edx                          # 0041baa2
    mov dl, byte ptr [ecx + eax]                 # 0041baa4
    movsx eax, word ptr [ebp - local_node_p]          # 0041baa7
    movsx ecx, word ptr [ebp - local_match_i]          # 0041baab
    {load} xor ebx, ebx                          # 0041baaf
    mov bl, byte ptr [eax + ecx + 0x56f354]      # 0041bab1
    {load} sub edx, ebx                          # 0041bab8
    mov word ptr [ebp - local_cmp], dx            # 0041baba
    movsx edx, word ptr [ebp - local_cmp]         # 0041babe
    test edx, edx                                # 0041bac2
    je.d8 L_pair_equal                             # 0041bac4
    # block 0x0041bac6: cmp != 0: bytes differ, leave the compare loop
    jmp.d8 L_after_compare                            # 0041bac6
L_pair_equal:
    # block 0x0041bac8: cmp == 0: continue with the next i
    jmp.d8 L_next_i                            # 0041bac8
L_after_compare:
    # block 0x0041baca: compare loop finished: if i <= best match length (signed words) go back to the search loop
    movsx eax, word ptr [ebp - local_match_i]          # 0041baca
    movsx ecx, word ptr [0x56f34e]               # 0041bace
    {load} cmp eax, ecx                          # 0041bad5
    jle.d8 L_continue_search                            # 0041bad7
    # block 0x0041bad9: longer match: best match position 0x56f350 = p, best match length 0x56f34e = i; if the new length < 0x12 go back to the search loop
    mov dx, word ptr [ebp - local_node_p]             # 0041bad9
    mov word ptr [0x56f350], dx                  # 0041badd
    mov ax, word ptr [ebp - local_match_i]             # 0041bae4
    mov word ptr [0x56f34e], ax                  # 0041bae8
    movsx ecx, word ptr [0x56f34e]               # 0041baee
    cmp ecx, 0x12                                # 0041baf5
    jl.d8 L_continue_search                             # 0041baf8
    # block 0x0041bafa: match length reached 0x12 (maximum): leave the search and replace node p by r
    jmp.d8 L_replace_node                            # 0041bafa
L_continue_search:
    # block 0x0041bafc: go back to the search loop head
    jmp.d32 L_search_loop                           # 0041bafc
L_replace_node:
    # block 0x0041bb01: replace node p by r: parent[r] = parent[p]; left[r] = left[p]; right[r] = right[p]; parent[left[p]] = r; parent[right[p]] = r; then test whether right[parent[p]] == p
    movsx edx, word ptr [ebp - local_node_p]          # 0041bb01
    mov eax, dword ptr [ebp + arg_node_r]             # 0041bb05
    mov cx, word ptr [2*edx + 0x569144]          # 0041bb08
    mov word ptr [2*eax + 0x569144], cx          # 0041bb10
    movsx edx, word ptr [ebp - local_node_p]          # 0041bb18
    mov eax, dword ptr [ebp + arg_node_r]             # 0041bb1c
    mov cx, word ptr [2*edx + 0x56d34c]          # 0041bb1f
    mov word ptr [2*eax + 0x56d34c], cx          # 0041bb27
    movsx edx, word ptr [ebp - local_node_p]          # 0041bb2f
    mov eax, dword ptr [ebp + arg_node_r]             # 0041bb33
    mov cx, word ptr [2*edx + 0x56b148]          # 0041bb36
    mov word ptr [2*eax + 0x56b148], cx          # 0041bb3e
    movsx edx, word ptr [ebp - local_node_p]          # 0041bb46
    movsx eax, word ptr [2*edx + 0x56d34c]       # 0041bb4a
    mov cx, word ptr [ebp + arg_node_r]               # 0041bb52
    mov word ptr [2*eax + 0x569144], cx          # 0041bb56
    movsx edx, word ptr [ebp - local_node_p]          # 0041bb5e
    movsx eax, word ptr [2*edx + 0x56b148]       # 0041bb62
    mov cx, word ptr [ebp + arg_node_r]               # 0041bb6a
    mov word ptr [2*eax + 0x569144], cx          # 0041bb6e
    movsx edx, word ptr [ebp - local_node_p]          # 0041bb76
    movsx eax, word ptr [2*edx + 0x569144]       # 0041bb7a
    movsx ecx, word ptr [2*eax + 0x56b148]       # 0041bb82
    movsx edx, word ptr [ebp - local_node_p]          # 0041bb8a
    {load} cmp ecx, edx                          # 0041bb8e
    jne.d8 L_fix_left_link_of_parent                            # 0041bb90
    # block 0x0041bb92: right[parent[p]] == p: right[parent[p]] = low word of r
    movsx eax, word ptr [ebp - local_node_p]          # 0041bb92
    movsx ecx, word ptr [2*eax + 0x569144]       # 0041bb96
    mov dx, word ptr [ebp + arg_node_r]               # 0041bb9e
    mov word ptr [2*ecx + 0x56b148], dx          # 0041bba2
    jmp.d8 L_clear_old_parent                            # 0041bbaa
L_fix_left_link_of_parent:
    # block 0x0041bbac: otherwise: left[parent[p]] = low word of r
    movsx eax, word ptr [ebp - local_node_p]          # 0041bbac
    movsx ecx, word ptr [2*eax + 0x569144]       # 0041bbb0
    mov dx, word ptr [ebp + arg_node_r]               # 0041bbb8
    mov word ptr [2*ecx + 0x56d34c], dx          # 0041bbbc
L_clear_old_parent:
    # block 0x0041bbc4: parent[p] = 0x1000, the old node p leaves the tree
    movsx eax, word ptr [ebp - local_node_p]          # 0041bbc4
    mov word ptr [2*eax + 0x569144], 0x1000      # 0041bbc8
L_epilogue:
    # block 0x0041bbd2: epilogue: restore ebx and the frame, ret 4
    pop ebx                                      # 0041bbd2
    {load} mov esp, ebp                          # 0041bbd3
    pop ebp                                      # 0041bbd5
    ret 0x4                                      # 0041bbd6
