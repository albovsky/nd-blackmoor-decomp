# FUN_005234c3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005234c3
# extent:       0x005234c3-0x005234ec (41 code bytes)
# span:         0x005234c3-0x005234ec (code 41, tables 0, padding 0)
# sha256:       8cf62ab97d8db4f62d871b903a05e22895709cc444deaf3963559e956ea10ef3
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005233c8 (+0xfb)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005234c3
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0xc (callee pops 12 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_8, field_c; [esi + n] field_1c
# callees:      calls FUN_0052398b, FUN_0051ab16, USER32.dll!SendMessageA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 13 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x005234ec
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0051ab16, .text + (0x0051ab16 - 0x401000)
.set FUN_0052398b, .text + (0x0052398b - 0x401000)

.org 0x005234c3 - 0x401000
.globl FUN_005234c3
FUN_005234c3:
    # block 0x005234c3: entry, 5 instruction(s), calls FUN_0052398b, ends with je to 0x005234e8 (forward)
    push esi                                     # 005234c3
    call FUN_0052398b                            # 005234c4
    {load} mov esi, eax                          # 005234c9
    test esi, esi                                # 005234cb
    je.d8 L_005234e8                             # 005234cd
    # block 0x005234cf: entered by fall-through of je at 0x005234cd, 6 instruction(s), calls FUN_0051ab16, USER32.dll!SendMessageA, falls into the block at 0x005234e8
    call FUN_0051ab16                            # 005234cf
    push dword ptr [eax + field_c]               # 005234d4
    push dword ptr [eax + field_8]               # 005234d7
    push 0x114                                   # 005234da
    push dword ptr [esi + field_1c]              # 005234df
    call dword ptr [0x52a4c8]                    # 005234e2
L_005234e8:
    # block 0x005234e8: entered by je at 0x005234cd, 2 instruction(s), ends with ret 0xc
    pop esi                                      # 005234e8
    ret 0xc                                      # 005234e9

