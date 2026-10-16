# FUN_004ab425
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ab425
# extent:       0x004ab425-0x004ab459 (52 code bytes)
# span:         0x004ab425-0x004ab459 (code 52, tables 0, padding 0)
# sha256:       3da5169b39a183a03b63db0fd2d9141405fc876ce16bf2cb6fa952b63b85e675
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ab425
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_54; [ecx + n] field_1c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_54, 0x54  # offset +0x54

# --- external targets -----------------------------------------------

.org 0x004ab425 - 0x401000
.globl FUN_004ab425
FUN_004ab425:
    # block 0x004ab425: entry, 7 instruction(s), ends with je to 0x004ab455 (forward)
    push ebp                                     # 004ab425
    {load} mov ebp, esp                          # 004ab426
    push ecx                                     # 004ab428
    mov dword ptr [ebp - local_4], ecx           # 004ab429
    mov eax, dword ptr [ebp - local_4]           # 004ab42c
    cmp dword ptr [eax + field_54], 0x0          # 004ab42f
    je.d8 L_004ab455                             # 004ab433
    # block 0x004ab435: entered by fall-through of je at 0x004ab433, 4 instruction(s), ends with je to 0x004ab455 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004ab435
    movsx edx, word ptr [ecx + field_1c]         # 004ab438
    cmp edx, -0x1                                # 004ab43c
    je.d8 L_004ab455                             # 004ab43f
    # block 0x004ab441: entered by fall-through of je at 0x004ab43f, 4 instruction(s), falls into the block at 0x004ab455
    mov eax, dword ptr [ebp - local_4]           # 004ab441
    movsx ecx, word ptr [eax + field_1c]         # 004ab444
    imul ecx, ecx, 0x4a                          # 004ab448
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 004ab44b
L_004ab455:
    # block 0x004ab455: entered by je at 0x004ab433; je at 0x004ab43f, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004ab455
    pop ebp                                      # 004ab457
    ret                                          # 004ab458

