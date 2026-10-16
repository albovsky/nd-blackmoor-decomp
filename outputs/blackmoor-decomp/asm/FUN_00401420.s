# FUN_00401420
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00401420
# extent:       0x00401420-0x0040148a (106 code bytes)
# span:         0x00401420-0x0040148a (code 106, tables 0, padding 0)
# sha256:       6a4840dd9c60382f96774874045bc28377ecd268b8b57be53ca22ccd7c065196
# evidence:     ev_5101d3157a7cceecfaf0c751ae06a21a7013310d21b12b5f59cdca7af1ddb679
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00401420
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0040149a
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
.set FUN_0040149a, .text + (0x0040149a - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00401420 - 0x401000
.globl FUN_00401420
FUN_00401420:
    # block 0x00401420: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x00401465 (forward)
    push ebp                                     # 00401420
    {load} mov ebp, esp                          # 00401421
    push -0x1                                    # 00401423
    push 0x526aca                                # 00401425
    mov eax, dword ptr fs:[0x0]                  # 0040142a
    push eax                                     # 00401430
    mov dword ptr fs:[0x0], esp                  # 00401431
    sub esp, 0xc                                 # 00401438
    push 0x8c                                    # 0040143b
    call FUN_0051dc43                            # 00401440
    add esp, 0x4                                 # 00401445
    mov dword ptr [ebp - local_14], eax          # 00401448
    mov dword ptr [ebp - local_4], 0x0           # 0040144b
    cmp dword ptr [ebp - local_14], 0x0          # 00401452
    je.d8 L_00401465                             # 00401456
    # block 0x00401458: entered by fall-through of je at 0x00401456, 4 instruction(s), calls FUN_0040149a, ends with forward jump to 0x0040146c
    mov ecx, dword ptr [ebp - local_14]          # 00401458
    call FUN_0040149a                            # 0040145b
    mov dword ptr [ebp - local_18], eax          # 00401460
    jmp.d8 L_0040146c                            # 00401463
L_00401465:
    # block 0x00401465: entered by je at 0x00401456, 1 instruction(s), falls into the block at 0x0040146c
    mov dword ptr [ebp - local_18], 0x0          # 00401465
L_0040146c:
    # block 0x0040146c: entered by jmp at 0x00401463, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 0040146c
    mov dword ptr [ebp - local_10], eax          # 0040146f
    mov dword ptr [ebp - local_4], 0xffffffff    # 00401472
    mov eax, dword ptr [ebp - local_10]          # 00401479
    mov ecx, dword ptr [ebp - local_c]           # 0040147c
    mov dword ptr fs:[0x0], ecx                  # 0040147f
    {load} mov esp, ebp                          # 00401486
    pop ebp                                      # 00401488
    ret                                          # 00401489

