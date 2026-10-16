# FUN_0051f5ab
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051f5ab
# extent:       0x0051f5ab-0x0051f5cb (32 code bytes)
# span:         0x0051f5ab-0x0051f5cb (code 32, tables 0, padding 0)
# sha256:       e08360982a4a974b372479a3db8a8f8226a276bbe8027fd7148fa51921243ff3
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051f5ab
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4, stk_8, stk_c
# callees:      calls FUN_0051f599
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0051f599, .text + (0x0051f599 - 0x401000)

.org 0x0051f5ab - 0x401000
.globl FUN_0051f5ab
FUN_0051f5ab:
    # block 0x0051f5ab: entry, 2 instruction(s), ends with je to 0x0051f5c8 (forward)
    cmp dword ptr [esp + stk_8], 0x0             # 0051f5ab
    je.d8 L_0051f5c8                             # 0051f5b0
    # block 0x0051f5b2: entered by fall-through of je at 0x0051f5b0, 5 instruction(s), calls FUN_0051f599, ends with je to 0x0051f5c8 (forward)
    push dword ptr [esp + stk_4]                 # 0051f5b2
    mov ecx, dword ptr [esp + stk_c]             # 0051f5b6
    call FUN_0051f599                            # 0051f5ba
    test eax, eax                                # 0051f5bf
    je.d8 L_0051f5c8                             # 0051f5c1
    # block 0x0051f5c3: entered by fall-through of je at 0x0051f5c1, 2 instruction(s), ends with ret
    mov eax, dword ptr [esp + stk_8]             # 0051f5c3
    ret                                          # 0051f5c7
L_0051f5c8:
    # block 0x0051f5c8: entered by je at 0x0051f5b0; je at 0x0051f5c1, 2 instruction(s), ends with ret
    {load} xor eax, eax                          # 0051f5c8
    ret                                          # 0051f5ca

