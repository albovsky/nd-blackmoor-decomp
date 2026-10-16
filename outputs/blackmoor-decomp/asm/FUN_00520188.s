# FUN_00520188
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00520188
# extent:       0x00520188-0x005201e5 (93 code bytes)
# span:         0x00520188-0x005201e5 (code 93, tables 0, padding 0)
# sha256:       1a01fdf3014fdfaa3b5af470c59713d49db85f3d67559c9c14948af8c40f501f
# evidence:     ev_4885e6fea92dac09228c0a462164bd336a5e033477c51bac06a0c68b22eedb5b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00520188
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_4, field_minus_c, field_minus_10; [esi + n] field_8, field_c, field_10, field_1c
# callees:      calls FUN_0050f978, FUN_0052013d, FUN_0051e7ba
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 27 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
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
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)
.set FUN_0052013d, .text + (0x0052013d - 0x401000)

.org 0x00520188 - 0x401000
.globl FUN_00520188
FUN_00520188:
    # block 0x00520188: entry, 11 instruction(s), calls FUN_0050f978, ends with je to 0x005201b4 (forward)
    mov eax, 0x5291f1                            # 00520188
    call FUN_0050f978                            # 0052018d
    push ecx                                     # 00520192
    push esi                                     # 00520193
    {load} mov esi, ecx                          # 00520194
    mov dword ptr [ebp - field_minus_10], esi    # 00520196
    mov dword ptr [esi], 0x5300dc                # 00520199
    mov ecx, dword ptr [esi + field_8]           # 0052019f
    mov dword ptr [ebp - field_minus_4], 0x2     # 005201a2
    test ecx, ecx                                # 005201a9
    je.d8 L_005201b4                             # 005201ab
    # block 0x005201ad: entered by fall-through of je at 0x005201ab, 2 instruction(s), calls FUN_0052013d, falls into the block at 0x005201b4
    push 0x3                                     # 005201ad
    call FUN_0052013d                            # 005201af
L_005201b4:
    # block 0x005201b4: entered by je at 0x005201ab, 14 instruction(s), calls FUN_0051e7ba, ends with ret
    lea ecx, [esi + field_1c]                    # 005201b4
    mov byte ptr [ebp - field_minus_4], 0x1      # 005201b7
    call FUN_0051e7ba                            # 005201bb
    and byte ptr [ebp - field_minus_4], 0x0      # 005201c0
    lea ecx, [esi + field_10]                    # 005201c4
    call FUN_0051e7ba                            # 005201c7
    or dword ptr [ebp - field_minus_4], -0x1     # 005201cc
    lea ecx, [esi + field_c]                     # 005201d0
    call FUN_0051e7ba                            # 005201d3
    mov ecx, dword ptr [ebp - field_minus_c]     # 005201d8
    pop esi                                      # 005201db
    mov dword ptr fs:[0x0], ecx                  # 005201dc
    leave                                        # 005201e3
    ret                                          # 005201e4

