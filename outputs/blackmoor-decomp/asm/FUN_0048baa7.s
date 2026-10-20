# FUN_0048baa7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048baa7
# extent:       0x0048baa7-0x0048bafb (84 code bytes)
# span:         0x0048baa7-0x0048bafb (code 84, tables 0, padding 0)
# sha256:       48685dc7ee04827b89cf7edec886567211329c8eaa0022b79e720a26db837b04
# evidence:     ev_b5201f38a5a659d5112bf314de75bb76652baa2f4916443e3ea7357100fb9b00
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_peephole_object_constructor
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_d8_runtime.h:21 says "0x48bb17 reset (constructor 0x48baa7)"
# name-note:    Constructor of the raw 0xd8 Peephole object, which calls the reset 0x48bb17.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_0048bb17
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0048bb17, .text + (0x0048bb17 - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x0048baa7 - 0x401000
.globl FUN_0048baa7
FUN_0048baa7:
    # block 0x0048baa7: entry, 23 instruction(s), calls FUN_0051d716, FUN_0048bb17, ends with ret
    push ebp                                     # 0048baa7
    {load} mov ebp, esp                          # 0048baa8
    push -0x1                                    # 0048baaa
    push 0x52849d                                # 0048baac
    mov eax, dword ptr fs:[0x0]                  # 0048bab1
    push eax                                     # 0048bab7
    mov dword ptr fs:[0x0], esp                  # 0048bab8
    push ecx                                     # 0048babf
    mov dword ptr [ebp - local_10], ecx          # 0048bac0
    mov ecx, dword ptr [ebp - local_10]          # 0048bac3
    call FUN_0051d716                            # 0048bac6
    mov dword ptr [ebp - local_4], 0x0           # 0048bacb
    mov eax, dword ptr [ebp - local_10]          # 0048bad2
    mov dword ptr [eax], 0x52d960                # 0048bad5
    mov ecx, dword ptr [ebp - local_10]          # 0048badb
    call FUN_0048bb17                            # 0048bade
    mov dword ptr [ebp - local_4], 0xffffffff    # 0048bae3
    mov eax, dword ptr [ebp - local_10]          # 0048baea
    mov ecx, dword ptr [ebp - local_c]           # 0048baed
    mov dword ptr fs:[0x0], ecx                  # 0048baf0
    {load} mov esp, ebp                          # 0048baf7
    pop ebp                                      # 0048baf9
    ret                                          # 0048bafa

