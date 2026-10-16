# FUN_0047e23e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047e23e
# extent:       0x0047e23e-0x0047e25a (28 code bytes)
# span:         0x0047e23e-0x0047e25a (code 28, tables 0, padding 0)
# sha256:       e5759f4ef775c4713a4c108fdda201140e24b79e03c38afdf61ddcfe8f33eca2
# evidence:     ev_d92d6876f912287d796d65b7f2d0c60600fa32141855ab3fd7de0798df4ef618
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0047e23e
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d730
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x0047e23e - 0x401000
.globl FUN_0047e23e
FUN_0047e23e:
    # block 0x0047e23e: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 0047e23e
    {load} mov ebp, esp                          # 0047e23f
    push ecx                                     # 0047e241
    mov dword ptr [ebp - local_4], ecx           # 0047e242
    mov eax, dword ptr [ebp - local_4]           # 0047e245
    mov dword ptr [eax], 0x52d630                # 0047e248
    mov ecx, dword ptr [ebp - local_4]           # 0047e24e
    call FUN_0051d730                            # 0047e251
    {load} mov esp, ebp                          # 0047e256
    pop ebp                                      # 0047e258
    ret                                          # 0047e259

