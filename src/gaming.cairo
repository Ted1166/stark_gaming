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
                } else if  num == guess {
                    let id = self.guess_id.read();
                    
                }
            } 
        }
        
        fn reset(ref self:ContractState) {}

        fn get_message(ref self:ContractState, key:u128){}
    }

    #[generate_trait]
    impl numberImpl of numberTrait {
        fn _random_number(ref self:ContractState)  {
            
        }
    }
    
}