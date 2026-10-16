# FUN_00524826
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00524826
# extent:       0x00524826-0x00524837 (17 code bytes)
# span:         0x00524826-0x00524837 (code 17, tables 0, padding 0)
# sha256:       1fd06750fbc8db6974141ad1a7018fa0219dedc2a068c407e1a128258f28caf9
# evidence:     ev_869646559a3727888977dc07c194c56c529a01288a7f405514bc186a4be3ebc5
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00524826
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_6c
# callees:      calls FUN_0051c0c9
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_6c, 0x6c  # offset +0x6c

# --- external targets -----------------------------------------------
.set FUN_0051c0c9, .text + (0x0051c0c9 - 0x401000)

.org 0x00524826 - 0x401000
.globl FUN_00524826
FUN_00524826:
    # block 0x00524826: entry, 5 instruction(s), calls FUN_0051c0c9, ends with jne to 0x00524835 (forward)
    push esi                                     # 00524826
    {load} mov esi, ecx                          # 00524827
    call FUN_0051c0c9                            # 00524829
    test eax, eax                                # 0052482e
    jne.d8 L_00524835                            # 00524830
    # block 0x00524832: entered by fall-through of jne at 0x00524830, 1 instruction(s), falls into the block at 0x00524835
    mov eax, dword ptr [esi + field_6c]          # 00524832
L_00524835:
    # block 0x00524835: entered by jne at 0x00524830, 2 instruction(s), ends with ret
    pop esi                                      # 00524835
    ret                                          # 00524836

