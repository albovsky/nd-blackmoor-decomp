# FUN_00521942
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00521942
# extent:       0x00521942-0x00521972 (48 code bytes)
# span:         0x00521942-0x00521972 (code 48, tables 0, padding 0)
# sha256:       01b7ffe8c09c8f0db7ae40a4dae0788561bded747c3121b41176f132a148db8b
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         CPropertyPage::Cleanup
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_1038; [edx + n] field_14; [esi + n] field_58
# callees:      calls FUN_00525371, FUN_0050e936; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 19 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_14, 0x14  # offset +0x14
.equ field_58, 0x58  # offset +0x58
.equ field_1038, 0x1038  # offset +0x1038

# --- external targets -----------------------------------------------
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x00521942 - 0x401000
.globl FUN_00521942
FUN_00521942:
    # block 0x00521942: entry, 6 instruction(s), calls FUN_00525371, ends with je to 0x00521970 (forward)
    push esi                                     # 00521942
    {load} mov esi, ecx                          # 00521943
    call FUN_00525371                            # 00521945
    mov eax, dword ptr [eax + field_1038]        # 0052194a
    test eax, eax                                # 00521950
    je.d8 L_00521970                             # 00521952
    # block 0x00521954: entered by fall-through of je at 0x00521952, 3 instruction(s), ends with je to 0x00521970 (forward)
    mov ecx, dword ptr [esi + field_58]          # 00521954
    test ecx, ecx                                # 00521957
    je.d8 L_00521970                             # 00521959
    # block 0x0052195b: entered by fall-through of je at 0x00521959, 8 instruction(s), calls indirect dword ptr [edx + 0x14], FUN_0050e936, falls into the block at 0x00521970
    mov edx, dword ptr [eax]                     # 0052195b
    push ecx                                     # 0052195d
    {load} mov ecx, eax                          # 0052195e
    call dword ptr [edx + field_14]              # 00521960
    push dword ptr [esi + field_58]              # 00521963
    call FUN_0050e936                            # 00521966
    and dword ptr [esi + field_58], 0x0          # 0052196b
    pop ecx                                      # 0052196f
L_00521970:
    # block 0x00521970: entered by je at 0x00521952; je at 0x00521959, 2 instruction(s), ends with ret
    pop esi                                      # 00521970
    ret                                          # 00521971

