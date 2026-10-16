# FUN_0045b3ea
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045b3ea
# extent:       0x0045b3ea-0x0045b42e (68 code bytes)
# span:         0x0045b3ea-0x0045b42e (code 68, tables 0, padding 0)
# sha256:       f02126a56c7d43b5b6f95f7ab4a7537dec8dfcca54f6c91b5da33c256793beb5
# evidence:     ev_f51cc55276120d19811669e671858343b4478877f4752e92acf19b83badf3e68
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0045b3ea
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1e, field_16a; [ecx + n] field_1c, field_162; [edx + n] field_166
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 17 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_162, 0x162  # offset +0x162
.equ field_166, 0x166  # offset +0x166
.equ field_16a, 0x16a  # offset +0x16a

# --- external targets -----------------------------------------------

.org 0x0045b3ea - 0x401000
.globl FUN_0045b3ea
FUN_0045b3ea:
    # block 0x0045b3ea: entry, 17 instruction(s), ends with ret
    push ebp                                     # 0045b3ea
    {load} mov ebp, esp                          # 0045b3eb
    push ecx                                     # 0045b3ed
    mov dword ptr [ebp - local_4], ecx           # 0045b3ee
    mov eax, dword ptr [ebp - local_4]           # 0045b3f1
    mov word ptr [eax + field_1e], 0xffff        # 0045b3f4
    mov ecx, dword ptr [ebp - local_4]           # 0045b3fa
    mov word ptr [ecx + field_1c], 0xffff        # 0045b3fd
    mov edx, dword ptr [ebp - local_4]           # 0045b403
    mov dword ptr [edx + field_166], 0x0         # 0045b406
    mov eax, dword ptr [ebp - local_4]           # 0045b410
    mov dword ptr [eax + field_16a], 0x0         # 0045b413
    mov ecx, dword ptr [ebp - local_4]           # 0045b41d
    mov dword ptr [ecx + field_162], 0x0         # 0045b420
    {load} mov esp, ebp                          # 0045b42a
    pop ebp                                      # 0045b42c
    ret                                          # 0045b42d

