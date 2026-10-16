# FUN_0048e26e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048e26e
# extent:       0x0048e26e-0x0048e28a (28 code bytes)
# span:         0x0048e26e-0x0048e28a (code 28, tables 0, padding 0)
# sha256:       8eed267b918b0d1529049c7772f65201ce075d575e52cf8d20fe377b2d60a0ca
# evidence:     ev_7981f36fcfb340c87ff1ac4ba66e833832bd1313751938cee07fade4f0082dcf
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0048e26e
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

.org 0x0048e26e - 0x401000
.globl FUN_0048e26e
FUN_0048e26e:
    # block 0x0048e26e: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 0048e26e
    {load} mov ebp, esp                          # 0048e26f
    push ecx                                     # 0048e271
    mov dword ptr [ebp - local_4], ecx           # 0048e272
    mov eax, dword ptr [ebp - local_4]           # 0048e275
    mov dword ptr [eax], 0x52da70                # 0048e278
    mov ecx, dword ptr [ebp - local_4]           # 0048e27e
    call FUN_0051d730                            # 0048e281
    {load} mov esp, ebp                          # 0048e286
    pop ebp                                      # 0048e288
    ret                                          # 0048e289

