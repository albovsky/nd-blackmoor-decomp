# FUN_0051ddd5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051ddd5
# extent:       0x0051ddd5-0x0051ddf7 (34 code bytes)
# span:         0x0051ddd5-0x0051ddf7 (code 34, tables 0, padding 0)
# sha256:       952b6371630503bca68ad5ec6de7cf2dcb9de504fe283dbfc01fd0f325b42f43
# evidence:     ev_d600326f1458d8c8d5fec5204c0799b9a1ca52f1bb674b8356a1738515f4e4f7
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051ddd5
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_3c
# callees:      calls FUN_0051a7c3, FUN_0050f920
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 13 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_3c, 0x3c  # offset +0x3c

# --- external targets -----------------------------------------------
.set FUN_0050f920, .text + (0x0050f920 - 0x401000)
.set FUN_0051a7c3, .text + (0x0051a7c3 - 0x401000)

.org 0x0051ddd5 - 0x401000
.globl FUN_0051ddd5
FUN_0051ddd5:
    # block 0x0051ddd5: entry, 13 instruction(s), calls FUN_0051a7c3, FUN_0050f920, ends with ret
    push esi                                     # 0051ddd5
    {load} mov esi, ecx                          # 0051ddd6
    call FUN_0051a7c3                            # 0051ddd8
    push 0x20                                    # 0051dddd
    lea eax, [esi + field_3c]                    # 0051dddf
    push 0x0                                     # 0051dde2
    push eax                                     # 0051dde4
    mov dword ptr [esi], 0x52f29c                # 0051dde5
    call FUN_0050f920                            # 0051ddeb
    add esp, 0xc                                 # 0051ddf0
    {load} mov eax, esi                          # 0051ddf3
    pop esi                                      # 0051ddf5
    ret                                          # 0051ddf6

