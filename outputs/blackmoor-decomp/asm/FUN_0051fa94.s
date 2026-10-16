# FUN_0051fa94
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051fa94
# extent:       0x0051fa94-0x0051faaa (22 code bytes)
# span:         0x0051fa94-0x0051faaa (code 22, tables 0, padding 0)
# sha256:       482b5294549a6e34aefe237aa1ba98e8b2149ae05203ce725184bdecfde0a9b4
# evidence:     ev_48d32b48f2cea7034d614eb024d79a97cc56e9906b5dc4d1688daa691f89583b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051fa94
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_4
# callees:      calls FUN_0051fa6a, USER32.dll!DestroyMenu
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class nn_reviewed is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_0051fa6a, .text + (0x0051fa6a - 0x401000)

.org 0x0051fa94 - 0x401000
.globl FUN_0051fa94
FUN_0051fa94:
    # block 0x0051fa94: entry, 2 instruction(s), ends with jne to 0x0051fa9d (forward)
    cmp dword ptr [ecx + field_4], 0x0           # 0051fa94
    jne.d8 L_0051fa9d                            # 0051fa98
    # block 0x0051fa9a: entered by fall-through of jne at 0x0051fa98, 2 instruction(s), ends with ret
    {load} xor eax, eax                          # 0051fa9a
    ret                                          # 0051fa9c
L_0051fa9d:
    # block 0x0051fa9d: entered by jne at 0x0051fa98, 4 instruction(s), calls FUN_0051fa6a, USER32.dll!DestroyMenu, ends with ret
    call FUN_0051fa6a                            # 0051fa9d
    push eax                                     # 0051faa2
    call dword ptr [0x52a388]                    # 0051faa3
    ret                                          # 0051faa9

