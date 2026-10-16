# FUN_0051b2d3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051b2d3
# extent:       0x0051b2d3-0x0051b2f1 (30 code bytes)
# span:         0x0051b2d3-0x0051b2f1 (code 30, tables 0, padding 0)
# sha256:       2baac6678a0bcf273b7294cbf2e1f5e8afa98f1aabb913e7b35944329dc1f6a3
# evidence:     ev_c6207830fef0c4b941fc09c5e41c70003429cfb7399be898b71e969597eb455b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051b2d3
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4; [esi + n] field_34
# callees:      calls FUN_0051ab4b; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 13 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_34, 0x34  # offset +0x34

# --- external targets -----------------------------------------------
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)

.org 0x0051b2d3 - 0x401000
.globl FUN_0051b2d3
FUN_0051b2d3:
    # block 0x0051b2d3: entry, 5 instruction(s), ends with je to 0x0051b2e4 (forward)
    push esi                                     # 0051b2d3
    {load} mov esi, ecx                          # 0051b2d4
    mov ecx, dword ptr [esi + field_34]          # 0051b2d6
    test ecx, ecx                                # 0051b2d9
    je.d8 L_0051b2e4                             # 0051b2db
    # block 0x0051b2dd: entered by fall-through of je at 0x0051b2db, 3 instruction(s), calls indirect dword ptr [eax + 0x4], falls into the block at 0x0051b2e4
    mov eax, dword ptr [ecx]                     # 0051b2dd
    push 0x1                                     # 0051b2df
    call dword ptr [eax + field_4]               # 0051b2e1
L_0051b2e4:
    # block 0x0051b2e4: entered by je at 0x0051b2db, 5 instruction(s), calls FUN_0051ab4b, ends with ret
    and dword ptr [esi + field_34], 0x0          # 0051b2e4
    {load} mov ecx, esi                          # 0051b2e8
    call FUN_0051ab4b                            # 0051b2ea
    pop esi                                      # 0051b2ef
    ret                                          # 0051b2f0

