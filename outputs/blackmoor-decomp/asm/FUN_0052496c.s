# FUN_0052496c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052496c
# extent:       0x0052496c-0x005249a0 (52 code bytes)
# span:         0x0052496c-0x005249a0 (code 52, tables 0, padding 0)
# sha256:       e46ffeac73318b6ccc46eaf2744521599f32661491290e281f653de826150497
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_00524945 (+0x27)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052496c
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_minus_4, field_minus_c, field_minus_10
# callees:      calls FUN_0050f978, FUN_005256dd, FUN_00525099
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 16 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_00525099, .text + (0x00525099 - 0x401000)
.set FUN_005256dd, .text + (0x005256dd - 0x401000)

.org 0x0052496c - 0x401000
.globl FUN_0052496c
FUN_0052496c:
    # block 0x0052496c: entry, 11 instruction(s), calls FUN_0050f978, FUN_005256dd, ends with je to 0x00524994 (forward)
    mov eax, 0x528c15                            # 0052496c
    call FUN_0050f978                            # 00524971
    push ecx                                     # 00524976
    push 0x118                                   # 00524977
    call FUN_005256dd                            # 0052497c
    {load} mov ecx, eax                          # 00524981
    mov dword ptr [ebp - field_minus_10], ecx    # 00524983
    {load} xor eax, eax                          # 00524986
    {load} cmp ecx, eax                          # 00524988
    mov dword ptr [ebp - field_minus_4], eax     # 0052498a
    je.d8 L_00524994                             # 0052498d
    # block 0x0052498f: entered by fall-through of je at 0x0052498d, 1 instruction(s), calls FUN_00525099, falls into the block at 0x00524994
    call FUN_00525099                            # 0052498f
L_00524994:
    # block 0x00524994: entered by je at 0x0052498d, 4 instruction(s), ends with ret
    mov ecx, dword ptr [ebp - field_minus_c]     # 00524994
    mov dword ptr fs:[0x0], ecx                  # 00524997
    leave                                        # 0052499e
    ret                                          # 0052499f

