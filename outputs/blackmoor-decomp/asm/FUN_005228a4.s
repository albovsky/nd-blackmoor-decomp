# FUN_005228a4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005228a4
# extent:       0x005228a4-0x0052290b (103 code bytes)
# span:         0x005228a4-0x0052290b (code 103, tables 0, padding 0)
# sha256:       a1c172f6e23a11122f79d1069d48bc1f0d249c0a31c76bb0111026b3ae4f94a1
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005228a4
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_4, field_minus_c, field_minus_10; [esi + n] field_6c, field_a4, field_ac
# callees:      calls FUN_0050f978, FUN_0052292f, FUN_0051dc6c, FUN_0051e7ba, FUN_0051a2ed, FUN_0051b257
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 29 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_6c, 0x6c  # offset +0x6c
.equ field_a4, 0xa4  # offset +0xa4
.equ field_ac, 0xac  # offset +0xac

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051a2ed, .text + (0x0051a2ed - 0x401000)
.set FUN_0051b257, .text + (0x0051b257 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)
.set FUN_0052292f, .text + (0x0052292f - 0x401000)

.org 0x005228a4 - 0x401000
.globl FUN_005228a4
FUN_005228a4:
    # block 0x005228a4: entry, 12 instruction(s), calls FUN_0050f978, FUN_0052292f, ends with je to 0x005228d8 (forward)
    mov eax, 0x528f31                            # 005228a4
    call FUN_0050f978                            # 005228a9
    push ecx                                     # 005228ae
    push esi                                     # 005228af
    {load} mov esi, ecx                          # 005228b0
    mov dword ptr [ebp - field_minus_10], esi    # 005228b2
    mov dword ptr [esi], 0x52fa5c                # 005228b5
    mov dword ptr [ebp - field_minus_4], 0x2     # 005228bb
    call FUN_0052292f                            # 005228c2
    mov eax, dword ptr [esi + field_a4]          # 005228c7
    test eax, eax                                # 005228cd
    je.d8 L_005228d8                             # 005228cf
    # block 0x005228d1: entered by fall-through of je at 0x005228cf, 3 instruction(s), calls FUN_0051dc6c, falls into the block at 0x005228d8
    push eax                                     # 005228d1
    call FUN_0051dc6c                            # 005228d2
    pop ecx                                      # 005228d7
L_005228d8:
    # block 0x005228d8: entered by je at 0x005228cf, 14 instruction(s), calls FUN_0051e7ba, FUN_0051a2ed, FUN_0051b257, ends with ret
    lea ecx, [esi + field_ac]                    # 005228d8
    mov byte ptr [ebp - field_minus_4], 0x1      # 005228de
    call FUN_0051e7ba                            # 005228e2
    and byte ptr [ebp - field_minus_4], 0x0      # 005228e7
    lea ecx, [esi + field_6c]                    # 005228eb
    call FUN_0051a2ed                            # 005228ee
    or dword ptr [ebp - field_minus_4], -0x1     # 005228f3
    {load} mov ecx, esi                          # 005228f7
    call FUN_0051b257                            # 005228f9
    mov ecx, dword ptr [ebp - field_minus_c]     # 005228fe
    pop esi                                      # 00522901
    mov dword ptr fs:[0x0], ecx                  # 00522902
    leave                                        # 00522909
    ret                                          # 0052290a

