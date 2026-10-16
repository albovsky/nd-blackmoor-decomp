# FUN_005218ea
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005218ea
# extent:       0x005218ea-0x00521942 (88 code bytes)
# span:         0x005218ea-0x00521942 (code 88, tables 0, padding 0)
# sha256:       659f70884870f8c776d56860e11d32beecfb59d4e868f696d402bd1bd194ddb1
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005218ea
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_4, field_minus_c, field_minus_10; [esi + n] field_44, field_84
# callees:      calls FUN_0050f978, FUN_00521942, KERNEL32.dll!GlobalFree, FUN_0051e7ba, FUN_0051de13
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 25 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_44, 0x44  # offset +0x44
.equ field_84, 0x84  # offset +0x84

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051de13, .text + (0x0051de13 - 0x401000)
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)
.set FUN_00521942, .text + (0x00521942 - 0x401000)

.org 0x005218ea - 0x401000
.globl FUN_005218ea
FUN_005218ea:
    # block 0x005218ea: entry, 12 instruction(s), calls FUN_0050f978, FUN_00521942, ends with je to 0x0052191b (forward)
    mov eax, 0x528c9e                            # 005218ea
    call FUN_0050f978                            # 005218ef
    push ecx                                     # 005218f4
    push esi                                     # 005218f5
    {load} mov esi, ecx                          # 005218f6
    mov dword ptr [ebp - field_minus_10], esi    # 005218f8
    mov dword ptr [esi], 0x52efd4                # 005218fb
    mov dword ptr [ebp - field_minus_4], 0x1     # 00521901
    call FUN_00521942                            # 00521908
    mov eax, dword ptr [esi + field_44]          # 0052190d
    test eax, eax                                # 00521910
    je.d8 L_0052191b                             # 00521912
    # block 0x00521914: entered by fall-through of je at 0x00521912, 2 instruction(s), calls KERNEL32.dll!GlobalFree, falls into the block at 0x0052191b
    push eax                                     # 00521914
    call dword ptr [0x52a20c]                    # 00521915
L_0052191b:
    # block 0x0052191b: entered by je at 0x00521912, 11 instruction(s), calls FUN_0051e7ba, FUN_0051de13, ends with ret
    and byte ptr [ebp - field_minus_4], 0x0      # 0052191b
    lea ecx, [esi + field_84]                    # 0052191f
    call FUN_0051e7ba                            # 00521925
    or dword ptr [ebp - field_minus_4], -0x1     # 0052192a
    {load} mov ecx, esi                          # 0052192e
    call FUN_0051de13                            # 00521930
    mov ecx, dword ptr [ebp - field_minus_c]     # 00521935
    pop esi                                      # 00521938
    mov dword ptr fs:[0x0], ecx                  # 00521939
    leave                                        # 00521940
    ret                                          # 00521941

