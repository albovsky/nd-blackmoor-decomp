# FUN_00518bd5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00518bd5
# extent:       0x00518bd5-0x00518bf6 (33 code bytes)
# span:         0x00518bd5-0x00518bf6 (code 33, tables 0, padding 0)
# sha256:       eed5524e9b2c24dc67b92bb6fa071dd5ff8931b59f8fb61d02cdf65e5447ef1a
# evidence:     ev_b751a5094d1e8211f653554618c4b14e01ac05861f47e521c34e1b18a0e9f8e5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00518bd5
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4, stk_c, stk_10
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 15 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ stk_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------

.org 0x00518bd5 - 0x401000
.globl FUN_00518bd5
FUN_00518bd5:
    # block 0x00518bd5: entry, 7 instruction(s), ends with jb to 0x00518beb (forward)
    mov edx, dword ptr [esp + stk_4]             # 00518bd5
    push esi                                     # 00518bd9
    mov esi, dword ptr [esp + stk_c]             # 00518bda
    {load} xor eax, eax                          # 00518bde
    lea ecx, [edx + esi]                         # 00518be0
    {load} cmp ecx, edx                          # 00518be3
    jb.d8 L_00518beb                             # 00518be5
    # block 0x00518be7: entered by fall-through of jb at 0x00518be5, 2 instruction(s), ends with jae to 0x00518bee (forward)
    {load} cmp ecx, esi                          # 00518be7
    jae.d8 L_00518bee                            # 00518be9
L_00518beb:
    # block 0x00518beb: entered by jb at 0x00518be5; fall-through of jae at 0x00518be9, 2 instruction(s), falls into the block at 0x00518bee
    push 0x1                                     # 00518beb
    pop eax                                      # 00518bed
L_00518bee:
    # block 0x00518bee: entered by jae at 0x00518be9, 4 instruction(s), ends with ret
    mov edx, dword ptr [esp + stk_10]            # 00518bee
    pop esi                                      # 00518bf2
    mov dword ptr [edx], ecx                     # 00518bf3
    ret                                          # 00518bf5

