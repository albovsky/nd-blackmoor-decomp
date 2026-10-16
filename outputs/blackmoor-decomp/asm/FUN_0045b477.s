# FUN_0045b477
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045b477
# extent:       0x0045b477-0x0045b4ae (55 code bytes)
# span:         0x0045b477-0x0045b4ae (code 55, tables 0, padding 0)
# sha256:       df6b2cf018539b83dc4011959e982ee1af6e4e920017f7c25910288a017e5b96
# evidence:     ev_f51cc55276120d19811669e671858343b4478877f4752e92acf19b83badf3e68
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0045b477
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_166; [ecx + n] field_1c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_166, 0x166  # offset +0x166

# --- external targets -----------------------------------------------

.org 0x0045b477 - 0x401000
.globl FUN_0045b477
FUN_0045b477:
    # block 0x0045b477: entry, 7 instruction(s), ends with je to 0x0045b4aa (forward)
    push ebp                                     # 0045b477
    {load} mov ebp, esp                          # 0045b478
    push ecx                                     # 0045b47a
    mov dword ptr [ebp - local_4], ecx           # 0045b47b
    mov eax, dword ptr [ebp - local_4]           # 0045b47e
    cmp dword ptr [eax + field_166], 0x0         # 0045b481
    je.d8 L_0045b4aa                             # 0045b488
    # block 0x0045b48a: entered by fall-through of je at 0x0045b488, 4 instruction(s), ends with je to 0x0045b4aa (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0045b48a
    movsx edx, word ptr [ecx + field_1c]         # 0045b48d
    cmp edx, -0x1                                # 0045b491
    je.d8 L_0045b4aa                             # 0045b494
    # block 0x0045b496: entered by fall-through of je at 0x0045b494, 4 instruction(s), falls into the block at 0x0045b4aa
    mov eax, dword ptr [ebp - local_4]           # 0045b496
    movsx ecx, word ptr [eax + field_1c]         # 0045b499
    imul ecx, ecx, 0x4a                          # 0045b49d
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 0045b4a0
L_0045b4aa:
    # block 0x0045b4aa: entered by je at 0x0045b488; je at 0x0045b494, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0045b4aa
    pop ebp                                      # 0045b4ac
    ret                                          # 0045b4ad

