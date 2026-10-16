# FUN_0051aacd
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051aacd
# extent:       0x0051aacd-0x0051aaf4 (39 code bytes)
# span:         0x0051aacd-0x0051aaf4 (code 39, tables 0, padding 0)
# sha256:       244930808862b354a49360293a8a685716dbbd1bd972f67957bce7df7b188c53
# evidence:     ev_af67c4288d6e639a00bd5dfa5ba373e106c1ca511fa16fda1eb070cac94bb18e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051aacd
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_c, field_18, field_minus_14; [edx + n] field_6c
# callees:      calls FUN_0051ec6f, FUN_0051f636; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 13 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
# note:         further_unindexed_code_at:0x0051aaf4
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_14, 0x14  # offset -0x14
.equ field_c, 0xc  # offset +0xc
.equ field_18, 0x18  # offset +0x18
.equ field_6c, 0x6c  # offset +0x6c

# --- external targets -----------------------------------------------
.set FUN_0051ec6f, .text + (0x0051ec6f - 0x401000)
.set FUN_0051f636, .text + (0x0051f636 - 0x401000)

.org 0x0051aacd - 0x401000
.globl FUN_0051aacd
FUN_0051aacd:
    # block 0x0051aacd: entry, 13 instruction(s), calls FUN_0051ec6f, indirect dword ptr [edx + 0x6c], FUN_0051f636, ends with ret
    call FUN_0051ec6f                            # 0051aacd
    mov ecx, dword ptr [ebp - field_minus_14]    # 0051aad2
    mov edx, dword ptr [eax]                     # 0051aad5
    add ecx, 0x34                                # 0051aad7
    push ecx                                     # 0051aada
    {load} mov ecx, eax                          # 0051aadb
    push dword ptr [ebp + field_c]               # 0051aadd
    call dword ptr [edx + field_6c]              # 0051aae0
    mov ecx, dword ptr [ebp + field_c]           # 0051aae3
    mov dword ptr [ebp + field_18], eax          # 0051aae6
    call FUN_0051f636                            # 0051aae9
    mov eax, 0x51aaf4                            # 0051aaee
    ret                                          # 0051aaf3

