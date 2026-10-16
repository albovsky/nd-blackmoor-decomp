# FUN_00521de7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00521de7
# extent:       0x00521de7-0x00521e07 (32 code bytes)
# span:         0x00521de7-0x00521e07 (code 32, tables 0, padding 0)
# sha256:       ee34157deb54b694eb167d53143a37a6dd7032449fdb5d4b5e4b0af70db67a0b
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00521de7
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_3c
# callees:      calls FUN_0051f5ab
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 15 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x00521e07
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_3c, 0x3c  # offset +0x3c

# --- external targets -----------------------------------------------
.set FUN_0051f5ab, .text + (0x0051f5ab - 0x401000)

.org 0x00521de7 - 0x401000
.globl FUN_00521de7
FUN_00521de7:
    # block 0x00521de7: entry, 9 instruction(s), calls FUN_0051f5ab, ends with je to 0x00521e02 (forward)
    push esi                                     # 00521de7
    {load} mov esi, ecx                          # 00521de8
    push esi                                     # 00521dea
    push 0x52ee28                                # 00521deb
    call FUN_0051f5ab                            # 00521df0
    pop ecx                                      # 00521df5
    test eax, eax                                # 00521df6
    pop ecx                                      # 00521df8
    je.d8 L_00521e02                             # 00521df9
    # block 0x00521dfb: entered by fall-through of je at 0x00521df9, 3 instruction(s), ends with ret
    add eax, 0x88                                # 00521dfb
    pop esi                                      # 00521e00
    ret                                          # 00521e01
L_00521e02:
    # block 0x00521e02: entered by je at 0x00521df9, 3 instruction(s), ends with ret
    lea eax, [esi + field_3c]                    # 00521e02
    pop esi                                      # 00521e05
    ret                                          # 00521e06

