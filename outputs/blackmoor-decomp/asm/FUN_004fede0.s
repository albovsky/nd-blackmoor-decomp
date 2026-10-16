# FUN_004fede0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fede0
# extent:       0x004fede0-0x004fee2c (76 code bytes)
# span:         0x004fede0-0x004fee30 (code 76, tables 0, padding 4)
# sha256:       3209b21e78758fa818fcda2cc39fe35763245d3b2ed1049f0573541a1ca79a4a
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fede0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edi + n] field_4; [esi + n] field_40, field_44, field_4c, field_68; [esp + n] stk_c
# callees:      calls FUN_0050e97e, FUN_0050bbc0
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 29 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_c, 0xc  # offset +0xc
.equ field_40, 0x40  # offset +0x40
.equ field_44, 0x44  # offset +0x44
.equ field_4c, 0x4c  # offset +0x4c
.equ field_68, 0x68  # offset +0x68

# --- external targets -----------------------------------------------
.set FUN_0050bbc0, .text + (0x0050bbc0 - 0x401000)
.set FUN_0050e97e, .text + (0x0050e97e - 0x401000)

.org 0x004fede0 - 0x401000
.globl FUN_004fede0
FUN_004fede0:
    # block 0x004fede0: entry, 15 instruction(s), ends with je to 0x004fee27 (forward)
    push esi                                     # 004fede0
    mov esi, dword ptr [esp + stk_c]             # 004fede1
    push edi                                     # 004fede5
    mov ecx, 0x1b                                # 004fede6
    {load} xor eax, eax                          # 004fedeb
    {load} mov edi, esi                          # 004feded
    rep stosd dword ptr es:[edi], eax            # 004fedef
    mov eax, dword ptr [esp + stk_c]             # 004fedf1
    {load} xor ecx, ecx                          # 004fedf5
    mov dword ptr [esi + field_40], eax          # 004fedf7
    mov dword ptr [esi + field_4c], ecx          # 004fedfa
    mov dword ptr [esi + field_44], ecx          # 004fedfd
    mov edx, dword ptr [eax]                     # 004fee00
    {load} cmp edx, ecx                          # 004fee02
    je.d8 L_004fee27                             # 004fee04
    # block 0x004fee06: entered by fall-through of je at 0x004fee04, 10 instruction(s), calls FUN_0050e97e, FUN_0050bbc0, falls into the block at 0x004fee27
    push 0x48                                    # 004fee06
    push 0x1                                     # 004fee08
    call FUN_0050e97e                            # 004fee0a
    {load} mov edi, eax                          # 004fee0f
    mov dword ptr [esi + field_68], edi          # 004fee11
    add esi, 0x4                                 # 004fee14
    push esi                                     # 004fee17
    call FUN_0050bbc0                            # 004fee18
    add esp, 0xc                                 # 004fee1d
    mov dword ptr [edi + field_4], 0xc61c3c00    # 004fee20
L_004fee27:
    # block 0x004fee27: entered by je at 0x004fee04, 4 instruction(s), ends with ret
    pop edi                                      # 004fee27
    {load} xor eax, eax                          # 004fee28
    pop esi                                      # 004fee2a
    ret                                          # 004fee2b

# --- data items (not part of the function) -------------------------
.org 0x004fee2c - 0x401000
PAD_004fee2c:  # 4 byte(s) of nop padding
    .fill 4, 1, 0x90

