# FUN_0051f351
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051f351
# extent:       0x0051f351-0x0051f36c (27 code bytes)
# span:         0x0051f351-0x0051f36c (code 27, tables 0, padding 0)
# sha256:       50a1ea2cc5d84200c2b3ed00f76d1b79d8bb08cf7ca9c7fc448b61fd89176975
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0051f207 (+0x14a)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051f351
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_1c, field_20
# callees:      calls USER32.dll!GetActiveWindow, FUN_0051abe4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 10 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------
.set FUN_0051abe4, .text + (0x0051abe4 - 0x401000)

.org 0x0051f351 - 0x401000
.globl FUN_0051f351
FUN_0051f351:
    # block 0x0051f351: entry, 3 instruction(s), ends with jne to 0x0051f36b (forward)
    mov eax, dword ptr [ecx + field_20]          # 0051f351
    test eax, eax                                # 0051f354
    jne.d8 L_0051f36b                            # 0051f356
    # block 0x0051f358: entered by fall-through of jne at 0x0051f356, 3 instruction(s), ends with jne to 0x0051f36b (forward)
    mov eax, dword ptr [ecx + field_1c]          # 0051f358
    test eax, eax                                # 0051f35b
    jne.d8 L_0051f36b                            # 0051f35d
    # block 0x0051f35f: entered by fall-through of jne at 0x0051f35d, 3 instruction(s), calls USER32.dll!GetActiveWindow, FUN_0051abe4, falls into the block at 0x0051f36b
    call dword ptr [0x52a354]                    # 0051f35f
    push eax                                     # 0051f365
    call FUN_0051abe4                            # 0051f366
L_0051f36b:
    # block 0x0051f36b: entered by jne at 0x0051f356; jne at 0x0051f35d, 1 instruction(s), ends with ret
    ret                                          # 0051f36b

