# FUN_00513745
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00513745
# extent:       0x00513745-0x00513777 (50 code bytes)
# span:         0x00513745-0x00513780 (code 50, tables 0, padding 9)
# sha256:       bf4879cc448eafe8f1edffea6dded3726d4296b1f874f4bfa47d6aa3222e8e81
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00513546 (+0x1ff)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00513745
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_8
# callees:      calls FUN_00515b32, tail jump LOC_00513ba9
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 20 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set LOC_00513ba9, .text + (0x00513ba9 - 0x401000)
.set FUN_00515b32, .text + (0x00515b32 - 0x401000)

.org 0x00513745 - 0x401000
.globl FUN_00513745
FUN_00513745:
    # block 0x00513745: entry, 18 instruction(s), calls FUN_00515b32, ends with je to 0x00513776 (forward)
    push esi                                     # 00513745
    sub esp, 0x74                                # 00513746
    {load} mov esi, esp                          # 00513749
    push esi                                     # 0051374b
    sub esp, 0x8                                 # 0051374c
    fstp qword ptr [esp]                         # 0051374f
    sub esp, 0x8                                 # 00513752
    fstp qword ptr [esp]                         # 00513755
    wait                                         # 00513758
    fnsave [esi + field_8]                       # 00513759
    call FUN_00515b32                            # 0051375c
    add esp, 0x14                                # 00513761
    frstor [esi + field_8]                       # 00513764
    fld qword ptr [esi]                          # 00513767
    add esp, 0x74                                # 00513769
    pop esi                                      # 0051376c
    test eax, eax                                # 0051376d
    je.d8 L_00513776                             # 0051376f
    # block 0x00513771: entered by fall-through of je at 0x0051376f, 1 instruction(s), ends with forward jump to 0x00513ba9
    jmp.d32 LOC_00513ba9                         # 00513771
L_00513776:
    # block 0x00513776: entered by je at 0x0051376f, 1 instruction(s), ends with ret
    ret                                          # 00513776

# --- data items (not part of the function) -------------------------
.org 0x00513777 - 0x401000
PAD_00513777:  # 9 byte(s) of int3 padding
    .fill 9, 1, 0xcc

