# FUN_00524aff
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00524aff
# extent:       0x00524aff-0x00524b43 (68 code bytes)
# span:         0x00524aff-0x00524b43 (code 68, tables 0, padding 0)
# sha256:       7d26785ed302a62d7e8593e0aac1f278cbfa84e2dca47d6619b3fa3ddb823af3
# evidence:     ev_2c715b3bd3208197e01b2ebef20c92856fcb381a668a9ff837ea142d14b02822
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         CWinThread::CWinThread
# naming:       Ghidra name from function-index.json (not re-derived here)
# summary:      Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8, field_c, field_minus_4, field_minus_c, field_minus_10; [esi + n] field_4c, field_50
# callees:      calls FUN_0050f978, FUN_0051d716, FUN_00524b9c
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 21 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_4c, 0x4c  # offset +0x4c
.equ field_50, 0x50  # offset +0x50

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)
.set FUN_00524b9c, .text + (0x00524b9c - 0x401000)

.org 0x00524aff - 0x401000
.globl FUN_00524aff
FUN_00524aff:
    # block 0x00524aff: entry, 21 instruction(s), calls FUN_0050f978, FUN_0051d716, FUN_00524b9c, ends with ret 0x8
    mov eax, 0x528db4                            # 00524aff
    call FUN_0050f978                            # 00524b04
    push ecx                                     # 00524b09
    push esi                                     # 00524b0a
    {load} mov esi, ecx                          # 00524b0b
    mov dword ptr [ebp - field_minus_10], esi    # 00524b0d
    call FUN_0051d716                            # 00524b10
    mov eax, dword ptr [ebp + field_8]           # 00524b15
    and dword ptr [ebp - field_minus_4], 0x0     # 00524b18
    mov dword ptr [esi + field_50], eax          # 00524b1c
    mov eax, dword ptr [ebp + field_c]           # 00524b1f
    {load} mov ecx, esi                          # 00524b22
    mov dword ptr [esi], 0x52f3c0                # 00524b24
    mov dword ptr [esi + field_4c], eax          # 00524b2a
    call FUN_00524b9c                            # 00524b2d
    mov ecx, dword ptr [ebp - field_minus_c]     # 00524b32
    {load} mov eax, esi                          # 00524b35
    pop esi                                      # 00524b37
    mov dword ptr fs:[0x0], ecx                  # 00524b38
    leave                                        # 00524b3f
    ret 0x8                                      # 00524b40

