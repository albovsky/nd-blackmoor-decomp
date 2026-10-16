# FUN_0052329b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052329b
# extent:       0x0052329b-0x005232d1 (54 code bytes)
# span:         0x0052329b-0x005232d1 (code 54, tables 0, padding 0)
# sha256:       814e0457de1c2e108665f652551307069c846a76995cede4c2ed47d51beafeb0
# evidence:     derived-entry: found by the span split, not in function-index.json; inside the span of FUN_005231d1 (+0xca)
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052329b
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_bc; [edx + n] field_a4; [esi + n] field_1c, field_44; [esp + n] stk_4
# callees:      calls USER32.dll!SetMenu; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 20 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_44, 0x44  # offset +0x44
.equ field_a4, 0xa4  # offset +0xa4
.equ field_bc, 0xbc  # offset +0xbc

# --- external targets -----------------------------------------------

.org 0x0052329b - 0x401000
.globl FUN_0052329b
FUN_0052329b:
    # block 0x0052329b: entry, 5 instruction(s), ends with jne to 0x005232c3 (forward)
    mov eax, dword ptr [esp + stk_4]             # 0052329b
    push esi                                     # 0052329f
    test eax, eax                                # 005232a0
    {load} mov esi, ecx                          # 005232a2
    jne.d8 L_005232c3                            # 005232a4
    # block 0x005232a6: entered by fall-through of jne at 0x005232a4, 4 instruction(s), calls indirect dword ptr [eax + 0xbc], ends with je to 0x005232c0 (forward)
    mov eax, dword ptr [esi]                     # 005232a6
    call dword ptr [eax + field_bc]              # 005232a8
    test eax, eax                                # 005232ae
    je.d8 L_005232c0                             # 005232b0
    # block 0x005232b2: entered by fall-through of je at 0x005232b0, 5 instruction(s), calls indirect dword ptr [edx + 0xa4], ends with jne to 0x005232c3 (forward)
    mov edx, dword ptr [eax]                     # 005232b2
    {load} mov ecx, eax                          # 005232b4
    call dword ptr [edx + field_a4]              # 005232b6
    test eax, eax                                # 005232bc
    jne.d8 L_005232c3                            # 005232be
L_005232c0:
    # block 0x005232c0: entered by je at 0x005232b0; fall-through of jne at 0x005232be, 1 instruction(s), falls into the block at 0x005232c3
    mov eax, dword ptr [esi + field_44]          # 005232c0
L_005232c3:
    # block 0x005232c3: entered by jne at 0x005232a4; jne at 0x005232be, 5 instruction(s), calls USER32.dll!SetMenu, ends with ret 0x4
    push eax                                     # 005232c3
    push dword ptr [esi + field_1c]              # 005232c4
    call dword ptr [0x52a390]                    # 005232c7
    pop esi                                      # 005232cd
    ret 0x4                                      # 005232ce

