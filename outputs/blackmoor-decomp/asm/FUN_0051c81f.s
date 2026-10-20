# FUN_0051c81f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051c81f
# extent:       0x0051c81f-0x0051c86a (75 code bytes)
# span:         0x0051c81f-0x0051c86a (code 75, tables 0, padding 0)
# sha256:       309c92e6314d9f3cfd299129a6f4995aa488491a07409f5fde33a4ecbf904301
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         OnDevModeChange
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_8, field_c, field_1c; [esi + n] field_1c; [esp + n] stk_8
# callees:      calls FUN_00525371, FUN_0051f4ec, FUN_0051d526, FUN_0051ab16, FUN_0051c22e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 25 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0051ab16, .text + (0x0051ab16 - 0x401000)
.set FUN_0051c22e, .text + (0x0051c22e - 0x401000)
.set FUN_0051d526, .text + (0x0051d526 - 0x401000)
.set FUN_0051f4ec, .text + (0x0051f4ec - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x0051c81f - 0x401000
.globl FUN_0051c81f
FUN_0051c81f:
    # block 0x0051c81f: entry, 6 instruction(s), calls FUN_00525371, ends with je to 0x0051c83e (forward)
    push esi                                     # 0051c81f
    {load} mov esi, ecx                          # 0051c820
    call FUN_00525371                            # 0051c822
    mov eax, dword ptr [eax + field_4]           # 0051c827
    test eax, eax                                # 0051c82a
    je.d8 L_0051c83e                             # 0051c82c
    # block 0x0051c82e: entered by fall-through of je at 0x0051c82c, 2 instruction(s), ends with jne to 0x0051c83e (forward)
    cmp dword ptr [eax + field_1c], esi          # 0051c82e
    jne.d8 L_0051c83e                            # 0051c831
    # block 0x0051c833: entered by fall-through of jne at 0x0051c831, 3 instruction(s), calls FUN_0051f4ec, falls into the block at 0x0051c83e
    push dword ptr [esp + stk_8]                 # 0051c833
    {load} mov ecx, eax                          # 0051c837
    call FUN_0051f4ec                            # 0051c839
L_0051c83e:
    # block 0x0051c83e: entered by je at 0x0051c82c; jne at 0x0051c831, 4 instruction(s), calls FUN_0051d526, ends with jne to 0x0051c866 (forward)
    {load} mov ecx, esi                          # 0051c83e
    call FUN_0051d526                            # 0051c840
    test eax, 0x40000000                         # 0051c845
    jne.d8 L_0051c866                            # 0051c84a
    # block 0x0051c84c: entered by fall-through of jne at 0x0051c84a, 8 instruction(s), calls FUN_0051ab16, FUN_0051c22e, falls into the block at 0x0051c866
    call FUN_0051ab16                            # 0051c84c
    push 0x1                                     # 0051c851
    push 0x1                                     # 0051c853
    push dword ptr [eax + field_c]               # 0051c855
    push dword ptr [eax + field_8]               # 0051c858
    push dword ptr [eax + field_4]               # 0051c85b
    push dword ptr [esi + field_1c]              # 0051c85e
    call FUN_0051c22e                            # 0051c861
L_0051c866:
    # block 0x0051c866: entered by jne at 0x0051c84a, 2 instruction(s), ends with ret 0x4
    pop esi                                      # 0051c866
    ret 0x4                                      # 0051c867

