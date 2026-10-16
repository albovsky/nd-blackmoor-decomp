# FUN_0051a533
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a533
# extent:       0x0051a533-0x0051a54c (25 code bytes)
# span:         0x0051a533-0x0051a54c (code 25, tables 0, padding 0)
# sha256:       e1a8125819f02ff0ad71452adc3c9a4362c890a3fa9e16730c3e15612ff170fe
# evidence:     ev_0680edc662884da36b8b0465edad49b6c92edef1a0a3fe66526c018dc441b835
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a533
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_c, field_10; [esp + n] stk_4
# callees:      calls FUN_0051a492
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 8 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0051a492, .text + (0x0051a492 - 0x401000)

.org 0x0051a533 - 0x401000
.globl FUN_0051a533
FUN_0051a533:
    # block 0x0051a533: entry, 6 instruction(s), ends with jne to 0x0051a549 (forward)
    mov eax, dword ptr [esp + stk_4]             # 0051a533
    mov edx, dword ptr [ecx + field_10]          # 0051a537
    mov dword ptr [eax], edx                     # 0051a53a
    dec dword ptr [ecx + field_c]                # 0051a53c
    mov dword ptr [ecx + field_10], eax          # 0051a53f
    jne.d8 L_0051a549                            # 0051a542
    # block 0x0051a544: entered by fall-through of jne at 0x0051a542, 1 instruction(s), calls FUN_0051a492, falls into the block at 0x0051a549
    call FUN_0051a492                            # 0051a544
L_0051a549:
    # block 0x0051a549: entered by jne at 0x0051a542, 1 instruction(s), ends with ret 0x4
    ret 0x4                                      # 0051a549

