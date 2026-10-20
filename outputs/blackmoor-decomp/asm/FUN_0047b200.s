# FUN_0047b200
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047b200
# extent:       0x0047b200-0x0047b21f (31 code bytes)
# span:         0x0047b200-0x0047b21f (code 31, tables 0, padding 0)
# sha256:       afff28070eb76b395ab88292f4f2964cb884aa1171a1aa0a8cd8ea9364e7027d
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_memory_puzzle_constructor
# naming:       INFERRED (lower confidence, not verified): the repository text tasks/RT-60-memory-puzzle-ee-runtime.md:18 says "`0x47b200` | constructor (startup call `0x426834`)"
# name-note:    Constructor of the raw 0xee Memory puzzle object (startup call), setting the vtable then resetting.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0047b23b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 12 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0047b23b, .text + (0x0047b23b - 0x401000)

.org 0x0047b200 - 0x401000
.globl FUN_0047b200
FUN_0047b200:
    # block 0x0047b200: entry, 12 instruction(s), calls FUN_0047b23b, ends with ret
    push ebp                                     # 0047b200
    {load} mov ebp, esp                          # 0047b201
    push ecx                                     # 0047b203
    mov dword ptr [ebp - local_4], ecx           # 0047b204
    mov eax, dword ptr [ebp - local_4]           # 0047b207
    mov dword ptr [eax], 0x52d568                # 0047b20a
    mov ecx, dword ptr [ebp - local_4]           # 0047b210
    call FUN_0047b23b                            # 0047b213
    mov eax, dword ptr [ebp - local_4]           # 0047b218
    {load} mov esp, ebp                          # 0047b21b
    pop ebp                                      # 0047b21d
    ret                                          # 0047b21e

