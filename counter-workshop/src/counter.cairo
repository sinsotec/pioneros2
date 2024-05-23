#[starknet::interface]
trait ICounter<TContractState> {
    fn get_counter (self: @TContractState ) -> u32;
    fn increase_counter (ref self:TContractState);
}

#[starknet::contract]
mod Counter {
    use super::ICounter;
    use starknet::ContractAddress;

    use kill_switch::IKillSwitchDispatcherTrait;
    use kill_switch::IKillSwitchDispatcher;
    
    #[storage]
    struct Storage {
        counter: u32,
        kill_switch: IKillSwitchDispatcher,
    }

    #[derive(Drop, starknet::Event)]
    struct CounterIncreased {
        counter: u32,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        CounterIncreased : CounterIncreased,
    }

    #[constructor]
    fn constructor(ref self: ContractState, initialCounter: u32, kill_switch_address: ContractAddress) {
        self.counter.write(initialCounter);
        self.kill_switch.write(IKillSwitchDispatcher {contract_address: kill_switch_address});
    }

    #[abi(embed_v0)]
    impl CounterImpl of ICounter<ContractState>{
        fn get_counter (self: @ContractState ) -> u32 {
            self.counter.read()
        }

        fn increase_counter (ref self: ContractState) {
            let is_active = self.kill_switch.read().is_active();
            if is_active {
                let currentValue = self.get_counter();
                let newValue = currentValue + 1;
                self.counter.write(newValue);
                self.emit(CounterIncreased {counter: self.counter.read()});
            }
        }

    }

}