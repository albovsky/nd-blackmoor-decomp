# FUN_0050fdc5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050fdc5
# extent:       0x0050fdc5-0x0050fde2 (29 code bytes)
# span:         0x0050fdc5-0x0050fde2 (code 29, tables 0, padding 0)
# sha256:       66e3418a1b5d16894ce1d41355c902b4edcfab4f1a2d9781a8529990682ce603
# evidence:     ev_3784ce9180aeab8362927bb1029087f7d883b0ec5d34301a09ab54177a07ada3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050fdc5
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_2; [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 13 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_2, 0x2  # offset +0x2
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------

.org 0x0050fdc5 - 0x401000
.globl FUN_0050fdc5
FUN_0050fdc5:
    # block 0x0050fdc5: entry, 4 instruction(s), ends with je to 0x0050fddc (forward)
    mov ecx, dword ptr [esp + stk_4]             # 0050fdc5
    cmp word ptr [ecx], 0x0                      # 0050fdc9
    lea eax, [ecx + field_2]                     # 0050fdcd
    je.d8 L_0050fddc                             # 0050fdd0
L_0050fdd2:
    # block 0x0050fdd2: entered by jne at 0x0050fdda; fall-through of je at 0x0050fdd0, 5 instruction(s), ends with jne to 0x0050fdd2 (backward)
    mov dx, word ptr [eax]                       # 0050fdd2
    inc eax                                      # 0050fdd5
    inc eax                                      # 0050fdd6
    test dx, dx                                  # 0050fdd7
    jne.d8 L_0050fdd2                            # 0050fdda
L_0050fddc:
    # block 0x0050fddc: entered by je at 0x0050fdd0; fall-through of jne at 0x0050fdda, 4 instruction(s), ends with ret
    {load} sub eax, ecx                          # 0050fddc
    sar eax                                      # 0050fdde
    dec eax                                      # 0050fde0
    ret                                          # 0050fde1

