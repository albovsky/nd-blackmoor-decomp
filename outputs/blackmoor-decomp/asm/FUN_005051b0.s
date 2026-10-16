# FUN_005051b0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005051b0
# extent:       0x005051b0-0x005051e5 (53 code bytes)
# span:         0x005051b0-0x005051f0 (code 53, tables 0, padding 11)
# sha256:       0c0bb90ef23a1c06d1428e5ffffc597a8c9a043259affd2e98067c4b771a498e
# evidence:     ev_2c7b89b0c56f509b73593de956bd6bce397158201dc29b2101fbbc0ba74b9315
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005051b0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_4, field_8; [esp + n] stk_8
# callees:      calls FUN_0050e936
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 22 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)

.org 0x005051b0 - 0x401000
.globl FUN_005051b0
FUN_005051b0:
    # block 0x005051b0: entry, 4 instruction(s), ends with je to 0x005051e3 (forward)
    push esi                                     # 005051b0
    mov esi, dword ptr [esp + stk_8]             # 005051b1
    test esi, esi                                # 005051b5
    je.d8 L_005051e3                             # 005051b7
    # block 0x005051b9: entered by fall-through of je at 0x005051b7, 3 instruction(s), ends with je to 0x005051c9 (forward)
    mov eax, dword ptr [esi + field_4]           # 005051b9
    test eax, eax                                # 005051bc
    je.d8 L_005051c9                             # 005051be
    # block 0x005051c0: entered by fall-through of je at 0x005051be, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x005051c9
    push eax                                     # 005051c0
    call FUN_0050e936                            # 005051c1
    add esp, 0x4                                 # 005051c6
L_005051c9:
    # block 0x005051c9: entered by je at 0x005051be, 3 instruction(s), ends with je to 0x005051d9 (forward)
    mov eax, dword ptr [esi + field_8]           # 005051c9
    test eax, eax                                # 005051cc
    je.d8 L_005051d9                             # 005051ce
    # block 0x005051d0: entered by fall-through of je at 0x005051ce, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x005051d9
    push eax                                     # 005051d0
    call FUN_0050e936                            # 005051d1
    add esp, 0x4                                 # 005051d6
L_005051d9:
    # block 0x005051d9: entered by je at 0x005051ce, 4 instruction(s), falls into the block at 0x005051e3
    {load} xor eax, eax                          # 005051d9
    mov dword ptr [esi], eax                     # 005051db
    mov dword ptr [esi + field_4], eax           # 005051dd
    mov dword ptr [esi + field_8], eax           # 005051e0
L_005051e3:
    # block 0x005051e3: entered by je at 0x005051b7, 2 instruction(s), ends with ret
    pop esi                                      # 005051e3
    ret                                          # 005051e4

# --- data items (not part of the function) -------------------------
.org 0x005051e5 - 0x401000
PAD_005051e5:  # 11 byte(s) of nop padding
    .fill 11, 1, 0x90

