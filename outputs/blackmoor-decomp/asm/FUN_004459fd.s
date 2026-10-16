# FUN_004459fd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004459fd
# extent:       0x004459fd-0x00445b26 (297 code bytes)
# span:         0x004459fd-0x00445b26 (code 297, tables 0, padding 0)
# sha256:       f8c9f2f461b2f65442c2d8c397716f1aebb6d1a639d1b7dfc456b335fb9e2f7d
# evidence:     ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004459fd
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       15 ebp-relative slot(s): local_4, local_9, local_a, local_c, local_10, local_14, local_18, local_1a, local_1c, local_1e, local_20, local_42 and 3 more
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050cd50, FUN_0043f210, FUN_0041fd08
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 75 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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

.org 0x004459fd - 0x401000
.globl FUN_004459fd
FUN_004459fd:
    # block 0x004459fd: entry, 38 instruction(s), calls FUN_0050cd50, FUN_0043f210, ends with je to 0x00445a93 (forward)
    push ebp                                     # 004459fd
    {load} mov ebp, esp                          # 004459fe
    sub esp, 0x1dc                               # 00445a00
    push esi                                     # 00445a06
    push edi                                     # 00445a07
    call FUN_0050cd50                            # 00445a08
    cdq                                          # 00445a0d
    mov ecx, 0x3                                 # 00445a0e
    idiv ecx                                     # 00445a13
    mov word ptr [ebp - local_4], dx             # 00445a15
    push 0x5481e8                                # 00445a19
    push 0x63a838                                # 00445a1e
    lea edx, [ebp - local_1d2]                   # 00445a23
    push edx                                     # 00445a29
    call FUN_0043f210                            # 00445a2a
    add esp, 0xc                                 # 00445a2f
    mov edi, 0x5481f0                            # 00445a32
    lea edx, [ebp - local_42]                    # 00445a37
    or ecx, -0x1                                 # 00445a3a
    {load} xor eax, eax                          # 00445a3d
    repne scasb al, byte ptr es:[edi]            # 00445a3f
    not ecx                                      # 00445a41
    {load} sub edi, ecx                          # 00445a43
    {load} mov esi, edi                          # 00445a45
    {load} mov eax, ecx                          # 00445a47
    {load} mov edi, edx                          # 00445a49
    shr ecx, 0x2                                 # 00445a4b
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00445a4e
    {load} mov ecx, eax                          # 00445a50
    and ecx, 0x3                                 # 00445a52
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00445a55
    mov dword ptr [ebp - local_18], 0x0          # 00445a57
    mov dword ptr [ebp - local_14], 0x0          # 00445a5e
    mov dword ptr [ebp - local_10], 0x1          # 00445a65
    movsx ecx, word ptr [ebp - local_4]          # 00445a6c
    mov dword ptr [ebp - local_1dc], ecx         # 00445a70
    cmp dword ptr [ebp - local_1dc], 0x0         # 00445a76
    je.d8 L_00445a93                             # 00445a7d
    # block 0x00445a7f: entered by fall-through of je at 0x00445a7d, 2 instruction(s), ends with je to 0x00445abd (forward)
    cmp dword ptr [ebp - local_1dc], 0x1         # 00445a7f
    je.d8 L_00445abd                             # 00445a86
    # block 0x00445a88: entered by fall-through of je at 0x00445a86, 2 instruction(s), ends with je to 0x00445ae7 (forward)
    cmp dword ptr [ebp - local_1dc], 0x2         # 00445a88
    je.d8 L_00445ae7                             # 00445a8f
    # block 0x00445a91: entered by fall-through of je at 0x00445a8f, 1 instruction(s), ends with forward jump to 0x00445b0f
    jmp.d8 L_00445b0f                            # 00445a91
L_00445a93:
    # block 0x00445a93: entered by je at 0x00445a7d, 8 instruction(s), ends with forward jump to 0x00445b0f
    mov word ptr [ebp - local_20], 0x7cb         # 00445a93
    mov word ptr [ebp - local_1e], 0x0           # 00445a99
    mov word ptr [ebp - local_1c], 0x0           # 00445a9f
    mov word ptr [ebp - local_1a], 0x1           # 00445aa5
    mov word ptr [ebp - local_c], 0xffff         # 00445aab
    mov byte ptr [ebp - local_a], 0x0            # 00445ab1
    mov word ptr [ebp - local_9], 0x2            # 00445ab5
    jmp.d8 L_00445b0f                            # 00445abb
L_00445abd:
    # block 0x00445abd: entered by je at 0x00445a86, 8 instruction(s), ends with forward jump to 0x00445b0f
    mov word ptr [ebp - local_20], 0x7cc         # 00445abd
    mov word ptr [ebp - local_1e], 0x0           # 00445ac3
    mov word ptr [ebp - local_1c], 0x0           # 00445ac9
    mov word ptr [ebp - local_1a], 0x1           # 00445acf
    mov word ptr [ebp - local_c], 0xffff         # 00445ad5
    mov byte ptr [ebp - local_a], 0x0            # 00445adb
    mov word ptr [ebp - local_9], 0x2            # 00445adf
    jmp.d8 L_00445b0f                            # 00445ae5
L_00445ae7:
    # block 0x00445ae7: entered by je at 0x00445a8f, 7 instruction(s), falls into the block at 0x00445b0f
    mov word ptr [ebp - local_20], 0x7cd         # 00445ae7
    mov word ptr [ebp - local_1e], 0x0           # 00445aed
    mov word ptr [ebp - local_1c], 0x0           # 00445af3
    mov word ptr [ebp - local_1a], 0x1           # 00445af9
    mov word ptr [ebp - local_c], 0xffff         # 00445aff
    mov byte ptr [ebp - local_a], 0x0            # 00445b05
    mov word ptr [ebp - local_9], 0x2            # 00445b09
L_00445b0f:
    # block 0x00445b0f: entered by jmp at 0x00445a91; jmp at 0x00445abb; jmp at 0x00445ae5, 9 instruction(s), calls FUN_0041fd08, ends with ret
    lea edx, [ebp - local_1d8]                   # 00445b0f
    push edx                                     # 00445b15
    mov ecx, 0x6177e8                            # 00445b16
    call FUN_0041fd08                            # 00445b1b
    pop edi                                      # 00445b20
    pop esi                                      # 00445b21
    {load} mov esp, ebp                          # 00445b22
    pop ebp                                      # 00445b24
    ret                                          # 00445b25

