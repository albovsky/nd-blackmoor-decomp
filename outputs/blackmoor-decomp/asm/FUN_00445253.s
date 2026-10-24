# FUN_00445253
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00445253
# extent:       0x00445253-0x004453a7 (340 code bytes)
# span:         0x00445253-0x004453b7 (code 340, tables 16, padding 0)
# sha256:       64b906b78c7338014ec32ac956718b9dfe29db91cd5ec1e524c343a328483aeb
# evidence:     ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m445253_lifted
# naming:       native port src/original_methods_fl40.c:m445253_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 8 seeds; oracle 82/82 instructions, 4/4 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       15 ebp-relative slot(s): local_4, local_9, local_a, local_c, local_10, local_14, local_18, local_1a, local_1c, local_1e, local_20, local_42 and 3 more
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050cd50, FUN_0043f210, FUN_0041fd08
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m445253_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 82 instruction(s), 2 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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

.org 0x00445253 - 0x401000
.globl FUN_00445253
FUN_00445253:
    # block 0x00445253: entry, 8 instruction(s), calls FUN_0050cd50, ends with jns to 0x0044526f (forward)
    push ebp                                     # 00445253
    {load} mov ebp, esp                          # 00445254
    sub esp, 0x1dc                               # 00445256
    push esi                                     # 0044525c
    push edi                                     # 0044525d
    call FUN_0050cd50                            # 0044525e
    and eax, 0x80000003                          # 00445263
    jns.d8 L_0044526f                            # 00445268
    # block 0x0044526a: entered by fall-through of jns at 0x00445268, 3 instruction(s), falls into the block at 0x0044526f
    dec eax                                      # 0044526a
    or eax, -0x4                                 # 0044526b
    inc eax                                      # 0044526e
L_0044526f:
    # block 0x0044526f: entered by jns at 0x00445268, 29 instruction(s), calls FUN_0043f210, ends with ja to 0x00445390 (forward)
    mov word ptr [ebp - local_4], ax             # 0044526f
    push 0x548188                                # 00445273
    push 0x63a820                                # 00445278
    lea eax, [ebp - local_1d2]                   # 0044527d
    push eax                                     # 00445283
    call FUN_0043f210                            # 00445284
    add esp, 0xc                                 # 00445289
    mov edi, 0x548190                            # 0044528c
    lea edx, [ebp - local_42]                    # 00445291
    or ecx, -0x1                                 # 00445294
    {load} xor eax, eax                          # 00445297
    repne scasb al, byte ptr es:[edi]            # 00445299
    not ecx                                      # 0044529b
    {load} sub edi, ecx                          # 0044529d
    {load} mov esi, edi                          # 0044529f
    {load} mov eax, ecx                          # 004452a1
    {load} mov edi, edx                          # 004452a3
    shr ecx, 0x2                                 # 004452a5
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004452a8
    {load} mov ecx, eax                          # 004452aa
    and ecx, 0x3                                 # 004452ac
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004452af
    mov dword ptr [ebp - local_18], 0x0          # 004452b1
    mov dword ptr [ebp - local_14], 0x0          # 004452b8
    mov dword ptr [ebp - local_10], 0x1          # 004452bf
    movsx ecx, word ptr [ebp - local_4]          # 004452c6
    mov dword ptr [ebp - local_1dc], ecx         # 004452ca
    cmp dword ptr [ebp - local_1dc], 0x3         # 004452d0
    ja.d32 L_00445390                            # 004452d7
    # block 0x004452dd: entered by fall-through of ja at 0x004452d7, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x4453a7]
    mov edx, dword ptr [ebp - local_1dc]         # 004452dd
    jmp dword ptr [4*edx + SWTAB_004453a7_VA]    # 004452e3
L_004452ea:
    # block 0x004452ea: entered by switch case, 8 instruction(s), ends with forward jump to 0x00445390
    mov word ptr [ebp - local_20], 0x50a         # 004452ea
    mov word ptr [ebp - local_1e], 0x0           # 004452f0
    mov word ptr [ebp - local_1c], 0x0           # 004452f6
    mov word ptr [ebp - local_1a], 0x1           # 004452fc
    mov word ptr [ebp - local_c], 0xffff         # 00445302
    mov byte ptr [ebp - local_a], 0x0            # 00445308
    mov word ptr [ebp - local_9], 0x2            # 0044530c
    jmp.d8 L_00445390                            # 00445312
L_00445314:
    # block 0x00445314: entered by switch case, 8 instruction(s), ends with forward jump to 0x00445390
    mov word ptr [ebp - local_20], 0x50b         # 00445314
    mov word ptr [ebp - local_1e], 0x0           # 0044531a
    mov word ptr [ebp - local_1c], 0x0           # 00445320
    mov word ptr [ebp - local_1a], 0x1           # 00445326
    mov word ptr [ebp - local_c], 0xffff         # 0044532c
    mov byte ptr [ebp - local_a], 0x0            # 00445332
    mov word ptr [ebp - local_9], 0x2            # 00445336
    jmp.d8 L_00445390                            # 0044533c
L_0044533e:
    # block 0x0044533e: entered by switch case, 8 instruction(s), ends with forward jump to 0x00445390
    mov word ptr [ebp - local_20], 0x50c         # 0044533e
    mov word ptr [ebp - local_1e], 0x0           # 00445344
    mov word ptr [ebp - local_1c], 0x0           # 0044534a
    mov word ptr [ebp - local_1a], 0x1           # 00445350
    mov word ptr [ebp - local_c], 0xffff         # 00445356
    mov byte ptr [ebp - local_a], 0x0            # 0044535c
    mov word ptr [ebp - local_9], 0x2            # 00445360
    jmp.d8 L_00445390                            # 00445366
L_00445368:
    # block 0x00445368: entered by switch case, 7 instruction(s), falls into the block at 0x00445390
    mov word ptr [ebp - local_20], 0x50d         # 00445368
    mov word ptr [ebp - local_1e], 0x0           # 0044536e
    mov word ptr [ebp - local_1c], 0x0           # 00445374
    mov word ptr [ebp - local_1a], 0x1           # 0044537a
    mov word ptr [ebp - local_c], 0xffff         # 00445380
    mov byte ptr [ebp - local_a], 0x0            # 00445386
    mov word ptr [ebp - local_9], 0x2            # 0044538a
L_00445390:
    # block 0x00445390: entered by ja at 0x004452d7; jmp at 0x00445312; jmp at 0x0044533c; jmp at 0x00445366, 9 instruction(s), calls FUN_0041fd08, ends with ret
    lea eax, [ebp - local_1d8]                   # 00445390
    push eax                                     # 00445396
    mov ecx, 0x6177e8                            # 00445397
    call FUN_0041fd08                            # 0044539c
    pop edi                                      # 004453a1
    pop esi                                      # 004453a2
    {load} mov esp, ebp                          # 004453a3
    pop ebp                                      # 004453a5
    ret                                          # 004453a6

# --- data items (not part of the function) -------------------------
.org 0x004453a7 - 0x401000
SWTAB_004453a7:  # 4 case address(es)
    .long L_004452ea - .text + 0x401000
    .long L_00445314 - .text + 0x401000
    .long L_0044533e - .text + 0x401000
    .long L_00445368 - .text + 0x401000
.set SWTAB_004453a7_VA, SWTAB_004453a7 - .text + 0x401000

