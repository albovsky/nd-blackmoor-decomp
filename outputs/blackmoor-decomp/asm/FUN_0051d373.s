# FUN_0051d373
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051d373
# extent:       0x0051d373-0x0051d392 (31 code bytes)
# span:         0x0051d373-0x0051d392 (code 31, tables 0, padding 0)
# sha256:       f29a138fe18539a4627a43ae4aabe0a97ba089dad7958b4e9536522b4ed69043
# evidence:     ev_660f113b4cd6f4812ca4e37feb1ec9db247cedee282c56d4fe5eb89c030f3859
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051d373
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_90
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 12 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_90, 0x90  # offset +0x90

# --- external targets -----------------------------------------------

.org 0x0051d373 - 0x401000
.globl FUN_0051d373
FUN_0051d373:
    # block 0x0051d373: entry, 3 instruction(s), ends with je to 0x0051d38f (forward)
    mov eax, dword ptr [ecx + field_90]          # 0051d373
    test eax, eax                                # 0051d379
    je.d8 L_0051d38f                             # 0051d37b
    # block 0x0051d37d: entered by fall-through of je at 0x0051d37b, 2 instruction(s), ends with je to 0x0051d38f (forward)
    cmp eax, 0xe002                              # 0051d37d
    je.d8 L_0051d38f                             # 0051d382
    # block 0x0051d384: entered by fall-through of je at 0x0051d382, 2 instruction(s), ends with je to 0x0051d38f (forward)
    cmp eax, 0xe001                              # 0051d384
    je.d8 L_0051d38f                             # 0051d389
    # block 0x0051d38b: entered by fall-through of je at 0x0051d389, 3 instruction(s), ends with ret
    push 0x1                                     # 0051d38b
    pop eax                                      # 0051d38d
    ret                                          # 0051d38e
L_0051d38f:
    # block 0x0051d38f: entered by je at 0x0051d37b; je at 0x0051d382; je at 0x0051d389, 2 instruction(s), ends with ret
    {load} xor eax, eax                          # 0051d38f
    ret                                          # 0051d391

