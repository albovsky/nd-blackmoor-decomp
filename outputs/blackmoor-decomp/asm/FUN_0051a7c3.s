# FUN_0051a7c3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a7c3
# extent:       0x0051a7c3-0x0051a7e5 (34 code bytes)
# span:         0x0051a7c3-0x0051a7e5 (code 34, tables 0, padding 0)
# sha256:       0c1777ff54cb7d7092b1133f249fee52d70605020496bc24d63fa020765c09b1
# evidence:     ev_af67c4288d6e639a00bd5dfa5ba373e106c1ca511fa16fda1eb070cac94bb18e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a7c3
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_1c
# callees:      calls FUN_0051d716, FUN_0050f920
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 13 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0050f920, .text + (0x0050f920 - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x0051a7c3 - 0x401000
.globl FUN_0051a7c3
FUN_0051a7c3:
    # block 0x0051a7c3: entry, 13 instruction(s), calls FUN_0051d716, FUN_0050f920, ends with ret
    push esi                                     # 0051a7c3
    {load} mov esi, ecx                          # 0051a7c4
    call FUN_0051d716                            # 0051a7c6
    push 0x20                                    # 0051a7cb
    lea eax, [esi + field_1c]                    # 0051a7cd
    push 0x0                                     # 0051a7d0
    push eax                                     # 0051a7d2
    mov dword ptr [esi], 0x52ea60                # 0051a7d3
    call FUN_0050f920                            # 0051a7d9
    add esp, 0xc                                 # 0051a7de
    {load} mov eax, esi                          # 0051a7e1
    pop esi                                      # 0051a7e3
    ret                                          # 0051a7e4

