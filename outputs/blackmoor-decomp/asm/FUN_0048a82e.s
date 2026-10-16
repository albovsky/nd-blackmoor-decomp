# FUN_0048a82e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048a82e
# extent:       0x0048a82e-0x0048a865 (55 code bytes)
# span:         0x0048a82e-0x0048a865 (code 55, tables 0, padding 0)
# sha256:       31beb847af3af7ab38cc11665009e42fcac0a829cf624e13351db3928b0316ad
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0048a82e
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_1aa; [ecx + n] field_1c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1aa, 0x1aa  # offset +0x1aa

# --- external targets -----------------------------------------------

.org 0x0048a82e - 0x401000
.globl FUN_0048a82e
FUN_0048a82e:
    # block 0x0048a82e: entry, 7 instruction(s), ends with je to 0x0048a861 (forward)
    push ebp                                     # 0048a82e
    {load} mov ebp, esp                          # 0048a82f
    push ecx                                     # 0048a831
    mov dword ptr [ebp - local_4], ecx           # 0048a832
    mov eax, dword ptr [ebp - local_4]           # 0048a835
    cmp dword ptr [eax + field_1aa], 0x0         # 0048a838
    je.d8 L_0048a861                             # 0048a83f
    # block 0x0048a841: entered by fall-through of je at 0x0048a83f, 4 instruction(s), ends with je to 0x0048a861 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0048a841
    movsx edx, word ptr [ecx + field_1c]         # 0048a844
    cmp edx, -0x1                                # 0048a848
    je.d8 L_0048a861                             # 0048a84b
    # block 0x0048a84d: entered by fall-through of je at 0x0048a84b, 4 instruction(s), falls into the block at 0x0048a861
    mov eax, dword ptr [ebp - local_4]           # 0048a84d
    movsx ecx, word ptr [eax + field_1c]         # 0048a850
    imul ecx, ecx, 0x4a                          # 0048a854
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 0048a857
L_0048a861:
    # block 0x0048a861: entered by je at 0x0048a83f; je at 0x0048a84b, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0048a861
    pop ebp                                      # 0048a863
    ret                                          # 0048a864

