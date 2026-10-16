# FUN_00522419
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00522419
# extent:       0x00522419-0x00522451 (56 code bytes)
# span:         0x00522419-0x00522451 (code 56, tables 0, padding 0)
# sha256:       b411c309be9051dc45661a01c898be13cde46c22c9af7df8dc829d16803bd313
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_0052233d (+0xdc)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00522419
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_1c, field_2c, field_84; [esp + n] stk_4
# callees:      calls USER32.dll!SendMessageA, FUN_0051ab4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 16 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_2c, 0x2c  # offset +0x2c
.equ field_84, 0x84  # offset +0x84

# --- external targets -----------------------------------------------
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)

.org 0x00522419 - 0x401000
.globl FUN_00522419
FUN_00522419:
    # block 0x00522419: entry, 5 instruction(s), ends with jne to 0x00522449 (forward)
    mov eax, dword ptr [esp + stk_4]             # 00522419
    mov dword ptr [ecx + field_2c], 0x2          # 0052241d
    and eax, 0xfff0                              # 00522424
    cmp eax, 0xf060                              # 00522429
    jne.d8 L_00522449                            # 0052242e
    # block 0x00522430: entered by fall-through of jne at 0x0052242e, 3 instruction(s), ends with je to 0x00522449 (forward)
    {load} xor eax, eax                          # 00522430
    cmp dword ptr [ecx + field_84], eax          # 00522432
    je.d8 L_00522449                             # 00522438
    # block 0x0052243a: entered by fall-through of je at 0x00522438, 6 instruction(s), calls USER32.dll!SendMessageA, ends with forward jump to 0x0052244e
    push eax                                     # 0052243a
    push eax                                     # 0052243b
    push 0x10                                    # 0052243c
    push dword ptr [ecx + field_1c]              # 0052243e
    call dword ptr [0x52a4c8]                    # 00522441
    jmp.d8 L_0052244e                            # 00522447
L_00522449:
    # block 0x00522449: entered by jne at 0x0052242e; je at 0x00522438, 1 instruction(s), calls FUN_0051ab4b, falls into the block at 0x0052244e
    call FUN_0051ab4b                            # 00522449
L_0052244e:
    # block 0x0052244e: entered by jmp at 0x00522447, 1 instruction(s), ends with ret 0x8
    ret 0x8                                      # 0052244e

