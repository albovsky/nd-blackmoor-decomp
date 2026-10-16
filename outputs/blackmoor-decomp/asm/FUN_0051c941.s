# FUN_0051c941
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051c941
# extent:       0x0051c941-0x0051c962 (33 code bytes)
# span:         0x0051c941-0x0051c962 (code 33, tables 0, padding 0)
# sha256:       b72c63d4b6e424b482e350561513b265ee4dbf5f2e248b9486bb51eaa602be77
# evidence:     ev_660f113b4cd6f4812ca4e37feb1ec9db247cedee282c56d4fe5eb89c030f3859
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051c941
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_10
# callees:      calls FUN_0051c4ec, FUN_0051ab4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 13 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)
.set FUN_0051c4ec, .text + (0x0051c4ec - 0x401000)

.org 0x0051c941 - 0x401000
.globl FUN_0051c941
FUN_0051c941:
    # block 0x0051c941: entry, 5 instruction(s), ends with je to 0x0051c957 (forward)
    push esi                                     # 0051c941
    {load} mov esi, ecx                          # 0051c942
    mov ecx, dword ptr [esp + stk_10]            # 0051c944
    test ecx, ecx                                # 0051c948
    je.d8 L_0051c957                             # 0051c94a
    # block 0x0051c94c: entered by fall-through of je at 0x0051c94a, 4 instruction(s), calls FUN_0051c4ec, ends with jne to 0x0051c95e (forward)
    push 0x0                                     # 0051c94c
    call FUN_0051c4ec                            # 0051c94e
    test eax, eax                                # 0051c953
    jne.d8 L_0051c95e                            # 0051c955
L_0051c957:
    # block 0x0051c957: entered by je at 0x0051c94a; fall-through of jne at 0x0051c955, 2 instruction(s), calls FUN_0051ab4b, falls into the block at 0x0051c95e
    {load} mov ecx, esi                          # 0051c957
    call FUN_0051ab4b                            # 0051c959
L_0051c95e:
    # block 0x0051c95e: entered by jne at 0x0051c955, 2 instruction(s), ends with ret 0xc
    pop esi                                      # 0051c95e
    ret 0xc                                      # 0051c95f

