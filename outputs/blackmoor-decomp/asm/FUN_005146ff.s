# FUN_005146ff
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005146ff
# extent:       0x005146ff-0x00514755 (86 code bytes)
# span:         0x005146ff-0x00514755 (code 86, tables 0, padding 0)
# sha256:       31cc5943f27fe88fec752ff08015ee81aa7ba7def58016af128cea6e09a32435
# evidence:     ev_ef606b3611f71cae908ae4dfd9c171d87d1bf5b814f82e9c922d3be8f60ac641
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005146ff
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       1 ebp-relative slot(s): local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 38 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x005146ff - 0x401000
.globl FUN_005146ff
FUN_005146ff:
    # block 0x005146ff: entry, 7 instruction(s), ends with je to 0x00514716 (forward)
    push ebp                                     # 005146ff
    {load} mov ebp, esp                          # 00514700
    push ecx                                     # 00514702
    push ecx                                     # 00514703
    mov cl, byte ptr [ebp + arg_8]               # 00514704
    test cl, 0x1                                 # 00514707
    je.d8 L_00514716                             # 0051470a
    # block 0x0051470c: entered by fall-through of je at 0x0051470a, 3 instruction(s), falls into the block at 0x00514716
    fld tbyte ptr [0x568a40]                     # 0051470c
    fistp dword ptr [ebp + arg_8]                # 00514712
    wait                                         # 00514715
L_00514716:
    # block 0x00514716: entered by je at 0x0051470a, 2 instruction(s), ends with je to 0x0051472b (forward)
    test cl, 0x8                                 # 00514716
    je.d8 L_0051472b                             # 00514719
    # block 0x0051471b: entered by fall-through of je at 0x00514719, 7 instruction(s), falls into the block at 0x0051472b
    wait                                         # 0051471b
    fnstsw ax                                    # 0051471c
    fld tbyte ptr [0x568a40]                     # 0051471e
    fstp qword ptr [ebp - local_8]               # 00514724
    wait                                         # 00514727
    wait                                         # 00514728
    fnstsw ax                                    # 00514729
L_0051472b:
    # block 0x0051472b: entered by je at 0x00514719, 2 instruction(s), ends with je to 0x0051473a (forward)
    test cl, 0x10                                # 0051472b
    je.d8 L_0051473a                             # 0051472e
    # block 0x00514730: entered by fall-through of je at 0x0051472e, 3 instruction(s), falls into the block at 0x0051473a
    fld tbyte ptr [0x568a4c]                     # 00514730
    fstp qword ptr [ebp - local_8]               # 00514736
    wait                                         # 00514739
L_0051473a:
    # block 0x0051473a: entered by je at 0x0051472e, 2 instruction(s), ends with je to 0x00514748 (forward)
    test cl, 0x4                                 # 0051473a
    je.d8 L_00514748                             # 0051473d
    # block 0x0051473f: entered by fall-through of je at 0x0051473d, 5 instruction(s), falls into the block at 0x00514748
    fldz                                         # 0051473f
    fld1                                         # 00514741
    fdivrp st(1), st                             # 00514743
    fstp st(0)                                   # 00514745
    wait                                         # 00514747
L_00514748:
    # block 0x00514748: entered by je at 0x0051473d, 2 instruction(s), ends with je to 0x00514753 (forward)
    test cl, 0x20                                # 00514748
    je.d8 L_00514753                             # 0051474b
    # block 0x0051474d: entered by fall-through of je at 0x0051474b, 3 instruction(s), falls into the block at 0x00514753
    fldpi                                        # 0051474d
    fstp qword ptr [ebp - local_8]               # 0051474f
    wait                                         # 00514752
L_00514753:
    # block 0x00514753: entered by je at 0x0051474b, 2 instruction(s), ends with ret
    leave                                        # 00514753
    ret                                          # 00514754

