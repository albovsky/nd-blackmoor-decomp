# FUN_00500980
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00500980
# extent:       0x00500980-0x00500999 (25 code bytes)
# span:         0x00500980-0x005009a0 (code 25, tables 0, padding 7)
# sha256:       495b44debe54aab5659bb686d695a0ed80855db527817313036e14fbdba63f24
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00500980
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_minus_4; [esp + n] stk_4, stk_8
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 9 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ stk_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x00500980 - 0x401000
.globl FUN_00500980
FUN_00500980:
    # block 0x00500980: entry, 2 instruction(s), falls into the block at 0x00500989
    mov eax, dword ptr [esp + stk_4]             # 00500980
    mov ecx, 0x38                                # 00500984
L_00500989:
    # block 0x00500989: entered by jne at 0x00500996, 6 instruction(s), ends with jne to 0x00500989 (backward)
    fld dword ptr [esp + stk_8]                  # 00500989
    fadd dword ptr [eax]                         # 0050098d
    add eax, 0x4                                 # 0050098f
    dec ecx                                      # 00500992
    fstp dword ptr [eax - field_minus_4]         # 00500993
    jne.d8 L_00500989                            # 00500996
    # block 0x00500998: entered by fall-through of jne at 0x00500996, 1 instruction(s), ends with ret
    ret                                          # 00500998

# --- data items (not part of the function) -------------------------
.org 0x00500999 - 0x401000
PAD_00500999:  # 7 byte(s) of nop padding
    .fill 7, 1, 0x90

