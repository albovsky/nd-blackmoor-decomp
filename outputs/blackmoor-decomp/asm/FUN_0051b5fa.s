# FUN_0051b5fa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051b5fa
# extent:       0x0051b5fa-0x0051b61a (32 code bytes)
# span:         0x0051b5fa-0x0051b61a (code 32, tables 0, padding 0)
# sha256:       6b3f8a69dbf0a1929595ba694460a61bb5d28b54ab8384d3b8fc2bf83cbd977a
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051b5d0 (+0x2a)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051b5fa
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_c; [esp + n] stk_8
# callees:      calls FUN_0051c519, FUN_0051ab4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 12 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)
.set FUN_0051c519, .text + (0x0051c519 - 0x401000)

.org 0x0051b5fa - 0x401000
.globl FUN_0051b5fa
FUN_0051b5fa:
    # block 0x0051b5fa: entry, 8 instruction(s), calls FUN_0051c519, ends with jne to 0x0051b616 (forward)
    mov eax, dword ptr [esp + stk_8]             # 0051b5fa
    push esi                                     # 0051b5fe
    push 0x0                                     # 0051b5ff
    {load} mov esi, ecx                          # 0051b601
    push dword ptr [eax + field_c]               # 0051b603
    call FUN_0051c519                            # 0051b606
    test eax, eax                                # 0051b60b
    jne.d8 L_0051b616                            # 0051b60d
    # block 0x0051b60f: entered by fall-through of jne at 0x0051b60d, 2 instruction(s), calls FUN_0051ab4b, falls into the block at 0x0051b616
    {load} mov ecx, esi                          # 0051b60f
    call FUN_0051ab4b                            # 0051b611
L_0051b616:
    # block 0x0051b616: entered by jne at 0x0051b60d, 2 instruction(s), ends with ret 0x8
    pop esi                                      # 0051b616
    ret 0x8                                      # 0051b617

