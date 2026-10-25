# FUN_00445c8a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00445c8a
# extent:       0x00445c8a-0x00445dde (340 code bytes)
# span:         0x00445c8a-0x00445df0 (code 340, tables 16, padding 2)
# sha256:       226561d8975632f09ea454c2d2effab66ed1987af6695b97ab93283f7d32ae40
# evidence:     ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m445c8a_lifted
# naming:       native port src/original_methods_fl40.c:m445c8a_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 6 seeds; oracle 82/82 instructions, 4/4 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       15 ebp-relative slot(s): local_4, local_9, local_a, local_c, local_10, local_14, local_18, local_1a, local_1c, local_1e, local_20, local_42 and 3 more
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050cd50, FUN_0043f210, FUN_0041fd08
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m445c8a_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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

.org 0x00445c8a - 0x401000
.globl FUN_00445c8a
FUN_00445c8a:
    # block 0x00445c8a: entry, 8 instruction(s), calls FUN_0050cd50, ends with jns to 0x00445ca6 (forward)
    push ebp                                     # 00445c8a
    {load} mov ebp, esp                          # 00445c8b
    sub esp, 0x1dc                               # 00445c8d
    push esi                                     # 00445c93
    push edi                                     # 00445c94
    call FUN_0050cd50                            # 00445c95
    and eax, 0x80000003                          # 00445c9a
    jns.d8 L_00445ca6                            # 00445c9f
    # block 0x00445ca1: entered by fall-through of jns at 0x00445c9f, 3 instruction(s), falls into the block at 0x00445ca6
    dec eax                                      # 00445ca1
    or eax, -0x4                                 # 00445ca2
    inc eax                                      # 00445ca5
L_00445ca6:
    # block 0x00445ca6: entered by jns at 0x00445c9f, 29 instruction(s), calls FUN_0043f210, ends with ja to 0x00445dc7 (forward)
    mov word ptr [ebp - local_4], ax             # 00445ca6
    push 0x548208                                # 00445caa
    push 0x63a840                                # 00445caf
    lea eax, [ebp - local_1d2]                   # 00445cb4
    push eax                                     # 00445cba
    call FUN_0043f210                            # 00445cbb
    add esp, 0xc                                 # 00445cc0
    mov edi, 0x548210                            # 00445cc3
    lea edx, [ebp - local_42]                    # 00445cc8
    or ecx, -0x1                                 # 00445ccb
    {load} xor eax, eax                          # 00445cce
    repne scasb al, byte ptr es:[edi]            # 00445cd0
    not ecx                                      # 00445cd2
    {load} sub edi, ecx                          # 00445cd4
    {load} mov esi, edi                          # 00445cd6
    {load} mov eax, ecx                          # 00445cd8
    {load} mov edi, edx                          # 00445cda
    shr ecx, 0x2                                 # 00445cdc
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00445cdf
    {load} mov ecx, eax                          # 00445ce1
    and ecx, 0x3                                 # 00445ce3
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00445ce6
    mov dword ptr [ebp - local_18], 0x0          # 00445ce8
    mov dword ptr [ebp - local_14], 0x0          # 00445cef
    mov dword ptr [ebp - local_10], 0x1          # 00445cf6
    movsx ecx, word ptr [ebp - local_4]          # 00445cfd
    mov dword ptr [ebp - local_1dc], ecx         # 00445d01
    cmp dword ptr [ebp - local_1dc], 0x3         # 00445d07
    ja.d32 L_00445dc7                            # 00445d0e
    # block 0x00445d14: entered by fall-through of ja at 0x00445d0e, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x445dde]
    mov edx, dword ptr [ebp - local_1dc]         # 00445d14
    jmp dword ptr [4*edx + SWTAB_00445dde_VA]    # 00445d1a
