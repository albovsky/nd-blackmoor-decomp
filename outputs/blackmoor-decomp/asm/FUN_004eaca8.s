# FUN_004eaca8
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004eaca8
# extent:       0x004eaca8-0x004ead69 (193 code bytes)
# span:         0x004eaca8-0x004ead69 (code 193, tables 0, padding 0)
# sha256:       4a379295e79821dcff8a9f2f2d74b963db234ffdb9427ede72f38adb2e567236
# evidence:     ev_e731b644a5c720787f42bc3e741b2e19c9bb1b49c397d136b9ddf0255f267052
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_inventory_examine_action_handler
# naming:       INFERRED (lower confidence, not verified): the repository text src/inventory_examine_runtime.h:18 says "the action handler 0x4eaca8 (item"; tasks/RT-43-inventory-examine-runtime.md:38 says "The action handler `0x4eaca8` (second caller, item and take from the row, sound 0)"
# name-note:    Action handler that calls the inventory examine step with item and take from the row, sound 0.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [ecx + n] field_2, field_77e, field_780
# callees:      calls FUN_004ea269
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 48 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_2, 0x2  # offset +0x2
.equ arg_8, 0x8  # offset +0x8
.equ field_77e, 0x77e  # offset +0x77e
.equ field_780, 0x780  # offset +0x780

# --- external targets -----------------------------------------------
.set FUN_004ea269, .text + (0x004ea269 - 0x401000)

.org 0x004eaca8 - 0x401000
.globl FUN_004eaca8
FUN_004eaca8:
    # block 0x004eaca8: entry, 20 instruction(s), ends with jne to 0x004ead52 (forward)
    push ebp                                     # 004eaca8
    {load} mov ebp, esp                          # 004eaca9
    sub esp, 0xc                                 # 004eacab
    mov dword ptr [ebp - local_c], ecx           # 004eacae
    movsx eax, word ptr [ebp + arg_8]            # 004eacb1
    imul eax, eax, 0x8d                          # 004eacb5
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004eacbb
    mov dx, word ptr [ecx]                       # 004eacc1
    mov word ptr [ebp - local_4], dx             # 004eacc4
    movsx eax, word ptr [ebp + arg_8]            # 004eacc8
    imul eax, eax, 0x8d                          # 004eaccc
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004eacd2
    mov dx, word ptr [ecx + field_2]             # 004eacd8
    mov word ptr [ebp - local_8], dx             # 004eacdc
    movsx eax, word ptr [ebp - local_4]          # 004eace0
    imul eax, eax, 0x16d                         # 004eace4
    mov ecx, dword ptr [ebp - local_c]           # 004eacea
    movsx edx, word ptr [ecx + eax + field_77e]  # 004eaced
    cmp edx, 0x3                                 # 004eacf5
    jne.d8 L_004ead52                            # 004eacf8
    # block 0x004eacfa: entered by fall-through of jne at 0x004eacf8, 6 instruction(s), ends with je to 0x004ead52 (forward)
    movsx eax, word ptr [ebp - local_4]          # 004eacfa
    imul eax, eax, 0x16d                         # 004eacfe
    mov ecx, dword ptr [ebp - local_c]           # 004ead04
    movsx edx, word ptr [ecx + eax + field_780]  # 004ead07
    test edx, edx                                # 004ead0f
    je.d8 L_004ead52                             # 004ead11
    # block 0x004ead13: entered by fall-through of je at 0x004ead11, 6 instruction(s), ends with je to 0x004ead52 (forward)
    movsx eax, word ptr [ebp - local_4]          # 004ead13
    imul eax, eax, 0x16d                         # 004ead17
    mov ecx, dword ptr [ebp - local_c]           # 004ead1d
    movsx edx, word ptr [ecx + eax + field_780]  # 004ead20
    cmp edx, 0x270f                              # 004ead28
    je.d8 L_004ead52                             # 004ead2e
    # block 0x004ead30: entered by fall-through of je at 0x004ead2e, 3 instruction(s), ends with jne to 0x004ead52 (forward)
    movsx eax, word ptr [ebp - local_4]          # 004ead30
    cmp dword ptr [4*eax + 0x583ced], 0x0        # 004ead34
    jne.d8 L_004ead52                            # 004ead3c
    # block 0x004ead3e: entered by fall-through of jne at 0x004ead3c, 7 instruction(s), calls FUN_004ea269, falls into the block at 0x004ead52
    push 0x0                                     # 004ead3e
    mov cx, word ptr [ebp - local_8]             # 004ead40
    push ecx                                     # 004ead44
    mov dx, word ptr [ebp - local_4]             # 004ead45
    push edx                                     # 004ead49
    mov ecx, dword ptr [ebp - local_c]           # 004ead4a
    call FUN_004ea269                            # 004ead4d
L_004ead52:
    # block 0x004ead52: entered by jne at 0x004eacf8; je at 0x004ead11; je at 0x004ead2e; jne at 0x004ead3c, 6 instruction(s), ends with ret 0x4
    movsx eax, word ptr [ebp + arg_8]            # 004ead52
    imul eax, eax, 0x8d                          # 004ead56
    mov byte ptr [eax + 0x5bb625], 0x1           # 004ead5c
    {load} mov esp, ebp                          # 004ead63
    pop ebp                                      # 004ead65
    ret 0x4                                      # 004ead66

