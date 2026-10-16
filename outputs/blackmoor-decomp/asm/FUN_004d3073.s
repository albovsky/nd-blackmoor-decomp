# FUN_004d3073
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d3073
# extent:       0x004d3073-0x004d3127 (180 code bytes)
# span:         0x004d3073-0x004d3137 (code 180, tables 16, padding 0)
# sha256:       bb3a12f58cb8b588771211f75e730ff6698b591c52798170118434f886162761
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d3073
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004db38a, FUN_004e8d72, FUN_004f0059, FUN_004e075a, FUN_004de322, FUN_004e77b8, FUN_004e89eb, FUN_004ebd85, FUN_004e412d
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 44 instruction(s), 2 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004db38a, .text + (0x004db38a - 0x401000)
.set FUN_004de322, .text + (0x004de322 - 0x401000)
.set FUN_004e075a, .text + (0x004e075a - 0x401000)
.set FUN_004e412d, .text + (0x004e412d - 0x401000)
.set FUN_004e77b8, .text + (0x004e77b8 - 0x401000)
.set FUN_004e89eb, .text + (0x004e89eb - 0x401000)
.set FUN_004e8d72, .text + (0x004e8d72 - 0x401000)
.set FUN_004ebd85, .text + (0x004ebd85 - 0x401000)
.set FUN_004f0059, .text + (0x004f0059 - 0x401000)

.org 0x004d3073 - 0x401000
.globl FUN_004d3073
FUN_004d3073:
    # block 0x004d3073: entry, 17 instruction(s), calls FUN_004db38a, FUN_004e8d72, ends with ja to 0x004d30ca (forward)
    push ebp                                     # 004d3073
    {load} mov ebp, esp                          # 004d3074
    push ecx                                     # 004d3076
    mov ecx, 0x5830ce                            # 004d3077
    call FUN_004db38a                            # 004d307c
    mov dword ptr [0x5a4c18], 0x0                # 004d3081
    mov dword ptr [0x5c39e5], 0xffffffff         # 004d308b
    mov ecx, 0x571442                            # 004d3095
    call FUN_004e8d72                            # 004d309a
    mov dword ptr [0x5b44f8], 0x0                # 004d309f
    mov eax, dword ptr [0x583204]                # 004d30a9
    mov dword ptr [ebp - local_4], eax           # 004d30ae
    mov ecx, dword ptr [ebp - local_4]           # 004d30b1
    sub ecx, 0x2                                 # 004d30b4
    mov dword ptr [ebp - local_4], ecx           # 004d30b7
    cmp dword ptr [ebp - local_4], 0x3           # 004d30ba
    ja.d8 L_004d30ca                             # 004d30be
    # block 0x004d30c0: entered by fall-through of ja at 0x004d30be, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x4d3127]
    mov edx, dword ptr [ebp - local_4]           # 004d30c0
    jmp dword ptr [4*edx + SWTAB_004d3127_VA]    # 004d30c3
L_004d30ca:
    # block 0x004d30ca: entered by ja at 0x004d30be, 8 instruction(s), calls FUN_004f0059, FUN_004e075a, ends with je to 0x004d30f3 (forward)
    mov ecx, 0x583182                            # 004d30ca
    call FUN_004f0059                            # 004d30cf
    mov ecx, 0x570508                            # 004d30d4
    call FUN_004e075a                            # 004d30d9
    {load} xor eax, eax                          # 004d30de
    mov al, byte ptr [0x5a161f]                  # 004d30e0
    test eax, eax                                # 004d30e5
    je.d8 L_004d30f3                             # 004d30e7
    # block 0x004d30e9: entered by fall-through of je at 0x004d30e7, 2 instruction(s), calls FUN_004de322, falls into the block at 0x004d30f3
    mov ecx, 0x61f864                            # 004d30e9
    call FUN_004de322                            # 004d30ee
L_004d30f3:
    # block 0x004d30f3: entered by je at 0x004d30e7, 1 instruction(s), ends with forward jump to 0x004d3123
    jmp.d8 L_004d3123                            # 004d30f3
L_004d30f5:
    # block 0x004d30f5: entered by switch case, 3 instruction(s), calls FUN_004e77b8, ends with forward jump to 0x004d3123
    mov ecx, 0x582711                            # 004d30f5
    call FUN_004e77b8                            # 004d30fa
    jmp.d8 L_004d3123                            # 004d30ff
L_004d3101:
    # block 0x004d3101: entered by switch case, 3 instruction(s), calls FUN_004e89eb, ends with forward jump to 0x004d3123
    mov ecx, 0x571442                            # 004d3101
    call FUN_004e89eb                            # 004d3106
    jmp.d8 L_004d3123                            # 004d310b
L_004d310d:
    # block 0x004d310d: entered by switch case, 3 instruction(s), calls FUN_004ebd85, ends with forward jump to 0x004d3123
    mov ecx, 0x57fd34                            # 004d310d
    call FUN_004ebd85                            # 004d3112
    jmp.d8 L_004d3123                            # 004d3117
L_004d3119:
    # block 0x004d3119: entered by switch case, 2 instruction(s), calls FUN_004e412d, falls into the block at 0x004d3123
    mov ecx, 0x57975c                            # 004d3119
    call FUN_004e412d                            # 004d311e
L_004d3123:
    # block 0x004d3123: entered by jmp at 0x004d30f3; jmp at 0x004d30ff; jmp at 0x004d310b; jmp at 0x004d3117, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004d3123
    pop ebp                                      # 004d3125
    ret                                          # 004d3126

# --- data items (not part of the function) -------------------------
.org 0x004d3127 - 0x401000
SWTAB_004d3127:  # 4 case address(es)
    .long L_004d30f5 - .text + 0x401000
    .long L_004d3101 - .text + 0x401000
    .long L_004d310d - .text + 0x401000
    .long L_004d3119 - .text + 0x401000
.set SWTAB_004d3127_VA, SWTAB_004d3127 - .text + 0x401000

