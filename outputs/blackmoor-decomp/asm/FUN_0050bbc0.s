# FUN_0050bbc0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050bbc0
# extent:       0x0050bbc0-0x0050bbf6 (54 code bytes)
# span:         0x0050bbc0-0x0050bc00 (code 54, tables 0, padding 10)
# sha256:       8db347ef85453008f3aa0a02aad4bbfd6cd6b4c385dad67fb6367c83b12e6e66
# evidence:     ev_14398f730fa9c49e7db80307b54fbb5d04baa803ce1c29895906ff2fa90b272c
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050bbc0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_4, field_8, field_c, field_10; [esi + n] field_8, field_c, field_10; [esp + n] stk_8
# callees:      calls FUN_0050ea90
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.set FUN_0050ea90, .text + (0x0050ea90 - 0x401000)

.org 0x0050bbc0 - 0x401000
.globl FUN_0050bbc0
FUN_0050bbc0:
    # block 0x0050bbc0: entry, 18 instruction(s), calls FUN_0050ea90, ends with ret
    push esi                                     # 0050bbc0
    mov esi, dword ptr [esp + stk_8]             # 0050bbc1
    {load} mov ecx, esi                          # 0050bbc5
    {load} xor eax, eax                          # 0050bbc7
    push 0x100                                   # 0050bbc9
    mov dword ptr [ecx], eax                     # 0050bbce
    mov dword ptr [ecx + field_4], eax           # 0050bbd0
    mov dword ptr [ecx + field_8], eax           # 0050bbd3
    mov dword ptr [ecx + field_c], eax           # 0050bbd6
    mov dword ptr [ecx + field_10], eax          # 0050bbd9
    call FUN_0050ea90                            # 0050bbdc
    add esp, 0x4                                 # 0050bbe1
    mov dword ptr [esi + field_8], eax           # 0050bbe4
    mov dword ptr [esi + field_c], eax           # 0050bbe7
    mov byte ptr [eax], 0x0                      # 0050bbea
    mov dword ptr [esi + field_10], 0x100        # 0050bbed
    pop esi                                      # 0050bbf4
    ret                                          # 0050bbf5

# --- data items (not part of the function) -------------------------
.org 0x0050bbf6 - 0x401000
PAD_0050bbf6:  # 10 byte(s) of nop padding
    .fill 10, 1, 0x90

