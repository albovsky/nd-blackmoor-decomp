# FUN_004458d4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004458d4
# extent:       0x004458d4-0x004459fd (297 code bytes)
# span:         0x004458d4-0x004459fd (code 297, tables 0, padding 0)
# sha256:       55aa7ec89e87a0f668319546da2912321ba1d04160eac1e9658d8458dcc1842c
# evidence:     ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_nmp90_record_builder
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4458d4.c.txt, not original source) refers to the data labelled s_NMP90_005481d8
# name-note:    Picks a random variant of 3, fills a record with the NMP90 string and id 0x69a-0x69c via FUN_0043f210, then passes it to FUN_0041fd08.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       15 ebp-relative slot(s): local_4, local_9, local_a, local_c, local_10, local_14, local_18, local_1a, local_1c, local_1e, local_20, local_42 and 3 more
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050cd50, FUN_0043f210, FUN_0041fd08
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m41bf4d_lifted (function ledger class candidate_port; also m4458d4_lifted; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 75 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_9, 0x9  # offset -0x9
.equ local_a, 0xa  # offset -0xa
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1a, 0x1a  # offset -0x1a
.equ local_1c, 0x1c  # offset -0x1c
.equ local_1e, 0x1e  # offset -0x1e
.equ local_20, 0x20  # offset -0x20
.equ local_42, 0x42  # offset -0x42
.equ local_1d2, 0x1d2  # offset -0x1d2
.equ local_1d8, 0x1d8  # offset -0x1d8
.equ local_1dc, 0x1dc  # offset -0x1dc

# --- external targets -----------------------------------------------
.set FUN_0041fd08, .text + (0x0041fd08 - 0x401000)
.set FUN_0043f210, .text + (0x0043f210 - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)

.org 0x004458d4 - 0x401000
.globl FUN_004458d4
FUN_004458d4:
    # block 0x004458d4: entry, 38 instruction(s), calls FUN_0050cd50, FUN_0043f210, ends with je to 0x0044596a (forward)
    push ebp                                     # 004458d4
    {load} mov ebp, esp                          # 004458d5
    sub esp, 0x1dc                               # 004458d7
    push esi                                     # 004458dd
    push edi                                     # 004458de
    call FUN_0050cd50                            # 004458df
    cdq                                          # 004458e4
    mov ecx, 0x3                                 # 004458e5
    idiv ecx                                     # 004458ea
    mov word ptr [ebp - local_4], dx             # 004458ec
    push 0x5481d8                                # 004458f0
    push 0x63a834                                # 004458f5
    lea edx, [ebp - local_1d2]                   # 004458fa
    push edx                                     # 00445900
    call FUN_0043f210                            # 00445901
    add esp, 0xc                                 # 00445906
    mov edi, 0x5481e0                            # 00445909
    lea edx, [ebp - local_42]                    # 0044590e
    or ecx, -0x1                                 # 00445911
    {load} xor eax, eax                          # 00445914
    repne scasb al, byte ptr es:[edi]            # 00445916
    not ecx                                      # 00445918
    {load} sub edi, ecx                          # 0044591a
    {load} mov esi, edi                          # 0044591c
    {load} mov eax, ecx                          # 0044591e
    {load} mov edi, edx                          # 00445920
    shr ecx, 0x2                                 # 00445922
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00445925
    {load} mov ecx, eax                          # 00445927
    and ecx, 0x3                                 # 00445929
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0044592c
    mov dword ptr [ebp - local_18], 0x0          # 0044592e
    mov dword ptr [ebp - local_14], 0x0          # 00445935
    mov dword ptr [ebp - local_10], 0x1          # 0044593c
    movsx ecx, word ptr [ebp - local_4]          # 00445943
    mov dword ptr [ebp - local_1dc], ecx         # 00445947
    cmp dword ptr [ebp - local_1dc], 0x0         # 0044594d
    je.d8 L_0044596a                             # 00445954
    # block 0x00445956: entered by fall-through of je at 0x00445954, 2 instruction(s), ends with je to 0x00445994 (forward)
    cmp dword ptr [ebp - local_1dc], 0x1         # 00445956
    je.d8 L_00445994                             # 0044595d
    # block 0x0044595f: entered by fall-through of je at 0x0044595d, 2 instruction(s), ends with je to 0x004459be (forward)
    cmp dword ptr [ebp - local_1dc], 0x2         # 0044595f
    je.d8 L_004459be                             # 00445966
    # block 0x00445968: entered by fall-through of je at 0x00445966, 1 instruction(s), ends with forward jump to 0x004459e6
    jmp.d8 L_004459e6                            # 00445968
L_0044596a:
    # block 0x0044596a: entered by je at 0x00445954, 8 instruction(s), ends with forward jump to 0x004459e6
    mov word ptr [ebp - local_20], 0x69a         # 0044596a
    mov word ptr [ebp - local_1e], 0x0           # 00445970
    mov word ptr [ebp - local_1c], 0x0           # 00445976
    mov word ptr [ebp - local_1a], 0x1           # 0044597c
    mov word ptr [ebp - local_c], 0xffff         # 00445982
    mov byte ptr [ebp - local_a], 0x0            # 00445988
    mov word ptr [ebp - local_9], 0x2            # 0044598c
    jmp.d8 L_004459e6                            # 00445992
L_00445994:
    # block 0x00445994: entered by je at 0x0044595d, 8 instruction(s), ends with forward jump to 0x004459e6
    mov word ptr [ebp - local_20], 0x69b         # 00445994
    mov word ptr [ebp - local_1e], 0x0           # 0044599a
    mov word ptr [ebp - local_1c], 0x0           # 004459a0
    mov word ptr [ebp - local_1a], 0x1           # 004459a6
    mov word ptr [ebp - local_c], 0xffff         # 004459ac
    mov byte ptr [ebp - local_a], 0x0            # 004459b2
    mov word ptr [ebp - local_9], 0x2            # 004459b6
    jmp.d8 L_004459e6                            # 004459bc
L_004459be:
    # block 0x004459be: entered by je at 0x00445966, 7 instruction(s), falls into the block at 0x004459e6
    mov word ptr [ebp - local_20], 0x69c         # 004459be
    mov word ptr [ebp - local_1e], 0x0           # 004459c4
    mov word ptr [ebp - local_1c], 0x0           # 004459ca
    mov word ptr [ebp - local_1a], 0x1           # 004459d0
    mov word ptr [ebp - local_c], 0xffff         # 004459d6
    mov byte ptr [ebp - local_a], 0x0            # 004459dc
    mov word ptr [ebp - local_9], 0x2            # 004459e0
L_004459e6:
    # block 0x004459e6: entered by jmp at 0x00445968; jmp at 0x00445992; jmp at 0x004459bc, 9 instruction(s), calls FUN_0041fd08, ends with ret
    lea edx, [ebp - local_1d8]                   # 004459e6
    push edx                                     # 004459ec
    mov ecx, 0x6177e8                            # 004459ed
    call FUN_0041fd08                            # 004459f2
    pop edi                                      # 004459f7
    pop esi                                      # 004459f8
    {load} mov esp, ebp                          # 004459f9
    pop ebp                                      # 004459fb
    ret                                          # 004459fc

