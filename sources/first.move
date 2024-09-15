module addrx::First {
    use std::string::String;
    use std::signer;

    struct Message has key {
        message: String,
    }

    public entry fun create_message(account: &signer, msg: String) acquires Message {
        let signer_address = signer::address_of(account);

        if (!exists<Message>(signer_address)) {
            let message = Message {
                message: msg,
            };

            move_to(account, message);
        } else {
            let message = borrow_global_mut<Message>(signer_address);
            message.message = msg;
        }
    }

    #[test_only]
    use std::string::utf8;

    #[test(admin = @0x9000)]
    public entry fun test_flow(admin: &signer) acquires Message {
        aptos_framework::account::create_account_for_test(signer::address_of(admin));
        create_message(admin, utf8(b"The prince of all saiyans"));
        create_message(admin, utf8(b"Vegeta"));

        let message = borrow_global<Message>(signer::address_of(admin));
        assert!(message.message == utf8(b"Vegeta"), 10);
    }

}