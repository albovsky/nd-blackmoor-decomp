# FUN_00459b87
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00459b87
# extent:       0x00459b87-0x00459bd6 (79 code bytes)
# span:         0x00459b87-0x00459bd6 (code 79, tables 0, padding 0)
# sha256:       b05b793daeffa0bc56baee2c2e49db23a4e311f08c121cd1c1c47a3a8eeeb56b
# evidence:     ev_f51cc55276120d19811669e671858343b4478877f4752e92acf19b83badf3e68
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00459b87
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_c8; [ecx + n] field_22; [edx + n] field_22
# callees:      calls FUN_004c2dfb, FUN_004d3992, FUN_00459aea
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 26 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_22, 0x22  # offset +0x22
.equ field_c8, 0xc8  # offset +0xc8

# --- external targets -----------------------------------------------
.set FUN_00459aea, .text + (0x00459aea - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x00459b87 - 0x401000
.globl FUN_00459b87
FUN_00459b87:
    # block 0x00459b87: entry, 7 instruction(s), ends with je to 0x00459bae (forward)
    push ebp                                     # 00459b87
    {load} mov ebp, esp                          # 00459b88
    push ecx                                     # 00459b8a
    mov dword ptr [ebp - local_4], ecx           # 00459b8b
    mov eax, dword ptr [ebp - local_4]           # 00459b8e
    cmp dword ptr [eax + field_c8], 0x0          # 00459b91
    je.d8 L_00459bae                             # 00459b98
    # block 0x00459b9a: entered by fall-through of je at 0x00459b98, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x00459bae
    mov ecx, dword ptr [ebp - local_4]           # 00459b9a
    add ecx, 0xc8                                # 00459b9d
    push ecx                                     # 00459ba3
    mov ecx, 0x5cf659                            # 00459ba4
    call FUN_004c2dfb                            # 00459ba9
L_00459bae:
    # block 0x00459bae: entered by je at 0x00459b98, 4 instruction(s), ends with je to 0x00459bca (forward)
    mov edx, dword ptr [ebp - local_4]           # 00459bae
    movsx eax, word ptr [edx + field_22]         # 00459bb1
    cmp eax, -0x1                                # 00459bb5
    je.d8 L_00459bca                             # 00459bb8
    # block 0x00459bba: entered by fall-through of je at 0x00459bb8, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x00459bca
    mov ecx, dword ptr [ebp - local_4]           # 00459bba
    mov dx, word ptr [ecx + field_22]            # 00459bbd
    push edx                                     # 00459bc1
    call FUN_004d3992                            # 00459bc2
    add esp, 0x4                                 # 00459bc7
L_00459bca:
    # block 0x00459bca: entered by je at 0x00459bb8, 5 instruction(s), calls FUN_00459aea, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 00459bca
    call FUN_00459aea                            # 00459bcd
    {load} mov esp, ebp                          # 00459bd2
    pop ebp                                      # 00459bd4
    ret                                          # 00459bd5

