# FUN_0051a492
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051a492
# extent:       0x0051a492-0x0051a4bd (43 code bytes)
# span:         0x0051a492-0x0051a4bd (code 43, tables 0, padding 0)
# sha256:       19a1a78971a90044ab0106da962fde93579280ac823a44d37f790127625ebc1d
# evidence:     ev_0680edc662884da36b8b0465edad49b6c92edef1a0a3fe66526c018dc441b835
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         RemoveAll
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_4, field_c, field_10, field_14
# callees:      calls FUN_0051dc6c, FUN_0051a3f4
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 16 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14

# --- external targets -----------------------------------------------
.set FUN_0051a3f4, .text + (0x0051a3f4 - 0x401000)
.set FUN_0051dc6c, .text + (0x0051dc6c - 0x401000)

.org 0x0051a492 - 0x401000
.globl FUN_0051a492
FUN_0051a492:
    # block 0x0051a492: entry, 5 instruction(s), ends with je to 0x0051a4a7 (forward)
    push esi                                     # 0051a492
    {load} mov esi, ecx                          # 0051a493
    mov eax, dword ptr [esi + field_4]           # 0051a495
    test eax, eax                                # 0051a498
    je.d8 L_0051a4a7                             # 0051a49a
    # block 0x0051a49c: entered by fall-through of je at 0x0051a49a, 4 instruction(s), calls FUN_0051dc6c, falls into the block at 0x0051a4a7
    push eax                                     # 0051a49c
    call FUN_0051dc6c                            # 0051a49d
    and dword ptr [esi + field_4], 0x0           # 0051a4a2
    pop ecx                                      # 0051a4a6
L_0051a4a7:
    # block 0x0051a4a7: entered by je at 0x0051a49a, 7 instruction(s), calls FUN_0051a3f4, ends with ret
    mov ecx, dword ptr [esi + field_14]          # 0051a4a7
    and dword ptr [esi + field_c], 0x0           # 0051a4aa
    and dword ptr [esi + field_10], 0x0          # 0051a4ae
    call FUN_0051a3f4                            # 0051a4b2
    and dword ptr [esi + field_14], 0x0          # 0051a4b7
    pop esi                                      # 0051a4bb
    ret                                          # 0051a4bc

