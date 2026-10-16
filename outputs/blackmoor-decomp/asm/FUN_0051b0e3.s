# FUN_0051b0e3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051b0e3
# extent:       0x0051b0e3-0x0051b125 (66 code bytes)
# span:         0x0051b0e3-0x0051b125 (code 66, tables 0, padding 0)
# sha256:       6fa77af73fe3c291457ca4c7815079b82ebb8d5a80313e04e3842a26bcca5667
# evidence:     ev_af67c4288d6e639a00bd5dfa5ba373e106c1ca511fa16fda1eb070cac94bb18e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051b0e3
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_14; [esi + n] field_14, field_2c
# callees:      calls FUN_00525b0f, FUN_00525371, USER32.dll!UnhookWindowsHookEx
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 24 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_14, 0x14  # offset +0x14
.equ field_2c, 0x2c  # offset +0x2c

# --- external targets -----------------------------------------------
.set FUN_00525371, .text + (0x00525371 - 0x401000)
.set FUN_00525b0f, .text + (0x00525b0f - 0x401000)

.org 0x0051b0e3 - 0x401000
.globl FUN_0051b0e3
FUN_0051b0e3:
    # block 0x0051b0e3: entry, 8 instruction(s), calls FUN_00525b0f, FUN_00525371, ends with je to 0x0051b112 (forward)
    push esi                                     # 0051b0e3
    push 0x52496c                                # 0051b0e4
    mov ecx, 0x63c444                            # 0051b0e9
    call FUN_00525b0f                            # 0051b0ee
    {load} mov esi, eax                          # 0051b0f3
    call FUN_00525371                            # 0051b0f5
    cmp byte ptr [eax + field_14], 0x0           # 0051b0fa
    je.d8 L_0051b112                             # 0051b0fe
    # block 0x0051b100: entered by fall-through of je at 0x0051b0fe, 3 instruction(s), ends with je to 0x0051b112 (forward)
    mov eax, dword ptr [esi + field_2c]          # 0051b100
    test eax, eax                                # 0051b103
    je.d8 L_0051b112                             # 0051b105
    # block 0x0051b107: entered by fall-through of je at 0x0051b105, 3 instruction(s), calls USER32.dll!UnhookWindowsHookEx, falls into the block at 0x0051b112
    push eax                                     # 0051b107
    call dword ptr [0x52a42c]                    # 0051b108
    and dword ptr [esi + field_2c], 0x0          # 0051b10e
L_0051b112:
    # block 0x0051b112: entered by je at 0x0051b0fe; je at 0x0051b105, 2 instruction(s), ends with je to 0x0051b120 (forward)
    cmp dword ptr [esi + field_14], 0x0          # 0051b112
    je.d8 L_0051b120                             # 0051b116
    # block 0x0051b118: entered by fall-through of je at 0x0051b116, 4 instruction(s), ends with ret
    and dword ptr [esi + field_14], 0x0          # 0051b118
    {load} xor eax, eax                          # 0051b11c
    pop esi                                      # 0051b11e
    ret                                          # 0051b11f
L_0051b120:
    # block 0x0051b120: entered by je at 0x0051b116, 4 instruction(s), ends with ret
    push 0x1                                     # 0051b120
    pop eax                                      # 0051b122
    pop esi                                      # 0051b123
    ret                                          # 0051b124

