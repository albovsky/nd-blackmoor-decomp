# FUN_00522113
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00522113
# extent:       0x00522113-0x00522135 (34 code bytes)
# span:         0x00522113-0x00522135 (code 34, tables 0, padding 0)
# sha256:       6aee69bb02da489eabc0b1dcb31590452ca14b90288ab967cda313cb9159a53c
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00522113
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_1c
# callees:      calls FUN_0051cfd1, USER32.dll!SendMessageA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 14 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0051cfd1, .text + (0x0051cfd1 - 0x401000)

.org 0x00522113 - 0x401000
.globl FUN_00522113
FUN_00522113:
    # block 0x00522113: entry, 5 instruction(s), calls FUN_0051cfd1, ends with jne to 0x00522121 (forward)
    push esi                                     # 00522113
    {load} mov esi, ecx                          # 00522114
    call FUN_0051cfd1                            # 00522116
    test eax, eax                                # 0052211b
    jne.d8 L_00522121                            # 0052211d
    # block 0x0052211f: entered by fall-through of jne at 0x0052211d, 2 instruction(s), ends with ret
    pop esi                                      # 0052211f
    ret                                          # 00522120
L_00522121:
    # block 0x00522121: entered by jne at 0x0052211d, 7 instruction(s), calls USER32.dll!SendMessageA, ends with ret
    push 0x0                                     # 00522121
    push 0x0                                     # 00522123
    push 0x476                                   # 00522125
    push dword ptr [esi + field_1c]              # 0052212a
    call dword ptr [0x52a4c8]                    # 0052212d
    pop esi                                      # 00522133
    ret                                          # 00522134

