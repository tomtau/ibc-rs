---- MODULE IBC ----

EXTENDS Integers, FiniteSets

(*

PLAN:
    - For every step, choose a chain to run a method on and advance by one block
    - The chain will advance whether or not the method has errored
    - 
*)