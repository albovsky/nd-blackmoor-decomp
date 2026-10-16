# FUN_005213d4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005213d4
# extent:       0x005213d4-0x0052142d (89 code bytes)
# span:         0x005213d4-0x0052142d (code 89, tables 0, padding 0)
# sha256:       5338c550be9e9c40ed90339e0e0869c43319e8100567d69ba8a1955a864fe3a6
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005213d4
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0xc (callee pops 12 bytes); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8, field_c, field_10, field_minus_4, field_minus_c, field_minus_10
# callees:      calls FUN_0050f978, FUN_0051faaa, FUN_0052139c, FUN_0051e7ba
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 28 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)
.set FUN_0051faaa, .text + (0x0051faaa - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x005213d4 - 0x401000
.globl FUN_005213d4
FUN_005213d4:
    # block 0x005213d4: entry, 12 instruction(s), calls FUN_0050f978, FUN_0051faaa, ends with jne to 0x00521401 (forward)
    mov eax, 0x528d60                            # 005213d4
    call FUN_0050f978                            # 005213d9
    push ecx                                     # 005213de
    mov eax, dword ptr [0x5679b0]                # 005213df
    mov dword ptr [ebp - field_minus_10], eax    # 005213e4
    push dword ptr [ebp + field_8]               # 005213e7
    and dword ptr [ebp - field_minus_4], 0x0     # 005213ea
    lea ecx, [ebp - field_minus_10]              # 005213ee
    call FUN_0051faaa                            # 005213f1
    mov eax, dword ptr [ebp + field_10]          # 005213f6
    cmp eax, -0x1                                # 005213f9
    jne.d8 L_00521401                            # 005213fc
    # block 0x005213fe: entered by fall-through of jne at 0x005213fc, 1 instruction(s), falls into the block at 0x00521401
    mov eax, dword ptr [ebp + field_8]           # 005213fe
L_00521401:
    # block 0x00521401: entered by jne at 0x005213fc, 15 instruction(s), calls FUN_0052139c, FUN_0051e7ba, ends with ret 0xc
    push esi                                     # 00521401
    push eax                                     # 00521402
    push dword ptr [ebp + field_c]               # 00521403
    push dword ptr [ebp - field_minus_10]        # 00521406
    call FUN_0052139c                            # 00521409
    or dword ptr [ebp - field_minus_4], -0x1     # 0052140e
    lea ecx, [ebp - field_minus_10]              # 00521412
    {load} mov esi, eax                          # 00521415
    call FUN_0051e7ba                            # 00521417
    mov ecx, dword ptr [ebp - field_minus_c]     # 0052141c
    {load} mov eax, esi                          # 0052141f
    pop esi                                      # 00521421
    mov dword ptr fs:[0x0], ecx                  # 00521422
    leave                                        # 00521429
    ret 0xc                                      # 0052142a

