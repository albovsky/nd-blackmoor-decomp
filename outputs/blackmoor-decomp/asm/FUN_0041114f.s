# FUN_0041114f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041114f
# extent:       0x0041114f-0x004111a0 (81 code bytes)
# span:         0x0041114f-0x004111a0 (code 81, tables 0, padding 0)
# sha256:       6e6d0ca46a2f2839bc161f5815e6dc54627c422d6f3b422ac6001515b3ef909f
# evidence:     ev_e1d5cf90f6aebf321704f8d611ce26ca2904fc537a9974fc07aaf8081db3bfa6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0041114f
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004c2dfb, FUN_004110f6
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 25 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8

# --- external targets -----------------------------------------------
.set FUN_004110f6, .text + (0x004110f6 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)

.org 0x0041114f - 0x401000
.globl FUN_0041114f
FUN_0041114f:
    # block 0x0041114f: entry, 6 instruction(s), ends with forward jump to 0x0041116a
    push ebp                                     # 0041114f
    {load} mov ebp, esp                          # 00411150
    sub esp, 0x8                                 # 00411152
    mov dword ptr [ebp - local_8], ecx           # 00411155
    mov dword ptr [ebp - local_4], 0x0           # 00411158
    jmp.d8 L_0041116a                            # 0041115f
L_00411161:
    # block 0x00411161: entered by jmp at 0x00411192, 3 instruction(s), falls into the block at 0x0041116a
    mov eax, dword ptr [ebp - local_4]           # 00411161
    add eax, 0x1                                 # 00411164
    mov dword ptr [ebp - local_4], eax           # 00411167
L_0041116a:
    # block 0x0041116a: entered by jmp at 0x0041115f, 2 instruction(s), ends with jge to 0x00411194 (forward)
    cmp dword ptr [ebp - local_4], 0x6           # 0041116a
    jge.d8 L_00411194                            # 0041116e
    # block 0x00411170: entered by fall-through of jge at 0x0041116e, 3 instruction(s), ends with je to 0x00411192 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 00411170
    cmp dword ptr [4*ecx + 0x5d0397], 0x0        # 00411173
    je.d8 L_00411192                             # 0041117b
    # block 0x0041117d: entered by fall-through of je at 0x0041117b, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x00411192
    mov edx, dword ptr [ebp - local_4]           # 0041117d
    lea eax, [4*edx + 0x5d0397]                  # 00411180
    push eax                                     # 00411187
    mov ecx, 0x5cf659                            # 00411188
    call FUN_004c2dfb                            # 0041118d
L_00411192:
    # block 0x00411192: entered by je at 0x0041117b, 1 instruction(s), ends with backward jump to 0x00411161
    jmp.d8 L_00411161                            # 00411192
L_00411194:
    # block 0x00411194: entered by jge at 0x0041116e, 5 instruction(s), calls FUN_004110f6, ends with ret
    mov ecx, dword ptr [ebp - local_8]           # 00411194
    call FUN_004110f6                            # 00411197
    {load} mov esp, ebp                          # 0041119c
    pop ebp                                      # 0041119e
    ret                                          # 0041119f

