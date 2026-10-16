# FUN_00524b5f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00524b5f
# extent:       0x00524b5f-0x00524b9c (61 code bytes)
# span:         0x00524b5f-0x00524b9c (code 61, tables 0, padding 0)
# sha256:       a12a219a6064962f6265d8909e28a73a6793a03adc5ed5837f35bacbd07cf51b
# evidence:     ev_2c715b3bd3208197e01b2ebef20c92856fcb381a668a9ff837ea142d14b02822
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00524b5f
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_4, field_minus_c, field_minus_10; [esi + n] field_4c, field_50
# callees:      calls FUN_0050f978, FUN_0051d716, FUN_00524b9c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 20 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_4c, 0x4c  # offset +0x4c
.equ field_50, 0x50  # offset +0x50

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)
.set FUN_00524b9c, .text + (0x00524b9c - 0x401000)

.org 0x00524b5f - 0x401000
.globl FUN_00524b5f
FUN_00524b5f:
    # block 0x00524b5f: entry, 20 instruction(s), calls FUN_0050f978, FUN_0051d716, FUN_00524b9c, ends with ret
    mov eax, 0x528dc8                            # 00524b5f
    call FUN_0050f978                            # 00524b64
    push ecx                                     # 00524b69
    push esi                                     # 00524b6a
    {load} mov esi, ecx                          # 00524b6b
    mov dword ptr [ebp - field_minus_10], esi    # 00524b6d
    call FUN_0051d716                            # 00524b70
    {load} xor eax, eax                          # 00524b75
    {load} mov ecx, esi                          # 00524b77
    mov dword ptr [ebp - field_minus_4], eax     # 00524b79
    mov dword ptr [esi], 0x52f3c0                # 00524b7c
    mov dword ptr [esi + field_4c], eax          # 00524b82
    mov dword ptr [esi + field_50], eax          # 00524b85
    call FUN_00524b9c                            # 00524b88
    mov ecx, dword ptr [ebp - field_minus_c]     # 00524b8d
    {load} mov eax, esi                          # 00524b90
    pop esi                                      # 00524b92
    mov dword ptr fs:[0x0], ecx                  # 00524b93
    leave                                        # 00524b9a
    ret                                          # 00524b9b

