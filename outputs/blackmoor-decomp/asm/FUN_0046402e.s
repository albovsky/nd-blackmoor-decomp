# FUN_0046402e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0046402e
# extent:       0x0046402e-0x00464076 (72 code bytes)
# span:         0x0046402e-0x00464076 (code 72, tables 0, padding 0)
# sha256:       ed8aaca2520df1c5b8d7a955931ac234eb5d92dda051b6bd6bb0b27268e608dd
# evidence:     ev_87c215b6acae2dc5650e31fcd27f76d139aec2c1d8e05fbf5ef1e7fe469374cd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0046402e
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1e, field_bc; [ecx + n] field_1c, field_c1; [edx + n] field_2a, field_b8
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 19 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_1e, 0x1e  # offset +0x1e
.equ field_2a, 0x2a  # offset +0x2a
.equ field_b8, 0xb8  # offset +0xb8
.equ field_bc, 0xbc  # offset +0xbc
.equ field_c1, 0xc1  # offset +0xc1

# --- external targets -----------------------------------------------

.org 0x0046402e - 0x401000
.globl FUN_0046402e
FUN_0046402e:
    # block 0x0046402e: entry, 19 instruction(s), ends with ret
    push ebp                                     # 0046402e
    {load} mov ebp, esp                          # 0046402f
    push ecx                                     # 00464031
    mov dword ptr [ebp - local_4], ecx           # 00464032
    mov eax, dword ptr [ebp - local_4]           # 00464035
    mov word ptr [eax + field_1e], 0xffff        # 00464038
    mov ecx, dword ptr [ebp - local_4]           # 0046403e
    mov word ptr [ecx + field_1c], 0xffff        # 00464041
    mov edx, dword ptr [ebp - local_4]           # 00464047
    mov dword ptr [edx + field_b8], 0x0          # 0046404a
    mov eax, dword ptr [ebp - local_4]           # 00464054
    mov byte ptr [eax + field_bc], 0x0           # 00464057
    mov ecx, dword ptr [ebp - local_4]           # 0046405e
    mov byte ptr [ecx + field_c1], 0x0           # 00464061
    mov edx, dword ptr [ebp - local_4]           # 00464068
    mov dword ptr [edx + field_2a], 0x0          # 0046406b
    {load} mov esp, ebp                          # 00464072
    pop ebp                                      # 00464074
    ret                                          # 00464075

