# FUN_0051a36e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a36e
# extent:       0x0051a36e-0x0051a387 (25 code bytes)
# span:         0x0051a36e-0x0051a387 (code 25, tables 0, padding 0)
# sha256:       e1a8125819f02ff0ad71452adc3c9a4362c890a3fa9e16730c3e15612ff170fe
# evidence:     ev_0680edc662884da36b8b0465edad49b6c92edef1a0a3fe66526c018dc441b835
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051a36e
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_c, field_10; [esp + n] stk_4
# callees:      calls FUN_0051a2cd
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
.set FUN_0051a2cd, .text + (0x0051a2cd - 0x401000)

.org 0x0051a36e - 0x401000
.globl FUN_0051a36e
FUN_0051a36e:
    # block 0x0051a36e: entry, 6 instruction(s), ends with jne to 0x0051a384 (forward)
    mov eax, dword ptr [esp + stk_4]             # 0051a36e
    mov edx, dword ptr [ecx + field_10]          # 0051a372
    mov dword ptr [eax], edx                     # 0051a375
    dec dword ptr [ecx + field_c]                # 0051a377
    mov dword ptr [ecx + field_10], eax          # 0051a37a
    jne.d8 L_0051a384                            # 0051a37d
    # block 0x0051a37f: entered by fall-through of jne at 0x0051a37d, 1 instruction(s), calls FUN_0051a2cd, falls into the block at 0x0051a384
    call FUN_0051a2cd                            # 0051a37f
L_0051a384:
    # block 0x0051a384: entered by jne at 0x0051a37d, 1 instruction(s), ends with ret 0x4
    ret 0x4                                      # 0051a384

