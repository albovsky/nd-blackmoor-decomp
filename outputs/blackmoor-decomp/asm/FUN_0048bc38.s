# FUN_0048bc38
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048bc38
# extent:       0x0048bc38-0x0048bc9b (99 code bytes)
# span:         0x0048bc38-0x0048bc9b (code 99, tables 0, padding 0)
# sha256:       3825de742d9dd36ce06526747de36286fb673641a7c19045212dfad5e0470b7b
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0048bc38
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_46; [ecx + n] field_2e, field_30; [edx + n] field_2e, field_30
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 33 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_2e, 0x2e  # offset +0x2e
.equ field_30, 0x30  # offset +0x30
.equ field_46, 0x46  # offset +0x46

# --- external targets -----------------------------------------------

.org 0x0048bc38 - 0x401000
.globl FUN_0048bc38
FUN_0048bc38:
    # block 0x0048bc38: entry, 9 instruction(s), ends with je to 0x0048bc6b (forward)
    push ebp                                     # 0048bc38
    {load} mov ebp, esp                          # 0048bc39
    push ecx                                     # 0048bc3b
    mov dword ptr [ebp - local_4], ecx           # 0048bc3c
    mov eax, dword ptr [ebp - local_4]           # 0048bc3f
    {load} xor ecx, ecx                          # 0048bc42
    mov cl, byte ptr [eax + field_46]            # 0048bc44
    test ecx, ecx                                # 0048bc47
    je.d8 L_0048bc6b                             # 0048bc49
    # block 0x0048bc4b: entered by fall-through of je at 0x0048bc49, 4 instruction(s), ends with je to 0x0048bc6b (forward)
    mov edx, dword ptr [ebp - local_4]           # 0048bc4b
    movsx eax, word ptr [edx + field_2e]         # 0048bc4e
    cmp eax, -0x1                                # 0048bc52
    je.d8 L_0048bc6b                             # 0048bc55
    # block 0x0048bc57: entered by fall-through of je at 0x0048bc55, 4 instruction(s), falls into the block at 0x0048bc6b
    mov ecx, dword ptr [ebp - local_4]           # 0048bc57
    movsx edx, word ptr [ecx + field_2e]         # 0048bc5a
    imul edx, edx, 0x4a                          # 0048bc5e
    mov dword ptr [edx + 0x5d15a5], 0x1          # 0048bc61
L_0048bc6b:
    # block 0x0048bc6b: entered by je at 0x0048bc49; je at 0x0048bc55, 5 instruction(s), ends with je to 0x0048bc97 (forward)
    mov eax, dword ptr [ebp - local_4]           # 0048bc6b
    {load} xor ecx, ecx                          # 0048bc6e
    mov cl, byte ptr [eax + field_46]            # 0048bc70
    test ecx, ecx                                # 0048bc73
    je.d8 L_0048bc97                             # 0048bc75
    # block 0x0048bc77: entered by fall-through of je at 0x0048bc75, 4 instruction(s), ends with je to 0x0048bc97 (forward)
    mov edx, dword ptr [ebp - local_4]           # 0048bc77
    movsx eax, word ptr [edx + field_30]         # 0048bc7a
    cmp eax, -0x1                                # 0048bc7e
    je.d8 L_0048bc97                             # 0048bc81
    # block 0x0048bc83: entered by fall-through of je at 0x0048bc81, 4 instruction(s), falls into the block at 0x0048bc97
    mov ecx, dword ptr [ebp - local_4]           # 0048bc83
    movsx edx, word ptr [ecx + field_30]         # 0048bc86
    imul edx, edx, 0x4a                          # 0048bc8a
    mov dword ptr [edx + 0x5d15a5], 0x1          # 0048bc8d
L_0048bc97:
    # block 0x0048bc97: entered by je at 0x0048bc75; je at 0x0048bc81, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0048bc97
    pop ebp                                      # 0048bc99
    ret                                          # 0048bc9a

