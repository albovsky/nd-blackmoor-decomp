# FUN_004ff2f0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ff2f0
# extent:       0x004ff2f0-0x004ff303 (19 code bytes)
# span:         0x004ff2f0-0x004ff310 (code 19, tables 0, padding 13)
# sha256:       24a9774de75f94cb2238a11c64d8e30ee5eb7985397b162abec11d8de327daac
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ff2f0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esp + n] stk_4
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------

.org 0x004ff2f0 - 0x401000
.globl FUN_004ff2f0
FUN_004ff2f0:
    # block 0x004ff2f0: entry, 4 instruction(s), ends with je to 0x004ff302 (forward)
    mov ecx, dword ptr [esp + stk_4]             # 004ff2f0
    {load} xor eax, eax                          # 004ff2f4
    test ecx, ecx                                # 004ff2f6
    je.d8 L_004ff302                             # 004ff2f8
    # block 0x004ff2fa: entered by fall-through of je at 0x004ff2f8, 2 instruction(s), ends with je to 0x004ff302 (forward)
    dec ecx                                      # 004ff2fa
    je.d8 L_004ff302                             # 004ff2fb
L_004ff2fd:
    # block 0x004ff2fd: entered by jne at 0x004ff300; fall-through of je at 0x004ff2fb, 3 instruction(s), ends with jne to 0x004ff2fd (backward)
    inc eax                                      # 004ff2fd
    shr ecx                                      # 004ff2fe
    jne.d8 L_004ff2fd                            # 004ff300
L_004ff302:
    # block 0x004ff302: entered by je at 0x004ff2f8; je at 0x004ff2fb; fall-through of jne at 0x004ff300, 1 instruction(s), ends with ret
    ret                                          # 004ff302

# --- data items (not part of the function) -------------------------
.org 0x004ff303 - 0x401000
PAD_004ff303:  # 13 byte(s) of nop padding
    .fill 13, 1, 0x90

