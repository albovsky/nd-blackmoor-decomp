# FUN_0040105e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0040105e
# extent:       0x0040105e-0x004010b0 (82 code bytes)
# span:         0x0040105e-0x004010b0 (code 82, tables 0, padding 0)
# sha256:       9a93a80e7c574c750042d5e9fceb5798b7783d1769a1b82cd5b21bf81b0d7b00
# evidence:     ev_5101d3157a7cceecfaf0c751ae06a21a7013310d21b12b5f59cdca7af1ddb679
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0040105e
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_3c; [edx + n] field_3c, field_a0
# callees:      none direct; 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 29 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_3c, 0x3c  # offset +0x3c
.equ field_a0, 0xa0  # offset +0xa0

# --- external targets -----------------------------------------------

.org 0x0040105e - 0x401000
.globl FUN_0040105e
FUN_0040105e:
    # block 0x0040105e: entry, 8 instruction(s), ends with jne to 0x00401072 (forward)
    push ebp                                     # 0040105e
    {load} mov ebp, esp                          # 0040105f
    push ecx                                     # 00401061
    mov dword ptr [ebp - local_4], ecx           # 00401062
    mov eax, dword ptr [ebp - local_4]           # 00401065
    mov ecx, dword ptr [eax + field_3c]          # 00401068
    cmp ecx, dword ptr [ebp + arg_8]             # 0040106b
    jne.d8 L_00401072                            # 0040106e
    # block 0x00401070: entered by fall-through of jne at 0x0040106e, 1 instruction(s), ends with forward jump to 0x004010aa
    jmp.d8 L_004010aa                            # 00401070
L_00401072:
    # block 0x00401072: entered by jne at 0x0040106e, 17 instruction(s), calls indirect dword ptr [edx + 0xa0], falls into the block at 0x004010aa
    mov edx, dword ptr [ebp - local_4]           # 00401072
    mov eax, dword ptr [ebp + arg_8]             # 00401075
    mov dword ptr [edx + field_3c], eax          # 00401078
    mov ecx, dword ptr [ebp + arg_c]             # 0040107b
    and ecx, 0xffff                              # 0040107e
    mov edx, dword ptr [ebp + arg_10]            # 00401084
    and edx, 0xffff                              # 00401087
    shl edx, 0x10                                # 0040108d
    {load} or ecx, edx                           # 00401090
    push ecx                                     # 00401092
    mov eax, dword ptr [ebp + arg_8]             # 00401093
    push eax                                     # 00401096
    push 0x102                                   # 00401097
    mov ecx, dword ptr [ebp - local_4]           # 0040109c
    mov edx, dword ptr [ecx]                     # 0040109f
    mov ecx, dword ptr [ebp - local_4]           # 004010a1
    call dword ptr [edx + field_a0]              # 004010a4
L_004010aa:
    # block 0x004010aa: entered by jmp at 0x00401070, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 004010aa
    pop ebp                                      # 004010ac
    ret 0xc                                      # 004010ad

