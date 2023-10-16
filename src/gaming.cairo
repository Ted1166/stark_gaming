#[starknet::interface]
trait gameTrait<TContractState> {
    fn reset(ref self:TContractState);
    fn user_number(ref self:TContractState, guess:u128);
    fn get_message(ref self:TContractState, key:u128);
}

#[starknet::contract]
mod game{
    use starknet::ContractAddress;
    use starknet::get_caller_address;
    use debug::PrintTrait;
    use starknet::get_block_timestamp;

    const DEADLINE: u64 = 1234567890;

    #[storage]
    struct Storage {
        guess: u128,
        message: LegacyMap::<u128, felt252>,
        guess_id: u128,    
    }

    #[constructor]
    fn constructor(ref self:ContractState) {
        self.guess.write(0);
    }

    #[external(v0)]
    impl gameImpl of super::gameTrait<ContractState> {
        fn user_number(ref self:ContractState, guess:u128){
            let value = guess;
            if value >= 0  &&  value <= 100 {
                let num = self.guess.read();
                
                if num == guess {
                    let id = self.guess_id.read()+1;
                    self.guess_id.write(id);
                    self.message.write(id, "Success");
                    self.guess.write(0);
                } else if  num > guess {
                    let id = self.guess_id.read();
                    self.message.write(id, "Too low");    
                } else if num < guess {
                    let id = self.guess_id.read();
                    self.message.write(id, "Too high");
                }
            } 
        }
        
        fn reset(ref self:ContractState) {
            self.guess.write(0);
        }

        fn get_message(ref self:ContractState, key:u128){
            let message = self.message.read(key);
            message.print();
        }
    }

    #[generate_trait]
    impl numberImpl of numberTrait {
        fn _random_number(ref self:ContractState, deadline:u64)  {
            assert(get_block_timestamp() > deadline,"Redeeming before deadline");
        }
    }
    
}