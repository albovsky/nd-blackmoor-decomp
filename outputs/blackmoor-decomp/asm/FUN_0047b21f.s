# FUN_0047b21f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047b21f
# extent:       0x0047b21f-0x0047b23b (28 code bytes)
# span:         0x0047b21f-0x0047b23b (code 28, tables 0, padding 0)
# sha256:       0db796d4ba6fcb415551677764c47672325fd140f815f4c49f974980035b75e8
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0047b21f
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0047b321
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0047b321, .text + (0x0047b321 - 0x401000)

.org 0x0047b21f - 0x401000
.globl FUN_0047b21f
FUN_0047b21f:
    # block 0x0047b21f: entry, 11 instruction(s), calls FUN_0047b321, ends with ret
    push ebp                                     # 0047b21f
    {load} mov ebp, esp                          # 0047b220
    push ecx                                     # 0047b222
    mov dword ptr [ebp - local_4], ecx           # 0047b223
    mov eax, dword ptr [ebp - local_4]           # 0047b226
    mov dword ptr [eax], 0x52d568                # 0047b229
    mov ecx, dword ptr [ebp - local_4]           # 0047b22f
    call FUN_0047b321                            # 0047b232
    {load} mov esp, ebp                          # 0047b237
    pop ebp                                      # 0047b239
    ret                                          # 0047b23a

