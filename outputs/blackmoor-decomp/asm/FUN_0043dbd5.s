# FUN_0043dbd5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043dbd5
# extent:       0x0043dbd5-0x0043dbe3 (14 code bytes)
# span:         0x0043dbd5-0x0043dbe3 (code 14, tables 0, padding 0)
# sha256:       598507c387a08f61f186aa33bed364cdb4cddb3beb7b2f3638e7743017833ba3
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# name:         <unfilled>
# arguments:    <unfilled>
# locals:       <unfilled>
# fields:       <unfilled>
# callees:      <unfilled>
# track-n:      <unfilled>
# unverified:   <unfilled>
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x0043dbd5 - 0x401000
.globl FUN_0043dbd5
FUN_0043dbd5:
    # block 0x0043dbd5: <unfilled>
    push ebp                                     # 0043dbd5
    {load} mov ebp, esp                          # 0043dbd6
    mov word ptr [0x5bb1c4], 0x1                 # 0043dbd8
    pop ebp                                      # 0043dbe1
    ret                                          # 0043dbe2
