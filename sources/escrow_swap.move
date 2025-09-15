#[allow(lint(public_entry))]
module walscribe::escrow_swap;


    use sui::tx_context::{sender};
    use sui::dynamic_object_field as dof;
    use sui::event;

    const EMismatchSenderAndRecipient: u64 = 0;
    const EMismatchExchangeObject: u64 = 1;
    const ELockKeyMismatch: u64 = 2;


    #[allow(unused_type_parameter)]
    public entry fun create_key<T: store>(
        _key: ID,
        _ctx: &mut TxContext
    ) {
        // No destructuring needed, just use the key parameter as is
    }
    public struct Locked<T: store> has key, store {
        id: UID,
        _key: ID,
        obj: T,
    }

    public struct Key<phantom T: store> has key, store {
        id: UID,
        key: ID,
    }

    public struct LockDestroyed has drop, copy, store {
        lock_id: ID,
    }

    public struct LockedObjectKey has copy, drop, store {
    }

    public struct Vault<T: key + store>has key, store{
        id: UID,
        owner_exchange_key: ID,
        asset: T,
        owner_address: address,
    }

    public struct Escrow<T: key + store> has key {
        id: UID,
        sender: address,
        recipient: address,
        recipient_exchange_key: ID,
        /// The ID of the key that locked the escrowed object, before it was escrowed.
        escrowed_key: ID,
        object_escrowed: T,
    }

    public struct EscrowEvent has copy, drop {
        exchange_key: ID,
        sender: address,
        recipient: address,
        object_escrowed: ID,
    }

    public struct EscrowCreated has copy, drop {
        escrow_id: ID,
        key_id: ID,
        sender: address,
        recipient: address,
        object_escrowed: ID,
    }


    public struct VaultEvent<T: copy + store> has copy, drop {
        asset: T,
        owner_address: address,
    }

    public entry fun create_vault<T: copy + store + drop>(
        asset: T,
        owner_address: address,
        ctx: &mut TxContext,
    ){
        let vault = VaultEvent {
            asset: Coin<SUI>,
            owner_address: ctx.sender(),
        }; 

        event::emit(VaultEvent {
            asset,
            owner_address,
        });
    }

    public entry fun create_escrow<T: store + key>(
        object_escrow: T,
        exchange_key: ID,
        recipient: address,
        ctx: &mut TxContext,
    )  {
        let mut escrow = EscrowEvent {
            object_escrowed: escrow_event.object_escrowed,
            sender: ctx.sender(),
            recipient,
            exchange_key,
        };

        event::emit(EscrowCreated {
            escrow_id: escrow_id,
            key_id: exchange_key,
            sender: escrow.sender,
            recipient: recipient,
            object_escrowed: object::id(&object_escrow),
        });
    }  
    

    public fun create_locked<T: store>(
        key: ID,
        obj: T,
        ctx: &mut TxContext
    ): Locked<T> {
        Locked {
            id: object::new(ctx),
            _key: key,
            obj
        }
    }

    // public entry fun create_vault<T: key + store + drop>(
    //     key: Key<T>,
    //     locked: Locked<T>,
    //     owner_exchange_key: ID,
    //     asset: T,
    //     owner_address: address,
    //     ctx: &mut TxContext,
    // ) {
    //     let vault = Vault {
    //         id: object::new(ctx),
    //         owner_exchange_key: owner_exchange_key,
    //         asset: unlock(locked, key),
    //         owner_address,
    //     };
    //     transfer::transfer(vault, owner_address);
    // }

    public fun create<T: key + store + drop>(
        key: Key<T>,
        locked: Locked<T>,
        recipient_exchange_key: ID,
        recipient: address,
        verifier: address,
        ctx: &mut TxContext,
    ) {
        let escrow = Escrow {
            id: object::new(ctx),
            sender: ctx.sender(),
            recipient,
            recipient_exchange_key: recipient_exchange_key,
            escrowed_key: object::id(&key),
            object_escrowed: unlock(locked, key),   
        };
        transfer::transfer(escrow, verifier);
    }

    public fun unlock<T: key + store + drop>(mut locked: Locked<T>, key: Key<T>): T {
    assert!(locked._key == object::id(&key), ELockKeyMismatch);
        let Key { id, key: _ } = key;
        id.delete();

        let _obj = dof::remove<LockedObjectKey, T>(&mut locked.id, LockedObjectKey {});

        event::emit(LockDestroyed { lock_id: object::id(&locked) });

        let Locked { id, _key, obj } = locked;
        id.delete();
        obj
    }

    /// Function for custodian (trusted third-party) to perform a swap between
    /// two parties.  Fails if their senders and recipients do not match, or if
    /// their respective desired objects do not match.
    public fun swap<T: key + store, U: key + store>(owner: Escrow<T>, recipient: Escrow<U>) {
        let Escrow {
            id: id1,
            sender: sender1,
            recipient: recipient1,
            recipient_exchange_key: exchange_key1,
            escrowed_key: escrowed_key1,
            object_escrowed: escrowed1,
        } = owner;

        let Escrow {
            id: id2,
            sender: sender2,
            recipient: recipient2,
            recipient_exchange_key: exchange_key2,
            escrowed_key: escrowed_key2,
            object_escrowed: escrowed2,
        } = recipient;
        id1.delete();
        id2.delete();

        // Make sure the sender and recipient match each other
        assert!(sender1 == recipient2, EMismatchSenderAndRecipient);
        assert!(sender2 == recipient1, EMismatchSenderAndRecipient);

        // Make sure the objects match each other and haven't been modified (they remain locked).
        assert!(escrowed_key1 == exchange_key2, EMismatchExchangeObject);
        assert!(escrowed_key2 == exchange_key1, EMismatchExchangeObject);

        // Do the actual swap
        transfer::public_transfer(escrowed1, recipient1);
        transfer::public_transfer(escrowed2, recipient2);
    }

    /// The custodian can always return an escrowed object to its original owner.
    public fun return_to_sender<T: key + store>(obj: Escrow<T>) {
        let Escrow {
            id,
            sender,
            recipient: _,
            recipient_exchange_key: _,
            escrowed_key: _escrowed_key,
            object_escrowed: object_escrowed,
        } = obj;
        id.delete();
        transfer::public_transfer(object_escrowed, sender);
    }

    // Alice locks the object they want to trade
