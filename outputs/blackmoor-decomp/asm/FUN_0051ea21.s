# FUN_0051ea21
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051ea21
# extent:       0x0051ea21-0x0051ea48 (39 code bytes)
# span:         0x0051ea21-0x0051ea48 (code 39, tables 0, padding 0)
# sha256:       b131d94c2670ea6a7c1e996dac80c0a5157f96de308b2a0a6346a50987329957
# evidence:     ev_96f1bc62419512d08d4ff3f4c9af28b1e7ac57401ae5f5f4318134ff6bf21907
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051ea21
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_c
# callees:      calls KERNEL32.dll!lstrlenA, FUN_0051e9c2
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0051e9c2, .text + (0x0051e9c2 - 0x401000)

.org 0x0051ea21 - 0x401000
.globl FUN_0051ea21
FUN_0051ea21:
    # block 0x0051ea21: entry, 6 instruction(s), ends with jne to 0x0051ea31 (forward)
    push esi                                     # 0051ea21
    push edi                                     # 0051ea22
    mov edi, dword ptr [esp + stk_c]             # 0051ea23
    {load} mov esi, ecx                          # 0051ea27
    test edi, edi                                # 0051ea29
    jne.d8 L_0051ea31                            # 0051ea2b
    # block 0x0051ea2d: entered by fall-through of jne at 0x0051ea2b, 2 instruction(s), ends with forward jump to 0x0051ea38
    {load} xor eax, eax                          # 0051ea2d
    jmp.d8 L_0051ea38                            # 0051ea2f
L_0051ea31:
    # block 0x0051ea31: entered by jne at 0x0051ea2b, 2 instruction(s), calls KERNEL32.dll!lstrlenA, falls into the block at 0x0051ea38
    push edi                                     # 0051ea31
    call dword ptr [0x52a1f8]                    # 0051ea32
L_0051ea38:
    # block 0x0051ea38: entered by jmp at 0x0051ea2f, 8 instruction(s), calls FUN_0051e9c2, ends with ret 0x4
    push edi                                     # 0051ea38
    push eax                                     # 0051ea39
    {load} mov ecx, esi                          # 0051ea3a
    call FUN_0051e9c2                            # 0051ea3c
    {load} mov eax, esi                          # 0051ea41
    pop edi                                      # 0051ea43
    pop esi                                      # 0051ea44
    ret 0x4                                      # 0051ea45

