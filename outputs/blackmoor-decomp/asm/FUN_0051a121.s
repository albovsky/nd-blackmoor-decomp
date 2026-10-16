# FUN_0051a121
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a121
# extent:       0x0051a121-0x0051a14e (45 code bytes)
# span:         0x0051a121-0x0051a14e (code 45, tables 0, padding 0)
# sha256:       479ad1b66457c5f22bbce86f3bcc4f067bc6145930edacb49fe04b9fc3f7fa7b
# evidence:     ev_0680edc662884da36b8b0465edad49b6c92edef1a0a3fe66526c018dc441b835
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a121
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_4, field_minus_c, field_minus_10; [ecx + n] field_4
# callees:      calls FUN_0050f978, FUN_0051dc6c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 13 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0051a121 - 0x401000
.globl FUN_0051a121
FUN_0051a121:
    # block 0x0051a121: entry, 13 instruction(s), calls FUN_0050f978, FUN_0051dc6c, ends with ret
    mov eax, 0x529150                            # 0051a121
    call FUN_0050f978                            # 0051a126
    push ecx                                     # 0051a12b
    mov dword ptr [ebp - field_minus_10], ecx    # 0051a12c
    mov dword ptr [ecx], 0x52ff78                # 0051a12f
    push dword ptr [ecx + field_4]               # 0051a135
    and dword ptr [ebp - field_minus_4], 0x0     # 0051a138
    call FUN_0051dc6c                            # 0051a13c
    pop ecx                                      # 0051a141
    mov ecx, dword ptr [ebp - field_minus_c]     # 0051a142
    mov dword ptr fs:[0x0], ecx                  # 0051a145
    leave                                        # 0051a14c
    ret                                          # 0051a14d

