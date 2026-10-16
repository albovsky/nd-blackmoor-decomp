# FUN_005217e4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005217e4
# extent:       0x005217e4-0x00521833 (79 code bytes)
# span:         0x005217e4-0x00521833 (code 79, tables 0, padding 0)
# sha256:       4386f8865de0ff8ead057e6eb0f2b146e29b6bf4b7409ed6292272cdb6ef0584
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005217e4
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8, field_c, field_minus_4, field_minus_c, field_minus_10; [esi + n] field_84
# callees:      calls FUN_0050f978, FUN_0051ddd5, FUN_0052184f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_84, 0x84  # offset +0x84

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051ddd5, .text + (0x0051ddd5 - 0x401000)
.set FUN_0052184f, .text + (0x0052184f - 0x401000)

.org 0x005217e4 - 0x401000
.globl FUN_005217e4
FUN_005217e4:
    # block 0x005217e4: entry, 23 instruction(s), calls FUN_0050f978, FUN_0051ddd5, FUN_0052184f, ends with ret 0x8
    mov eax, 0x528c7e                            # 005217e4
    call FUN_0050f978                            # 005217e9
    push ecx                                     # 005217ee
    push esi                                     # 005217ef
    {load} mov esi, ecx                          # 005217f0
    mov dword ptr [ebp - field_minus_10], esi    # 005217f2
    call FUN_0051ddd5                            # 005217f5
    mov eax, dword ptr [0x5679b0]                # 005217fa
    and dword ptr [ebp - field_minus_4], 0x0     # 005217ff
    mov dword ptr [esi + field_84], eax          # 00521803
    movzx eax, word ptr [ebp + field_8]          # 00521809
    push dword ptr [ebp + field_c]               # 0052180d
    {load} mov ecx, esi                          # 00521810
    mov byte ptr [ebp - field_minus_4], 0x1      # 00521812
    mov dword ptr [esi], 0x52efd4                # 00521816
    push eax                                     # 0052181c
    call FUN_0052184f                            # 0052181d
    mov ecx, dword ptr [ebp - field_minus_c]     # 00521822
    {load} mov eax, esi                          # 00521825
    pop esi                                      # 00521827
    mov dword ptr fs:[0x0], ecx                  # 00521828
    leave                                        # 0052182f
    ret 0x8                                      # 00521830

