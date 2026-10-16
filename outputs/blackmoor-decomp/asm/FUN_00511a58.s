# FUN_00511a58
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00511a58
# extent:       0x00511a58-0x00511a81 (41 code bytes)
# span:         0x00511a58-0x00511a81 (code 41, tables 0, padding 0)
# sha256:       c529f38462516fcac29609d92fd1abd074f8e30ef79c49feade53f52b534f077
# evidence:     ev_c14b206e0317066be1d027bdae31364ff1ffe02c3df6c0ccff4b69686384ad63
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00511a58
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls KERNEL32.dll!GetModuleHandleA, KERNEL32.dll!GetProcAddress, tail jump FUN_00511a1a; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 13 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------
.set FUN_00511a1a, .text + (0x00511a1a - 0x401000)

.org 0x00511a58 - 0x401000
.globl FUN_00511a58
FUN_00511a58:
    # block 0x00511a58: entry, 4 instruction(s), calls KERNEL32.dll!GetModuleHandleA, ends with je to 0x00511a7c (forward)
    push 0x5304dc                                # 00511a58
    call dword ptr [0x52a248]                    # 00511a5d
    test eax, eax                                # 00511a63
    je.d8 L_00511a7c                             # 00511a65
    # block 0x00511a67: entered by fall-through of je at 0x00511a65, 5 instruction(s), calls KERNEL32.dll!GetProcAddress, ends with je to 0x00511a7c (forward)
    push 0x5304c0                                # 00511a67
    push eax                                     # 00511a6c
    call dword ptr [0x52a24c]                    # 00511a6d
    test eax, eax                                # 00511a73
    je.d8 L_00511a7c                             # 00511a75
    # block 0x00511a77: entered by fall-through of je at 0x00511a75, 3 instruction(s), calls indirect eax, ends with ret
    push 0x0                                     # 00511a77
    call eax                                     # 00511a79
    ret                                          # 00511a7b
L_00511a7c:
    # block 0x00511a7c: entered by je at 0x00511a65; je at 0x00511a75, 1 instruction(s), ends with backward jump to 0x00511a1a
    jmp.d32 FUN_00511a1a                         # 00511a7c

