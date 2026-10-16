# FUN_0050dc82
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050dc82
# extent:       0x0050dc82-0x0050dcb0 (46 code bytes)
# span:         0x0050dc82-0x0050dcb0 (code 46, tables 0, padding 0)
# sha256:       35c711ecf3418b8f37b80b7f72b9dd433b6d46dbca883c2f5f5922e7efff5f17
# evidence:     ev_4d268ec7993df48128cba5d0df1108836b8002175a429e70814bf1b72161879f
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050dc82
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_d, field_10; [esp + n] stk_8
# callees:      calls FUN_0050dcb0, FUN_00513236
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 22 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_d, 0xd  # offset +0xd
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0050dcb0, .text + (0x0050dcb0 - 0x401000)
.set FUN_00513236, .text + (0x00513236 - 0x401000)

.org 0x0050dc82 - 0x401000
.globl FUN_0050dc82
FUN_0050dc82:
    # block 0x0050dc82: entry, 7 instruction(s), calls FUN_0050dcb0, ends with je to 0x0050dc97 (forward)
    push esi                                     # 0050dc82
    mov esi, dword ptr [esp + stk_8]             # 0050dc83
    push esi                                     # 0050dc87
    call FUN_0050dcb0                            # 0050dc88
    test eax, eax                                # 0050dc8d
    pop ecx                                      # 0050dc8f
    je.d8 L_0050dc97                             # 0050dc90
    # block 0x0050dc92: entered by fall-through of je at 0x0050dc90, 3 instruction(s), ends with ret
    or eax, -0x1                                 # 0050dc92
    pop esi                                      # 0050dc95
    ret                                          # 0050dc96
L_0050dc97:
    # block 0x0050dc97: entered by je at 0x0050dc90, 2 instruction(s), ends with je to 0x0050dcac (forward)
    test byte ptr [esi + field_d], 0x40          # 0050dc97
    je.d8 L_0050dcac                             # 0050dc9b
    # block 0x0050dc9d: entered by fall-through of je at 0x0050dc9b, 7 instruction(s), calls FUN_00513236, ends with ret
    push dword ptr [esi + field_10]              # 0050dc9d
    call FUN_00513236                            # 0050dca0
    neg eax                                      # 0050dca5
    pop ecx                                      # 0050dca7
    pop esi                                      # 0050dca8
    {load} sbb eax, eax                          # 0050dca9
    ret                                          # 0050dcab
L_0050dcac:
    # block 0x0050dcac: entered by je at 0x0050dc9b, 3 instruction(s), ends with ret
    {load} xor eax, eax                          # 0050dcac
    pop esi                                      # 0050dcae
    ret                                          # 0050dcaf

