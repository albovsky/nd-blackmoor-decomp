# FUN_0051e763
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e763
# extent:       0x0051e763-0x0051e791 (46 code bytes)
# span:         0x0051e763-0x0051e791 (code 46, tables 0, padding 0)
# sha256:       b3fc93097d4bf8e7730dc5fb934a0a3f7aac8a44f95d0c0fe2c50094f54c02d2
# evidence:     ev_96f1bc62419512d08d4ff3f4c9af28b1e7ac57401ae5f5f4318134ff6bf21907
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e763
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_minus_8, field_minus_c
# callees:      calls FUN_0051e6f1, FUN_0051e627, FUN_0050fa90
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 20 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_8, 0x8  # offset -0x8
.equ field_minus_c, 0xc  # offset -0xc

# --- external targets -----------------------------------------------
.set FUN_0050fa90, .text + (0x0050fa90 - 0x401000)
.set FUN_0051e627, .text + (0x0051e627 - 0x401000)
.set FUN_0051e6f1, .text + (0x0051e6f1 - 0x401000)

.org 0x0051e763 - 0x401000
.globl FUN_0051e763
FUN_0051e763:
    # block 0x0051e763: entry, 6 instruction(s), ends with jle to 0x0051e78e (forward)
    push esi                                     # 0051e763
    push edi                                     # 0051e764
    {load} mov edi, ecx                          # 0051e765
    mov esi, dword ptr [edi]                     # 0051e767
    cmp dword ptr [esi - field_minus_c], 0x1     # 0051e769
    jle.d8 L_0051e78e                            # 0051e76d
    # block 0x0051e76f: entered by fall-through of jle at 0x0051e76d, 11 instruction(s), calls FUN_0051e6f1, FUN_0051e627, FUN_0050fa90, falls into the block at 0x0051e78e
    call FUN_0051e6f1                            # 0051e76f
    push dword ptr [esi - field_minus_8]         # 0051e774
    {load} mov ecx, edi                          # 0051e777
    call FUN_0051e627                            # 0051e779
    mov eax, dword ptr [esi - field_minus_8]     # 0051e77e
    inc eax                                      # 0051e781
    push eax                                     # 0051e782
    push esi                                     # 0051e783
    push dword ptr [edi]                         # 0051e784
    call FUN_0050fa90                            # 0051e786
    add esp, 0xc                                 # 0051e78b
L_0051e78e:
    # block 0x0051e78e: entered by jle at 0x0051e76d, 3 instruction(s), ends with ret
    pop edi                                      # 0051e78e
    pop esi                                      # 0051e78f
    ret                                          # 0051e790

