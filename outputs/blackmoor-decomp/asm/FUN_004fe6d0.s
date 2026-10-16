# FUN_004fe6d0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fe6d0
# extent:       0x004fe6d0-0x004fe6f6 (38 code bytes)
# span:         0x004fe6d0-0x004fe700 (code 38, tables 0, padding 10)
# sha256:       71d9c605e51997e1736ad6358f600fd549c1bd818c9e15f9903a0da2bad93d54
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fe6d0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_1c; [esp + n] stk_8
# callees:      calls FUN_0050e97e
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 15 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0050e97e, .text + (0x0050e97e - 0x401000)

.org 0x004fe6d0 - 0x401000
.globl FUN_004fe6d0
FUN_004fe6d0:
    # block 0x004fe6d0: entry, 15 instruction(s), calls FUN_0050e97e, ends with ret
    push esi                                     # 004fe6d0
    mov esi, dword ptr [esp + stk_8]             # 004fe6d1
    push edi                                     # 004fe6d5
    mov ecx, 0x8                                 # 004fe6d6
    {load} xor eax, eax                          # 004fe6db
    {load} mov edi, esi                          # 004fe6dd
    push 0xe74                                   # 004fe6df
    push 0x1                                     # 004fe6e4
    rep stosd dword ptr es:[edi], eax            # 004fe6e6
    call FUN_0050e97e                            # 004fe6e8
    add esp, 0x8                                 # 004fe6ed
    mov dword ptr [esi + field_1c], eax          # 004fe6f0
    pop edi                                      # 004fe6f3
    pop esi                                      # 004fe6f4
    ret                                          # 004fe6f5

# --- data items (not part of the function) -------------------------
.org 0x004fe6f6 - 0x401000
PAD_004fe6f6:  # 10 byte(s) of nop padding
    .fill 10, 1, 0x90

