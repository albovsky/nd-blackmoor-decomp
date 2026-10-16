# FUN_0051e2c3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e2c3
# extent:       0x0051e2c3-0x0051e2e7 (36 code bytes)
# span:         0x0051e2c3-0x0051e2e7 (code 36, tables 0, padding 0)
# sha256:       5a80010c6caa5ad67ae58311e590a4ff4100f82f0b07205521a246c8b8b30432
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051e2a0 (+0x23)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e2c3
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edi + n] field_c0; [esp + n] stk_c
# callees:      calls FUN_00520fbf, FUN_0051ab4b; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 14 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_c, 0xc  # offset +0xc
.equ field_c0, 0xc0  # offset +0xc0

# --- external targets -----------------------------------------------
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)
.set FUN_00520fbf, .text + (0x00520fbf - 0x401000)

.org 0x0051e2c3 - 0x401000
.globl FUN_0051e2c3
FUN_0051e2c3:
    # block 0x0051e2c3: entry, 14 instruction(s), calls FUN_00520fbf, indirect dword ptr [edi + 0xc0], FUN_0051ab4b, ends with ret 0x8
    push esi                                     # 0051e2c3
    push edi                                     # 0051e2c4
    push dword ptr [esp + stk_c]                 # 0051e2c5
    {load} mov esi, ecx                          # 0051e2c9
    mov edi, dword ptr [esi]                     # 0051e2cb
    call FUN_00520fbf                            # 0051e2cd
    push eax                                     # 0051e2d2
    {load} mov ecx, esi                          # 0051e2d3
    call dword ptr [edi + field_c0]              # 0051e2d5
    {load} mov ecx, esi                          # 0051e2db
    call FUN_0051ab4b                            # 0051e2dd
    pop edi                                      # 0051e2e2
    pop esi                                      # 0051e2e3
    ret 0x8                                      # 0051e2e4

