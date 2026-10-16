# FUN_0043eab0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043eab0
# extent:       0x0043eab0-0x0043eb1a (106 code bytes)
# span:         0x0043eab0-0x0043eb1a (code 106, tables 0, padding 0)
# sha256:       b310a0585b8eda7efd88af84a35070bbcc4569cc96aff0df6321c595e17880c3
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0043eab0
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0043eb3a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 29 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18

# --- external targets -----------------------------------------------
.set FUN_0043eb3a, .text + (0x0043eb3a - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x0043eab0 - 0x401000
.globl FUN_0043eab0
FUN_0043eab0:
    # block 0x0043eab0: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x0043eaf5 (forward)
    push ebp                                     # 0043eab0
    {load} mov ebp, esp                          # 0043eab1
    push -0x1                                    # 0043eab3
    push 0x527eaa                                # 0043eab5
    mov eax, dword ptr fs:[0x0]                  # 0043eaba
    push eax                                     # 0043eac0
    mov dword ptr fs:[0x0], esp                  # 0043eac1
    sub esp, 0xc                                 # 0043eac8
    push 0xbc                                    # 0043eacb
    call FUN_0051dc43                            # 0043ead0
    add esp, 0x4                                 # 0043ead5
    mov dword ptr [ebp - local_14], eax          # 0043ead8
    mov dword ptr [ebp - local_4], 0x0           # 0043eadb
    cmp dword ptr [ebp - local_14], 0x0          # 0043eae2
    je.d8 L_0043eaf5                             # 0043eae6
    # block 0x0043eae8: entered by fall-through of je at 0x0043eae6, 4 instruction(s), calls FUN_0043eb3a, ends with forward jump to 0x0043eafc
    mov ecx, dword ptr [ebp - local_14]          # 0043eae8
    call FUN_0043eb3a                            # 0043eaeb
    mov dword ptr [ebp - local_18], eax          # 0043eaf0
    jmp.d8 L_0043eafc                            # 0043eaf3
L_0043eaf5:
    # block 0x0043eaf5: entered by je at 0x0043eae6, 1 instruction(s), falls into the block at 0x0043eafc
    mov dword ptr [ebp - local_18], 0x0          # 0043eaf5
L_0043eafc:
    # block 0x0043eafc: entered by jmp at 0x0043eaf3, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 0043eafc
    mov dword ptr [ebp - local_10], eax          # 0043eaff
    mov dword ptr [ebp - local_4], 0xffffffff    # 0043eb02
    mov eax, dword ptr [ebp - local_10]          # 0043eb09
    mov ecx, dword ptr [ebp - local_c]           # 0043eb0c
    mov dword ptr fs:[0x0], ecx                  # 0043eb0f
    {load} mov esp, ebp                          # 0043eb16
    pop ebp                                      # 0043eb18
    ret                                          # 0043eb19

