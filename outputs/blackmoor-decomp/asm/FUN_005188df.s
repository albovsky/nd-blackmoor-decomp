# FUN_005188df
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005188df
# extent:       0x005188df-0x00518910 (49 code bytes)
# span:         0x005188df-0x00518910 (code 49, tables 0, padding 0)
# sha256:       83ae0317af62f4bcb6beb7353096fc1925d1cc18ab14cc61b9e36975bdef9a35
# evidence:     ev_b751a5094d1e8211f653554618c4b14e01ac05861f47e521c34e1b18a0e9f8e5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005188df
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4, stk_8, stk_c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 16 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------

.org 0x005188df - 0x401000
.globl FUN_005188df
FUN_005188df:
    # block 0x005188df: entry, 4 instruction(s), ends with jne to 0x0051890c (forward)
    movzx eax, byte ptr [esp + stk_4]            # 005188df
    mov cl, byte ptr [esp + stk_c]               # 005188e4
    test byte ptr [eax + 0x63e021], cl           # 005188e8
    jne.d8 L_0051890c                            # 005188ee
    # block 0x005188f0: entered by fall-through of jne at 0x005188ee, 2 instruction(s), ends with je to 0x00518905 (forward)
    cmp dword ptr [esp + stk_8], 0x0             # 005188f0
    je.d8 L_00518905                             # 005188f5
    # block 0x005188f7: entered by fall-through of je at 0x005188f5, 3 instruction(s), ends with forward jump to 0x00518907
    movzx eax, word ptr [2*eax + 0x56820a]       # 005188f7
    and eax, dword ptr [esp + stk_8]             # 005188ff
    jmp.d8 L_00518907                            # 00518903
L_00518905:
    # block 0x00518905: entered by je at 0x005188f5, 1 instruction(s), falls into the block at 0x00518907
    {load} xor eax, eax                          # 00518905
L_00518907:
    # block 0x00518907: entered by jmp at 0x00518903, 2 instruction(s), ends with jne to 0x0051890c (forward)
    test eax, eax                                # 00518907
    jne.d8 L_0051890c                            # 00518909
    # block 0x0051890b: entered by fall-through of jne at 0x00518909, 1 instruction(s), ends with ret
    ret                                          # 0051890b
L_0051890c:
    # block 0x0051890c: entered by jne at 0x005188ee; jne at 0x00518909, 3 instruction(s), ends with ret
    push 0x1                                     # 0051890c
    pop eax                                      # 0051890e
    ret                                          # 0051890f

