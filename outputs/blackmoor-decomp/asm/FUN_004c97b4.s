# FUN_004c97b4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c97b4
# extent:       0x004c97b4-0x004c9805 (81 code bytes)
# span:         0x004c97b4-0x004c9805 (code 81, tables 0, padding 0)
# sha256:       3a3ce61456f41f3d52d744f0aa4870e4caadc0b704ac034e03916ad30717edc2
# evidence:     ev_d590aeb62d3bd1e1413a3f3e4f07f565aba52ab8fd98207292a76569576fbcb9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004c97b4
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050ca3e, FUN_0043d7c4, USER32.dll!PostQuitMessage
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0043d7c4, .text + (0x0043d7c4 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004c97b4 - 0x401000
.globl FUN_004c97b4
FUN_004c97b4:
    # block 0x004c97b4: entry, 6 instruction(s), ends with je to 0x004c97f5 (forward)
    push ebp                                     # 004c97b4
    {load} mov ebp, esp                          # 004c97b5
    push ecx                                     # 004c97b7
    mov dword ptr [ebp - local_4], ecx           # 004c97b8
    cmp dword ptr [0x63a4d9], 0x0                # 004c97bb
    je.d8 L_004c97f5                             # 004c97c2
    # block 0x004c97c4: entered by fall-through of je at 0x004c97c2, 2 instruction(s), ends with je to 0x004c97f5 (forward)
    cmp dword ptr [0x63a4f1], 0x0                # 004c97c4
    je.d8 L_004c97f5                             # 004c97cb
    # block 0x004c97cd: entered by fall-through of je at 0x004c97cb, 2 instruction(s), ends with je to 0x004c97f5 (forward)
    cmp dword ptr [0x63a58a], 0x0                # 004c97cd
    je.d8 L_004c97f5                             # 004c97d4
    # block 0x004c97d6: entered by fall-through of je at 0x004c97d4, 7 instruction(s), calls FUN_0050ca3e, FUN_0043d7c4, falls into the block at 0x004c97f5
    push 0x557b78                                # 004c97d6
    push 0x63888b                                # 004c97db
    call FUN_0050ca3e                            # 004c97e0
    add esp, 0x8                                 # 004c97e5
    push 0x63888b                                # 004c97e8
    call FUN_0043d7c4                            # 004c97ed
    add esp, 0x4                                 # 004c97f2
L_004c97f5:
    # block 0x004c97f5: entered by je at 0x004c97c2; je at 0x004c97cb; je at 0x004c97d4, 6 instruction(s), calls USER32.dll!PostQuitMessage, ends with ret
    mov eax, dword ptr [0x63a58a]                # 004c97f5
    push eax                                     # 004c97fa
    call dword ptr [0x52a48c]                    # 004c97fb
    {load} mov esp, ebp                          # 004c9801
    pop ebp                                      # 004c9803
    ret                                          # 004c9804

