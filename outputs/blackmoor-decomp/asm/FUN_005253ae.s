# FUN_005253ae
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005253ae
# extent:       0x005253ae-0x005253e3 (53 code bytes)
# span:         0x005253ae-0x005253e3 (code 53, tables 0, padding 0)
# sha256:       1c785a1fd9a9e6b913b1ab20e8eea80c3c4e440f7bacb56a85155d1fb7dbfb43
# evidence:     ev_2c715b3bd3208197e01b2ebef20c92856fcb381a668a9ff837ea142d14b02822
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         CTypeLibCache::Unlock
# naming:       Ghidra name from function-index.json (not re-derived here)
# name-note:    Statically linked library routine named by Ghidra; the body was not read for intent here
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_8; [esi + n] field_8, field_1c, field_20
# callees:      calls KERNEL32.dll!InterlockedDecrement; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; indirect transfers are not followed
# note:         further_unindexed_code_at:0x005253e3
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_8, 0x8  # offset +0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------

.org 0x005253ae - 0x401000
.globl FUN_005253ae
FUN_005253ae:
    # block 0x005253ae: entry, 7 instruction(s), calls KERNEL32.dll!InterlockedDecrement, ends with jne to 0x005253e1 (forward)
    push esi                                     # 005253ae
    {load} mov esi, ecx                          # 005253af
    lea eax, [esi + field_20]                    # 005253b1
    push eax                                     # 005253b4
    call dword ptr [0x52a1fc]                    # 005253b5
    test eax, eax                                # 005253bb
    jne.d8 L_005253e1                            # 005253bd
    # block 0x005253bf: entered by fall-through of jne at 0x005253bd, 3 instruction(s), ends with je to 0x005253d0 (forward)
    mov eax, dword ptr [esi + field_1c]          # 005253bf
    test eax, eax                                # 005253c2
    je.d8 L_005253d0                             # 005253c4
    # block 0x005253c6: entered by fall-through of je at 0x005253c4, 4 instruction(s), calls indirect dword ptr [ecx + 0x8], falls into the block at 0x005253d0
    mov ecx, dword ptr [eax]                     # 005253c6
    push eax                                     # 005253c8
    call dword ptr [ecx + field_8]               # 005253c9
    and dword ptr [esi + field_1c], 0x0          # 005253cc
L_005253d0:
    # block 0x005253d0: entered by je at 0x005253c4, 3 instruction(s), ends with je to 0x005253e1 (forward)
    mov eax, dword ptr [esi + field_8]           # 005253d0
    test eax, eax                                # 005253d3
    je.d8 L_005253e1                             # 005253d5
    # block 0x005253d7: entered by fall-through of je at 0x005253d5, 4 instruction(s), calls indirect dword ptr [ecx + 0x8], falls into the block at 0x005253e1
    mov ecx, dword ptr [eax]                     # 005253d7
    push eax                                     # 005253d9
    call dword ptr [ecx + field_8]               # 005253da
    and dword ptr [esi + field_8], 0x0           # 005253dd
L_005253e1:
    # block 0x005253e1: entered by jne at 0x005253bd; je at 0x005253d5, 2 instruction(s), ends with ret
    pop esi                                      # 005253e1
    ret                                          # 005253e2

