module addrx::Counter {
    use std::signer;

    struct Counter has key {
        count: u64,
    }

    public entry fun initalize(account: &signer) {
        let signer_address = signer::address_of(account);

        if (!exists<Counter>(signer_address)) {
            let counter = Counter {
                count: 0
            };

            move_to(account,counter);
        } 
    }

    public entry fun increment(account: &signer) acquires Counter {
        let signer_address = signer::address_of(account);
        let counter = borrow_global_mut<Counter>(signer_address);
        counter.count = counter.count + 1;
    }

    #[test(admin = @0x9000)]
    public entry fun test_counter(admin: &signer) acquires Counter {
        aptos_framework::account::create_account_for_test(signer::address_of(admin));
        initalize(admin);
        increment(admin);
        let counter = borrow_global<Counter>(signer::address_of(admin));
        assert!(counter.count == 1, 1);
    }
}