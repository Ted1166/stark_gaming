#[starknet::interface]
trait gameTrait<TContractState> {
    fn reset(ref self:TContractState);
    fn random_number(ref self:TContractState, guess:u128);
    fn get_message(ref self:TContractState, key:u128);
}

#[starknet::contract]
mod game{
    use starknet::ContractAddress;
    use starknet::get_caller_address;

    #[storage]
    struct Storage {
        guess: u128,
        message: LegacyMap::<u128, felt252>    
    }

    #[constructor]
    fn constructor(ref self:ContractState) {
        self.guess.write(0);
    }

    #[external(v0)]
    impl gameImpl of super::gameTrait<ContractState> {
        fn random_number(ref self:ContractState, guess:u128){
            
        }
        fn reset(ref self:ContractState) {}
    } 
    
}