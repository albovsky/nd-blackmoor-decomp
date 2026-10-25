# FUN_00445b26
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00445b26
# extent:       0x00445b26-0x00445c7a (340 code bytes)
# span:         0x00445b26-0x00445c8a (code 340, tables 16, padding 0)
# sha256:       547585bcbafe2f4f0006ce75d28ee66eea6271af7b41bd0c2c3483aec67cc96b
# evidence:     ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m445b26_lifted
# naming:       native port src/original_methods_fl40.c:m445b26_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 6 seeds; oracle 82/82 instructions, 4/4 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       15 ebp-relative slot(s): local_4, local_9, local_a, local_c, local_10, local_14, local_18, local_1a, local_1c, local_1e, local_20, local_42 and 3 more
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050cd50, FUN_0043f210, FUN_0041fd08
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m445b26_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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

.org 0x00445b26 - 0x401000
.globl FUN_00445b26
FUN_00445b26:
    # block 0x00445b26: entry, 8 instruction(s), calls FUN_0050cd50, ends with jns to 0x00445b42 (forward)
    push ebp                                     # 00445b26
    {load} mov ebp, esp                          # 00445b27
    sub esp, 0x1dc                               # 00445b29
    push esi                                     # 00445b2f
    push edi                                     # 00445b30
    call FUN_0050cd50                            # 00445b31
    and eax, 0x80000003                          # 00445b36
    jns.d8 L_00445b42                            # 00445b3b
    # block 0x00445b3d: entered by fall-through of jns at 0x00445b3b, 3 instruction(s), falls into the block at 0x00445b42
    dec eax                                      # 00445b3d
    or eax, -0x4                                 # 00445b3e
    inc eax                                      # 00445b41
L_00445b42:
    # block 0x00445b42: entered by jns at 0x00445b3b, 29 instruction(s), calls FUN_0043f210, ends with ja to 0x00445c63 (forward)
    mov word ptr [ebp - local_4], ax             # 00445b42
    push 0x5481f8                                # 00445b46
    push 0x63a83c                                # 00445b4b
    lea eax, [ebp - local_1d2]                   # 00445b50
    push eax                                     # 00445b56
    call FUN_0043f210                            # 00445b57
    add esp, 0xc                                 # 00445b5c
    mov edi, 0x548200                            # 00445b5f
    lea edx, [ebp - local_42]                    # 00445b64
    or ecx, -0x1                                 # 00445b67
    {load} xor eax, eax                          # 00445b6a
    repne scasb al, byte ptr es:[edi]            # 00445b6c
    not ecx                                      # 00445b6e
    {load} sub edi, ecx                          # 00445b70
    {load} mov esi, edi                          # 00445b72
    {load} mov eax, ecx                          # 00445b74
    {load} mov edi, edx                          # 00445b76
    shr ecx, 0x2                                 # 00445b78
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00445b7b
    {load} mov ecx, eax                          # 00445b7d
    and ecx, 0x3                                 # 00445b7f
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00445b82
    mov dword ptr [ebp - local_18], 0x0          # 00445b84
    mov dword ptr [ebp - local_14], 0x0          # 00445b8b
    mov dword ptr [ebp - local_10], 0x1          # 00445b92
    movsx ecx, word ptr [ebp - local_4]          # 00445b99
    mov dword ptr [ebp - local_1dc], ecx         # 00445b9d
    cmp dword ptr [ebp - local_1dc], 0x3         # 00445ba3
    ja.d32 L_00445c63                            # 00445baa
    # block 0x00445bb0: entered by fall-through of ja at 0x00445baa, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x445c7a]
    mov edx, dword ptr [ebp - local_1dc]         # 00445bb0
    jmp dword ptr [4*edx + SWTAB_00445c7a_VA]    # 00445bb6
L_00445bbd:
    # block 0x00445bbd: entered by switch case, 8 instruction(s), ends with forward jump to 0x00445c63
    mov word ptr [ebp - local_20], 0x6fe         # 00445bbd
    mov word ptr [ebp - local_1e], 0x0           # 00445bc3
    mov word ptr [ebp - local_1c], 0x0           # 00445bc9
    mov word ptr [ebp - local_1a], 0x1           # 00445bcf
    mov word ptr [ebp - local_c], 0xffff         # 00445bd5
    mov byte ptr [ebp - local_a], 0x0            # 00445bdb
    mov word ptr [ebp - local_9], 0x2            # 00445bdf
    jmp.d8 L_00445c63                            # 00445be5
L_00445be7:
    # block 0x00445be7: entered by switch case, 8 instruction(s), ends with forward jump to 0x00445c63
    mov word ptr [ebp - local_20], 0x6ff         # 00445be7
    mov word ptr [ebp - local_1e], 0x0           # 00445bed
    mov word ptr [ebp - local_1c], 0x0           # 00445bf3
    mov word ptr [ebp - local_1a], 0x1           # 00445bf9
    mov word ptr [ebp - local_c], 0xffff         # 00445bff
    mov byte ptr [ebp - local_a], 0x0            # 00445c05
    mov word ptr [ebp - local_9], 0x2            # 00445c09
    jmp.d8 L_00445c63                            # 00445c0f
L_00445c11:
    # block 0x00445c11: entered by switch case, 8 instruction(s), ends with forward jump to 0x00445c63
    mov word ptr [ebp - local_20], 0x700         # 00445c11
    mov word ptr [ebp - local_1e], 0x0           # 00445c17
    mov word ptr [ebp - local_1c], 0x0           # 00445c1d
    mov word ptr [ebp - local_1a], 0x1           # 00445c23
    mov word ptr [ebp - local_c], 0xffff         # 00445c29
    mov byte ptr [ebp - local_a], 0x0            # 00445c2f
    mov word ptr [ebp - local_9], 0x2            # 00445c33
    jmp.d8 L_00445c63                            # 00445c39
L_00445c3b:
    # block 0x00445c3b: entered by switch case, 7 instruction(s), falls into the block at 0x00445c63
    mov word ptr [ebp - local_20], 0x701         # 00445c3b
    mov word ptr [ebp - local_1e], 0x0           # 00445c41
    mov word ptr [ebp - local_1c], 0x0           # 00445c47
    mov word ptr [ebp - local_1a], 0x1           # 00445c4d
    mov word ptr [ebp - local_c], 0xffff         # 00445c53
    mov byte ptr [ebp - local_a], 0x0            # 00445c59
    mov word ptr [ebp - local_9], 0x2            # 00445c5d
L_00445c63:
    # block 0x00445c63: entered by ja at 0x00445baa; jmp at 0x00445be5; jmp at 0x00445c0f; jmp at 0x00445c39, 9 instruction(s), calls FUN_0041fd08, ends with ret
    lea eax, [ebp - local_1d8]                   # 00445c63
    push eax                                     # 00445c69
    mov ecx, 0x6177e8                            # 00445c6a
    call FUN_0041fd08                            # 00445c6f
    pop edi                                      # 00445c74
    pop esi                                      # 00445c75
    {load} mov esp, ebp                          # 00445c76
    pop ebp                                      # 00445c78
    ret                                          # 00445c79

# --- data items (not part of the function) -------------------------
.org 0x00445c7a - 0x401000
SWTAB_00445c7a:  # 4 case address(es)
    .long L_00445bbd - .text + 0x401000
    .long L_00445be7 - .text + 0x401000
    .long L_00445c11 - .text + 0x401000
    .long L_00445c3b - .text + 0x401000
.set SWTAB_00445c7a_VA, SWTAB_00445c7a - .text + 0x401000