L_00445d21:
    # block 0x00445d21: entered by switch case, 8 instruction(s), ends with forward jump to 0x00445dc7
    mov word ptr [ebp - local_20], 0x762         # 00445d21
    mov word ptr [ebp - local_1e], 0x0           # 00445d27
    mov word ptr [ebp - local_1c], 0x0           # 00445d2d
    mov word ptr [ebp - local_1a], 0x1           # 00445d33
    mov word ptr [ebp - local_c], 0xffff         # 00445d39
    mov byte ptr [ebp - local_a], 0x0            # 00445d3f
    mov word ptr [ebp - local_9], 0x2            # 00445d43
    jmp.d8 L_00445dc7                            # 00445d49
L_00445d4b:
    # block 0x00445d4b: entered by switch case, 8 instruction(s), ends with forward jump to 0x00445dc7
    mov word ptr [ebp - local_20], 0x763         # 00445d4b
    mov word ptr [ebp - local_1e], 0x0           # 00445d51
    mov word ptr [ebp - local_1c], 0x0           # 00445d57
    mov word ptr [ebp - local_1a], 0x1           # 00445d5d
    mov word ptr [ebp - local_c], 0xffff         # 00445d63
    mov byte ptr [ebp - local_a], 0x0            # 00445d69
    mov word ptr [ebp - local_9], 0x2            # 00445d6d
    jmp.d8 L_00445dc7                            # 00445d73
L_00445d75:
    # block 0x00445d75: entered by switch case, 8 instruction(s), ends with forward jump to 0x00445dc7
    mov word ptr [ebp - local_20], 0x764         # 00445d75
    mov word ptr [ebp - local_1e], 0x0           # 00445d7b
    mov word ptr [ebp - local_1c], 0x0           # 00445d81
    mov word ptr [ebp - local_1a], 0x1           # 00445d87
    mov word ptr [ebp - local_c], 0xffff         # 00445d8d
    mov byte ptr [ebp - local_a], 0x0            # 00445d93
    mov word ptr [ebp - local_9], 0x2            # 00445d97
    jmp.d8 L_00445dc7                            # 00445d9d
L_00445d9f:
    # block 0x00445d9f: entered by switch case, 7 instruction(s), falls into the block at 0x00445dc7
    mov word ptr [ebp - local_20], 0x765         # 00445d9f
    mov word ptr [ebp - local_1e], 0x0           # 00445da5
    mov word ptr [ebp - local_1c], 0x0           # 00445dab
    mov word ptr [ebp - local_1a], 0x1           # 00445db1
    mov word ptr [ebp - local_c], 0xffff         # 00445db7
    mov byte ptr [ebp - local_a], 0x0            # 00445dbd
    mov word ptr [ebp - local_9], 0x2            # 00445dc1
L_00445dc7:
    # block 0x00445dc7: entered by ja at 0x00445d0e; jmp at 0x00445d49; jmp at 0x00445d73; jmp at 0x00445d9d, 9 instruction(s), calls FUN_0041fd08, ends with ret
    lea eax, [ebp - local_1d8]                   # 00445dc7
    push eax                                     # 00445dcd
    mov ecx, 0x6177e8                            # 00445dce
    call FUN_0041fd08                            # 00445dd3
    pop edi                                      # 00445dd8
    pop esi                                      # 00445dd9
    {load} mov esp, ebp                          # 00445dda
    pop ebp                                      # 00445ddc
    ret                                          # 00445ddd

# --- data items (not part of the function) -------------------------
.org 0x00445dde - 0x401000
SWTAB_00445dde:  # 4 case address(es)
    .long L_00445d21 - .text + 0x401000
    .long L_00445d4b - .text + 0x401000
    .long L_00445d75 - .text + 0x401000
    .long L_00445d9f - .text + 0x401000
.org 0x00445dee - 0x401000
PAD_00445dee:  # 2 byte(s) of int3 padding
    .fill 2, 1, 0xcc
.set SWTAB_00445dde_VA, SWTAB_00445dde - .text + 0x401000

