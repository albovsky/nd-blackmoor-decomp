# FUN_00505580
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00505580
# extent:       0x00505580-0x005055bb (59 code bytes)
# span:         0x00505580-0x005055c0 (code 59, tables 0, padding 5)
# sha256:       0743abf2f2efc69658a247ae6e489437d37450ecf0ca01a10040bf54a8b4fed1
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00505580
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_4, field_8, field_c, field_10; [esp + n] stk_8
# callees:      calls FUN_0050e936
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 24 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)

.org 0x00505580 - 0x401000
.globl FUN_00505580
FUN_00505580:
    # block 0x00505580: entry, 4 instruction(s), ends with je to 0x005055b9 (forward)
    push esi                                     # 00505580
    mov esi, dword ptr [esp + stk_8]             # 00505581
    test esi, esi                                # 00505585
    je.d8 L_005055b9                             # 00505587
    # block 0x00505589: entered by fall-through of je at 0x00505587, 3 instruction(s), ends with je to 0x00505599 (forward)
    mov eax, dword ptr [esi + field_8]           # 00505589
    test eax, eax                                # 0050558c
    je.d8 L_00505599                             # 0050558e
    # block 0x00505590: entered by fall-through of je at 0x0050558e, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x00505599
    push eax                                     # 00505590
    call FUN_0050e936                            # 00505591
    add esp, 0x4                                 # 00505596
L_00505599:
    # block 0x00505599: entered by je at 0x0050558e, 3 instruction(s), ends with je to 0x005055a9 (forward)
    mov eax, dword ptr [esi + field_c]           # 00505599
    test eax, eax                                # 0050559c
    je.d8 L_005055a9                             # 0050559e
    # block 0x005055a0: entered by fall-through of je at 0x0050559e, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x005055a9
    push eax                                     # 005055a0
    call FUN_0050e936                            # 005055a1
    add esp, 0x4                                 # 005055a6
L_005055a9:
    # block 0x005055a9: entered by je at 0x0050559e, 6 instruction(s), falls into the block at 0x005055b9
    {load} xor eax, eax                          # 005055a9
    mov dword ptr [esi], eax                     # 005055ab
    mov dword ptr [esi + field_4], eax           # 005055ad
    mov dword ptr [esi + field_8], eax           # 005055b0
    mov dword ptr [esi + field_c], eax           # 005055b3
    mov dword ptr [esi + field_10], eax          # 005055b6
L_005055b9:
    # block 0x005055b9: entered by je at 0x00505587, 2 instruction(s), ends with ret
    pop esi                                      # 005055b9
    ret                                          # 005055ba

# --- data items (not part of the function) -------------------------
.org 0x005055bb - 0x401000
PAD_005055bb:  # 5 byte(s) of nop padding
    .fill 5, 1, 0x90

