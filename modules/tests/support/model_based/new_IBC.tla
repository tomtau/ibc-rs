---- MODULE IBC ----

EXTENDS Integers, FiniteSets

(* @typeAlias: HEIGHT = [
        revisionNumber: Int,
        revisionHeight: Int
    ]; 
*)
(* @typeAlias: HEADER = [
        chainId: Str,
        height: HEIGHT,
        action: 
    ];
*)
(* @typeAlias: CHAIN = [
        height: HEIGHT,
        clients: Int -> CLIENT,
        clientIdCounter: Int,
        connections: Int -> CONNECTION,
        connectionIdCounter: Int,
        connectionProofs: Set(ACTION)
    ];
*)
EXTypeAliases = TRUE

VARIABLES
    \* This is only ever intended to have one header in it.
    \* The set is being used as sort of an Option type.
    \* @type: Set(HEADER);
    headers,

    \* @type: Str -> CHAIN;
    chains,

    \* @type: Str;
    outcome
(*

PLAN:
    - For every step, choose a chain to run a method on and advance by one block
    - The chain will advance whether or not the method has errored
    - If the method produces a message for the other chain, add it to messages set
    - If the method can only be triggered in response to a message from the other chain, run it with a message from the messages set
    - Find some way to inject invalid and out of order messages without trying every possible combination of messages
*)

ChainIds == { "chainA", "chainB" }

\* @type: (Str) => Str
OtherChainId(chainId) ==
    IF chainId = "chainA":
        "chainB"
    ELSE
        "chainA"

CreateClient(chain, header) ==
    

\* retrieves `clientId`'s data
\* @type: ((Int -> CLIENT), Int) => CLIENT;
ICS02_GetClient(clients, clientId) ==
    clients[clientId]

\* check if `clientId` exists
\* @type: ((Int -> CLIENT), Int) => Bool;
ICS02_ClientExists(clients, clientId) ==
    ICS02_GetClient(clients, clientId).heights /= AsSetInt({})

\* update `clientId`'s data
\* @type: ((Int -> CLIENT), Int, CLIENT) => (Int -> CLIENT);
ICS02_SetClient(clients, clientId, client) ==
    [clients EXCEPT ![clientId] = client]

ICS02_CreateClient(chain, chainId, header) ==
    \* check if the client exists (it shouldn't)
    IF ICS02_ClientExists(chain.clients, chain.clientIdCounter) THEN
        \* if the client to be created already exists,
        \* then there's an error in the model
        outcome' = "ModelError"
    ELSE
        outcome' = "Ics02CreateOk"
        chains' = [chains EXCEPT ![chainId] = chain]

Next ==
    \E header in headers:
        LET chainId == OtherChainId(header.chainId) IN
        LET chain == chains[chainId] IN
            \/  



