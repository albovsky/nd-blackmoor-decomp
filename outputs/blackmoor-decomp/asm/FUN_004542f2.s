# FUN_004542f2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004542f2
# extent:       0x004542f2-0x0045432f (61 code bytes)
# span:         0x004542f2-0x0045432f (code 61, tables 0, padding 0)
# sha256:       c8308fc5d4a4b6286a26982345e8dfeaa21051207dafc3a9f0018bc38342e323
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004542f2
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [ecx + n] field_5a2
# callees:      calls FUN_004fb2e3
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_5a2, 0x5a2  # offset +0x5a2

# --- external targets -----------------------------------------------
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)

.org 0x004542f2 - 0x401000
.globl FUN_004542f2
FUN_004542f2:
    # block 0x004542f2: entry, 13 instruction(s), ends with je to 0x00454329 (forward)
    push ebp                                     # 004542f2
    {load} mov ebp, esp                          # 004542f3
    push ecx                                     # 004542f5
    push esi                                     # 004542f6
    push edi                                     # 004542f7
    mov dword ptr [ebp - local_4], ecx           # 004542f8
    mov edi, 0x549dec                            # 004542fb
    mov esi, dword ptr [ebp - local_4]           # 00454300
    add esi, 0x581                               # 00454303
    mov ecx, 0x9                                 # 00454309
    {load} xor eax, eax                          # 0045430e
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00454310
    je.d8 L_00454329                             # 00454312
    # block 0x00454314: entered by fall-through of je at 0x00454312, 5 instruction(s), calls FUN_004fb2e3, falls into the block at 0x00454329
    mov ecx, dword ptr [ebp - local_4]           # 00454314
    mov dx, word ptr [ecx + field_5a2]           # 00454317
    push edx                                     # 0045431e
    mov ecx, 0x5c3a67                            # 0045431f
    call FUN_004fb2e3                            # 00454324
L_00454329:
    # block 0x00454329: entered by je at 0x00454312, 5 instruction(s), ends with ret
    pop edi                                      # 00454329
    pop esi                                      # 0045432a
    {load} mov esp, ebp                          # 0045432b
    pop ebp                                      # 0045432d
    ret                                          # 0045432e

