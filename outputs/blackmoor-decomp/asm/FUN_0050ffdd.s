# FUN_0050ffdd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050ffdd
# extent:       0x0050ffdd-0x0050fff4 (23 code bytes)
# span:         0x0050ffdd-0x0050fff4 (code 23, tables 0, padding 0)
# sha256:       c1c09e3e0cc8763644dd61f7893a74ca778b467bc37d854ba7251ad1f2eb4ec2
# evidence:     ev_3784ce9180aeab8362927bb1029087f7d883b0ec5d34301a09ab54177a07ada3
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050ffdd
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------

.org 0x0050ffdd - 0x401000
.globl FUN_0050ffdd
FUN_0050ffdd:
    # block 0x0050ffdd: entry, 7 instruction(s), ends with je to 0x0050fff3 (forward)
    mov eax, dword ptr [esp + stk_4]             # 0050ffdd
    movzx ecx, byte ptr [eax]                    # 0050ffe1
    mov cl, byte ptr [ecx + 0x63e021]            # 0050ffe4
    and cl, 0x4                                  # 0050ffea
    inc eax                                      # 0050ffed
    test cl, cl                                  # 0050ffee
    je.d8 L_0050fff3                             # 0050fff0
    # block 0x0050fff2: entered by fall-through of je at 0x0050fff0, 1 instruction(s), falls into the block at 0x0050fff3
    inc eax                                      # 0050fff2
L_0050fff3:
    # block 0x0050fff3: entered by je at 0x0050fff0, 1 instruction(s), ends with ret
    ret                                          # 0050fff3

